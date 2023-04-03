-- run `go test`
local ts_query = require("vim.treesitter.query")
local ts_utils = require("nvim-treesitter.ts_utils")

-- parse //+build integration unit
-- //go:build ci
local function get_build_tags(buf)
	local tags = {}
	buf = buf or "%"
	local pattern = [[^//\s*[+|(go:)]*build\s\+\(.\+\)]]
	local cnt = vim.fn.getbufinfo(buf)[1]["linecount"]
	cnt = math.min(cnt, 10)
	for i = 1, cnt do
		local line = vim.fn.trim(vim.fn.getbufline(buf, i)[1])
		if string.find(line, "package") then
			break
		end
		local t = vim.fn.substitute(line, pattern, [[\1]], "")
		if t ~= line then -- tag found
			t = vim.fn.substitute(t, [[ \+]], ",", "g")
			table.insert(tags, t)
		end
	end
	if #tags > 0 then
		return tags
	end
end

local is_function = function(node)
	local type_patterns = { "function", "method", "class" }
	local node_type = node:type()
	for _, rgx in ipairs(type_patterns) do
		if node_type:find(rgx) then
			return true
		end
	end

	return false
end

local function find_parent_function(node)
	local parent = node
	while parent do
		if is_function(parent) then
			break
		end
		parent = parent:parent()
	end

	return parent
end

local function get_closest_function()
	local current_node = ts_utils.get_node_at_cursor()
	local parent = find_parent_function(current_node)
	return parent
end

local query_test_suite = [[
(method_declaration
  receiver: (parameter_list (parameter_declaration (pointer_type (type_identifier)@method.receiver.type)))
  name: (field_identifier)@method.name
  (#match? @method.name "^Test.+$")
  )@parent
]]

local query_tests = [[
(function_declaration
  name: (identifier) @test.name
  parameters: (parameter_list . (parameter_declaration type: (pointer_type) @type) .)
  (#match? @type "*testing.(T|M)")
  (#match? @test.name "^Test.+$"))@parent
]]

local function match_query(q, root)
	local ft = vim.api.nvim_buf_get_option(0, "filetype")
	assert(ft == "go", "can only debug go files, not " .. ft)

	local test_tree = {}

	local test_query = vim.treesitter.query.parse(ft, q)
	assert(test_query, "could not parse test query")
	for _, match, _ in test_query:iter_matches(root, 0, 0, 0) do
		local test_match = {}
		for id, node in pairs(match) do
			local capture = test_query.captures[id]
			if capture == "method.receiver.type" then
				test_match.receiver = vim.treesitter.get_node_text(node, 0)
			elseif capture == "method.name" then
				test_match.name = vim.treesitter.get_node_text(node, 0)
			elseif capture == "test.name" then
				test_match.name = vim.treesitter.get_node_text(node, 0)
			elseif capture == "parent" then
				test_match.node = node
			end
		end
		table.insert(test_tree, test_match)
	end

	return test_tree
end

local function getPath(str)
	local sep = "/"
	return str:match("(.*" .. sep .. ")")
end

local function get_closest_test()
	local root = get_closest_function()
	if root == nil then
		return nil
	end

	local suite_test = match_query(query_test_suite, root)
	local test = suite_test
	if suite_test == nil or #suite_test == 0 then
		test = match_query(query_tests, root)
	end

	if test == nil or #test == 0 then
		return nil
	end

	local result = {
		name = test[1].name,
		receiver = test[1].receiver,
		path = getPath(vim.api.nvim_buf_get_name(0)),
		tags = get_build_tags(),
		line = tonumber(root:start(), 10),
	}

	return result
end

local function build_test_cmd(test)
	local cmd = "cd ./api && go test "
	if not (test.path == "") then
		cmd = cmd .. test.path
	end
	cmd = cmd .. " -v -p 1 -count=1 -json "

	local tags = ""
	if test.tags then
		for _, tag in ipairs(test.tags) do
			tags = tags .. tag .. " "
		end
	end
	if not (tags == nil) and not (tags == "") then
		cmd = cmd .. '-tags="' .. tags .. '" '
	end

	if not (test.name == nil) then
		cmd = cmd .. "-run "
		if not (test.receiver == nil) then
			cmd = cmd .. test.receiver .. "/"
		end
		cmd = cmd .. test.name
	end

	return cmd
end

local M = {
	state = {},
}

local function get_namespace()
	local ns = 0
	for key, value in pairs(vim.api.nvim_get_namespaces()) do
		if key == "gotest" then
			ns = value
		end
	end

	if ns == 0 then
		ns = vim.api.nvim_create_namespace("gotest")
	end

	return ns
end

function M.run_current_test()
	local test = get_closest_test()
	if test == nil then
		return
	end

	if test.tags == nil then
		test.tags = { "unsafe" }
	else
		table.insert(test.tags, "unsafe")
	end

	local bufnr = vim.api.nvim_get_current_buf()
	local ns = get_namespace()

	local cmd = build_test_cmd(test)
	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
	M.outputs = {}

	vim.fn.jobstart(cmd, {
		stdout_buffered = true,
		on_stderr = function(_, data)
			for _, line in ipairs(data) do
				table.insert(M.outputs, line)
			end
		end,
		on_stdout = function(_, data)
			if not data then
				return
			end

			for _, line in ipairs(data) do
				if not line or line == "" then
					goto continue
				end

				-- local line_output = string.gsub(line, "\n", "")
				-- line_output = string.gsub(line_output, "\r", "")
				-- table.insert(M.outputs, line_output)
				local decoded = vim.json.decode(line)

				if decoded.Action == "run" then
					M.state = {
						packate = decoded.Package,
						test = test.Test,
						result = "none",
					}
				elseif decoded.Action == "output" then
					local output = string.gsub(decoded.Output, "\n", "")
					output = string.gsub(output, "\r", "")
					table.insert(M.outputs, output)
				elseif decoded.Action == "pass" or decoded.Action == "fail" then
					if M.state.result == decoded.Action then
						goto continue
					end

					M.state.result = decoded.Action
					local text = ""
					if decoded.Action == "fail" then
						text = ""
					end

					local opts = {
						virt_text = { { text } },
						virt_text_pos = "eol",
					}
					vim.api.nvim_buf_set_extmark(bufnr, ns, test.line, 0, opts)
				end
				::continue::
			end
		end,
		on_exit = function()
			local buf = vim.api.nvim_create_buf(false, true)
			local uis = vim.api.nvim_list_uis()[1]
			local width = uis.width - 40
			local height = uis.height - 20
			vim.api.nvim_open_win(buf, true, {
				relative = "win",
				row = (uis.height / 2) - (height / 2),
				col = (uis.width / 2) - (width / 2),
				width = width,
				height = height,
				style = "minimal",
				border = "single",
				noautocmd = true,
			})
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, { cmd })
			vim.api.nvim_buf_set_lines(buf, 1, -1, false, M.outputs)
			-- Set mappings in the buffer to close the window easily
			local closingKeys = { "<Esc>", "<CR>", "<Leader>" }
			for _, k in ipairs(closingKeys) do
				vim.api.nvim_buf_set_keymap(buf, "n", k, ":close<CR>", { silent = true, nowait = true, noremap = true })
			end
		end,
	})
end

return M
