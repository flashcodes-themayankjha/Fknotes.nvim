local M = {}

local defaults = {
  ui = {
    menu_width = 50,
    menu_height = 15,
    border_style = "single",
  },
}

M.config = {}

function M.setup(config)
  M.config = vim.tbl_deep_extend("force", defaults, config or {})
end

function M.get()
  return M.config
end

return M
