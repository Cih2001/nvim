-- parse //+buildkintegration unit
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

	return tags
end

local function find_parent_function(node)
	if not node then
		return
	end

	local type_patterns = { "function", "method" }
	local node_type = node:type()
	for _, rgx in ipairs(type_patterns) do
		if node_type:find(rgx) then
			return node
		end
	end

	return find_parent_function(node:parent())
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
	local test_tree = {}
	local ft = vim.api.nvim_get_option_value("filetype", {})
	assert(ft == "go", "can only debug go files, not " .. ft)

	local test_query = vim.treesitter.query.parse(ft, q)
	assert(test_query, "could not parse test query")
	for _, nodes, _ in test_query:iter_matches(root, 0, 0, 0) do
		local test_match = {}
		for id, node in pairs(nodes) do
			local capture = test_query.captures[id]
			local tsnode = node
			-- there is an api change in 0.11.0
			if vim.version.ge(vim.version(), { 0, 10, 9 }) then
				tsnode = node[1]
			end
			if capture == "method.receiver.type" then
				test_match.receiver = vim.treesitter.get_node_text(tsnode, 0)
			elseif capture == "method.name" then
				test_match.name = vim.treesitter.get_node_text(tsnode, 0)
			elseif capture == "test.name" then
				test_match.name = vim.treesitter.get_node_text(tsnode, 0)
			elseif capture == "parent" then
				test_match.node = tsnode
			end
		end
		table.insert(test_tree, test_match)
	end

	return test_tree
end

local function get_closest_test()
	local root = find_parent_function(vim.treesitter.get_node())
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
		path = vim.api.nvim_buf_get_name(0):match("(.*/)"),
		tags = get_build_tags(),
		line = tonumber(root:start(), 10),
	}

	return result
end

local function build_test_cmd(test)
	local cmd = { "go test" }
	table.insert(cmd, test.path)
	table.insert(cmd, "-v -p 1 -count=1")

	local tags = table.concat(test.tags, " ")
	if not (tags == "") then
		table.insert(cmd, '-tags="' .. tags .. '"')
	end

	if test.name then
		table.insert(cmd, "-run")
		if test.receiver then
			table.insert(cmd, test.receiver .. "/" .. test.name)
		else
			table.insert(cmd, test.name)
		end
	end

	return table.concat(cmd, " ")
end

local function create_floating_window(opts)
	opts = opts or {}
	local width = opts.width or math.floor(vim.o.columns * 0.8)
	local height = opts.height or math.floor(vim.o.lines * 0.8)

	-- Calculate the position to center the window
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	local buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer

	-- Define window configuration
	local win_config = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal", -- No borders or extra UI elements
		border = "rounded",
		noautocmd = true,
	}

	-- Create the floating window
	local win = vim.api.nvim_open_win(buf, true, win_config)

	return { buf = buf, win = win }
end

local M = {}

function M.run_current_test()
	local test = get_closest_test()
	if test == nil then
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()
	local ns = vim.api.nvim_create_namespace("gotest")

	local cmd = build_test_cmd(test)
	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

	local win = create_floating_window()
	if vim.bo[win.buf].buftype ~= "terminal" then
		vim.cmd.terminal()
	end

	local job_id = vim.bo[win.buf].channel
	vim.fn.chansend(job_id, { cmd .. "\r\n" })
end

return M
