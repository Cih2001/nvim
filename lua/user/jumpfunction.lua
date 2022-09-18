local parsers_status_ok, parsers = pcall(require, "nvim-treesitter.parsers")
if not parsers_status_ok then
  return
end

local ts_utils_status_ok, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
if not ts_utils_status_ok then
  return
end

local M = {}

local function get_root()
  local parser = parsers.get_parser()
  if parser == nil then
    return nil
  end

  return parser:parse()[1]:root()
end

local is_function = function(node)
  local type_patterns = {"function", "method", "class"}
  local node_type = node:type()
  for _, rgx in ipairs(type_patterns) do
    if node_type:find(rgx) then
      return true
    end
  end

  return false
end


local function find_first_function()
  local root = get_root()
  if root == nil then
    return nil
  end
  for node in root:iter_children() do
    if is_function(node) then
      return node
    end
  end

  return nil
end

local function find_next_function(node)
  if node == nil then
    return nil
  end

  node = ts_utils.get_next_node(node, true, true)
  while (not (node == nil)) and (not is_function(node)) do
    node = ts_utils.get_next_node(node, true, true)
  end

  return node
end

local function find_prev_function(node)
  if node == nil then
    return nil
  end

  node = ts_utils.get_previous_node(node, true, true)
  while (not (node == nil)) and (not is_function(node)) do
    node = ts_utils.get_previous_node(node, true, true)
  end

  return node
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

function M.jump_next_function()
  local current_node = ts_utils.get_node_at_cursor()
  local parent = find_parent_function(current_node)
  local next = nil
  if parent == nil then
    next = find_first_function()
  else
    next = find_next_function(parent)
  end
  if next == nil then
    return
  end
  local line = tonumber(next:start(), 10) + 1
  vim.api.nvim_win_set_cursor(0, {line, 0})
end

function M.jump_prev_function()
  local current_node = ts_utils.get_node_at_cursor()
  local parent = find_parent_function(current_node)
  local prev = nil
  if parent == nil then
    prev = find_first_function()
  else
    if parent == current_node then
      prev = find_prev_function(parent)
    else
      prev = parent
    end
  end
  if prev == nil then
    return
  end
  local line = tonumber(prev:start(), 10) + 1
  vim.api.nvim_win_set_cursor(0, {line, 0})
end

return M
