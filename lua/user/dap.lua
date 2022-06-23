local dap_go_status, dapgo = pcall(require, "dap-go")
if not dap_go_status then
  return
end

local dapui_status, dapui = pcall(require, "dapui")
if not dapui_status then
  return
end

local nvim_dap_virtual_text_status, ndvts = pcall(require, "nvim-dap-virtual-text")
if not nvim_dap_virtual_text_status then
  return
end

dapgo.setup()
dapui.setup({
  -- Layouts define sections of the screen to place windows.
  -- The position can be "left", "right", "top" or "bottom".
  -- The size specifies the height/width depending on position.
  -- Elements are the elements shown in the layout (in order).
  -- Layouts are opened in order so that earlier layouts take priority in window sizing.
  layouts = {
    {
      elements = {
        "watches",
      },
      size = 5,
      position = "bottom",
    },
    {
      elements = {
        "repl",
      },
      size = 10,
      position = "bottom",
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
  }
})
ndvts.setup()

