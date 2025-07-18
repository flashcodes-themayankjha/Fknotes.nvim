
local M = {}

function M.setup()
  vim.api.nvim_set_hl(0, "fknotesbluebutton", { fg = "#7dcfff", bold = true })
  vim.api.nvim_set_hl(0, "fknotesredbutton", { fg = "#f7768e", bold = true })
  vim.api.nvim_set_hl(0, "title", { fg = "#bb9af7", bold = true })
  vim.api.nvim_set_hl(0, "comment", { fg = "#565f89", italic = true })
  vim.api.nvim_set_hl(0, "identifier", { fg = "#9ece6a", bold = true })
  vim.api.nvim_set_hl(0, "function", { fg = "#7aa2f7" })
  vim.api.nvim_set_hl(0, "statement", { fg = "#f7768e" })
  vim.api.nvim_set_hl(0, "type", { fg = "#2ac3de" })
end

return M
