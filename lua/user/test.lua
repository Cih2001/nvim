--[[
 To use a Lua library in Neovim, you need to install it and then load it in your Neovim configuration file. Here are the steps to install and use a Lua
library in Neovim:
1. Install the Lua library using LuaRocks. For example, to install the Lua YAML library, run the following command in your terminal:
   ```
   luarocks install yaml
   ```
2. Load the Lua library in your Neovim configuration file. For example, to load the Lua YAML library, add the following line to your `init.lua` file:
   ```
   local yaml = require("yaml")
   ```
   This will load the Lua YAML library and make its functions available in your Neovim configuration.
3. Use the Lua library in your Neovim configuration. For example, to parse a YAML file, you can use the `load()` function from the Lua YAML library:
   ```
   local file = io.open("example.yaml", "r")
   local data = yaml.load(file:read("*all"))
   file:close()
   ```
   This will read the contents of the `example.yaml` file, parse it using the Lua YAML library, and store the resulting data in the `data` variable.
You do not need to build the Lua library yourself, as LuaRocks will handle the installation and compilation of the library for you.
--]]
local yaml = require("yaml")
local NuiTree = require("nui.tree")
local Split = require("nui.split")
local NuiLine = require("nui.line")

local file = io.open("/home/hamidreza/example.yaml", "r")
local data = yaml.eval(file:read("*all"))
vim.print(data)
file:close()

local split = Split({
	relative = "win",
	position = "left",
	size = 30,
})

split:mount()

-- quit
split:map("n", "q", function()
	split:unmount()
end, { noremap = true })

local tree = NuiTree({
	winid = split.winid,
	nodes = {
		NuiTree.Node({ text = "a" }),
		NuiTree.Node({ text = "b" }, {
			NuiTree.Node({ text = "b-1" }),
			NuiTree.Node({ text = "b-2" }, {
				NuiTree.Node({ text = "b-1-a" }),
				NuiTree.Node({ text = "b-2-b" }),
			}),
		}),
		NuiTree.Node({ text = "c" }, {
			NuiTree.Node({ text = "c-1" }),
			NuiTree.Node({ text = "c-2" }),
		}),
	},
	prepare_node = function(node)
		local line = NuiLine()

		line:append(string.rep("  ", node:get_depth() - 1))

		if node:has_children() then
			line:append(node:is_expanded() and " " or " ", "SpecialChar")
		else
			line:append("  ")
		end

		line:append(node.text)

		return line
	end,
})

local map_options = { noremap = true, nowait = true }

-- print current node
split:map("n", "<CR>", function()
	local node = tree:get_node()
	print(vim.inspect(node))
end, map_options)

-- collapse current node
split:map("n", "h", function()
	local node = tree:get_node()

	if node:collapse() then
		tree:render()
	end
end, map_options)

-- collapse all nodes
split:map("n", "H", function()
	local updated = false

	for _, node in pairs(tree.nodes.by_id) do
		updated = node:collapse() or updated
	end

	if updated then
		tree:render()
	end
end, map_options)

-- expand current node
split:map("n", "l", function()
	local node = tree:get_node()

	if node:expand() then
		tree:render()
	end
end, map_options)

-- expand all nodes
split:map("n", "L", function()
	local updated = false

	for _, node in pairs(tree.nodes.by_id) do
		updated = node:expand() or updated
	end

	if updated then
		tree:render()
	end
end, map_options)

-- add new node under current node
split:map("n", "a", function()
	local node = tree:get_node()
	tree:add_node(
		NuiTree.Node({ text = "d" }, {
			NuiTree.Node({ text = "d-1" }),
		}),
		node:get_id()
	)
	tree:render()
end, map_options)

-- delete current node
split:map("n", "d", function()
	local node = tree:get_node()
	tree:remove_node(node:get_id())
	tree:render()
end, map_options)

tree:render()
