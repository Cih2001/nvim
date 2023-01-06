local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")

-- This test paragraph contains some intentional errors
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
local selectSuggestions = function(opts, items, text)
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
					local selection = action_state.get_selected_entry()
					vim.api.nvim_put({ selection[1] }, "", false, true)
				end)
				return true
			end,
		})
		:find()
end

local function getCurrentSentence()
	vim.fn.execute('normal! "0yis')
	local sentence = vim.fn.getreg("0")

	sentence = string.gsub(sentence, "%s+", " ")
	sentence = string.gsub(sentence, "%s*%-%-%s*", " ")
	sentence = string.gsub(sentence, "%s*$", "")
	return sentence
end

-- These commands move over three kinds
-- of text objects.
-- vim.cmd("normal! vis") << select a sentence
local function main(text)
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
		api_key = "gAAAAABjtxGs2XVsqQ6UqFrFcIqw8M5oL7X0_dkmdzRftFlZE8KIH_cSjeqVCxwvO2jx6EX2tFjCVY5XxBRf5V3EnsCDs9w_KfZDh352g1My8MK8UoHvDM3R1zbFlomhgcjOIgpmlzHL",
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

	selectSuggestions(require("telescope.themes").get_dropdown({}), items, text)
end

local sentence = getCurrentSentence()
print(sentence)
main(sentence)

-- print(vim.api.nvim_eval("expand('<sentence>')"))
