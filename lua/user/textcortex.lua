local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")

-- This test paragraph contains some intentional errors.
--
-- Exercise has numerous benefits for the body and the mind. It can improved cardiovascular health,
-- increased strength and flexibility, and reduced the risk of chronic diseases such as
-- obesity, type 2 diabetes, and heart disease. In addition to physical benefits,
-- exercise have been shown to improved mood.
-- function and mental clarity. Regular physical activity can also helped to improved sleep quality
-- and duration. Whether you preferred to participate in organized sports, go for a jog,
-- or simply take a walk around the block, there are countless ways to incorporate exercise into
-- your daily routine. The key is to find an activity that you enjoyed and to make it
-- a consistent part of your lifestyle. So if you want to feel better, both
-- physically and mentally, start incorporating exercise into your routine today!
--

-- This test paragraph contains some intentional errors. This
-- is the second item. And this is the third.

local M = {
	callback = function(selection)
		vim.fn.execute("normal! vis")
		local right = vim.fn.getpos("'>")
		local right_row = right[2] - 1
		local right_col = right[3] - 1

		local left = vim.fn.getpos("'<")
		local left_row = left[2] - 1
		local left_col = left[3] - 1
		vim.pretty_print(vim.api.nvim_buf_get_text(0, left_row, left_col, right_row, right_col, {}))
		-- vim.pretty_print(vim.fn.getpos("'>"))
		-- vim.pretty_print(vim.fn.getpos({ "some" }))
		-- vim.api.nvim_put({ selection[1] }, "", false, true)
	end,
}

local function getCurrentSentence()
	vim.fn.execute('normal! vis"0y')
	local sentence = vim.fn.getreg("0")

	sentence = string.gsub(sentence, "%s+", " ")
	sentence = string.gsub(sentence, "%s*%-%-%s*", " ")
	sentence = string.gsub(sentence, "%s*$", "")
	return sentence
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
		temperature = 100,
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
		table.insert(items, obj.text)
	end

	return items
end

local sentence = getCurrentSentence()
-- local items = makeRequest(sentence)
local items = { "some", "suggestions" }
M.selectSuggestions(require("telescope.themes").get_dropdown({}), items, sentence)

-- this is a test.
--
--
