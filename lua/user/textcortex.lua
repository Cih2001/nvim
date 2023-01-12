local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")

-- This test paragraph contains some intentional errors.
-- There are many benefits to exercise for both the body and the mind. Regular exercise can improve
-- cardiovascular health, increased strength and flexibility, and reduce
-- the risk of chronic diseases such as obesity, type 2 diabetes, and heart disease.
-- Exercise has been shown to improve mood, both physically and emotionally.
-- Regular physical activity can help improve sleep quality and duration.
-- There are countless ways to get active each day, whether you prefer to participate in organized
-- sports, go for a jog, or simply take a walk around the block.
-- Making an activity you enjoyed into a regular part of your life is essential.
-- Physical exercise can help you feel better both mentally and physically.
-- Start incorporating it into your routine today!
--

local M = {
	callback = function(selection)
		vim.fn.execute("normal! vis")
		local left = vim.fn.getpos("'<")
		local left_row = left[2] - 1
		local left_col = left[3] - 1
		local right = vim.fn.getpos("'>")
		local right_row = right[2] - 1
		local right_col = right[3]

		vim.fn.execute("normal! <cr>")
		local text = vim.api.nvim_buf_get_text(0, left_row, left_col, right_row, right_col, {})
		vim.pretty_print(text)
		vim.api.nvim_buf_set_text(0, left_row, left_col, right_row, right_col, { selection[1] })
		-- vim.fn.execute("normal! vis")
		-- vim.pretty_print(vim.fn.getpos("'>"))
		-- vim.pretty_print(vim.fn.getpos({ "some" }))
		-- vim.api.nvim_put({ selection[1] }, "", false, true)
	end,
}

local function trimSentence(sentence)
	local result = string.gsub(sentence, "%s+", " ")
	result = string.gsub(result, "%s*%-%-%s*", " ")
	result = string.gsub(result, "%s*//%s*", " ")
	result = string.gsub(result, "%s+$", "")
	result = string.gsub(result, "^%s+", "")
	vim.pretty_print(result)
	return result
end

local function getCurrentSentence()
	vim.fn.execute('normal! vis"0y')
	local prev = vim.fn.getreg("0")

	local new = trimSentence(prev)
	while new ~= prev do
		prev = new
		new = trimSentence(prev)
	end

	return new
end

function M.selectSuggestions(opts, items, text)
	opts = opts or {}
	pickers
		.new(opts, {
			prompt_title = "Suggestions",
			finder = finders.new_table({
				results = items,
			}),
			previewer = previewers.new_buffer_previewer({
				title = "preview changes",
				wrap = true,
				define_preview = function(self, entry, status)
					vim.api.nvim_win_set_option(status.preview_win, "wrap", true)
					vim.api.nvim_win_set_option(status.preview_win, "linebreak", true)
					vim.api.nvim_win_set_option(status.preview_win, "list", false)
					vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, { text, "", entry[1] })
				end,
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					M.callback(action_state.get_selected_entry())
				end)
				return true
			end,
		})
		:find()
end

-- These commands move over three kinds
-- of text objects.
-- vim.cmd("normal! vis") << select a sentence
local function makeRequest(text)
	local curl = require("plenary.curl")
	local request = {
		template_name = "paraphrase",
		prompt = {
			original_sentence = text,
		},
		temperature = 0.1,
		token_count = math.floor(text:len() / 4),
		n_gen = 3,
		source_language = "en",
		api_key = "gAAAAABjtsdb5TKbqPN0V6v2zrmRNkToLv7rf_1sGronwBVjWeQXJp793hhqY-S8RHzDbwoEL8bxOmdtMHnxM672J-89K_2oU7ToGb-Zygv6GcXK1cLyTxwGFzbgmM27_sCMrLn6IZv-",
	}

	local res = curl.post("https://api.textcortex.com/hemingwai/generate_text_v3/", {
		body = vim.fn.json_encode(request),
		headers = {
			content_type = "application/json",
		},
	})

	if res.status ~= 200 then
		print("an error happened: ", res.status)
		return
	end

	local resp = vim.fn.json_decode(res.body)
	local items = {}
	if resp == nil then
		print("empty resp")
		return
	end

	for _, obj in ipairs(resp.generated_text) do
		table.insert(items, trimSentence(obj.text))
	end

	return items
end

local sentence = getCurrentSentence()
local items = makeRequest(sentence)
-- local items = { trimSentence("some very looooo\noooooooooooooooooooooooooooooooooooong item.") }
M.selectSuggestions(require("telescope.themes").get_dropdown({}), items, sentence)
