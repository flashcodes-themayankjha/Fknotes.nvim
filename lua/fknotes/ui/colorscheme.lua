
local M = {}

function M.setup()
  -- Link Fknotes highlight groups to standard Neovim highlight groups
  vim.api.nvim_set_hl(0, "FknotesBlueButton", { link = "Button" })
  vim.api.nvim_set_hl(0, "FknotesRedButton", { link = "ErrorMsg" })
  vim.api.nvim_set_hl(0, "FknotesTitle", { link = "Title" })
  vim.api.nvim_set_hl(0, "FknotesComment", { link = "Comment" })
  vim.api.nvim_set_hl(0, "FknotesIdentifier", { link = "Identifier" })
  vim.api.nvim_set_hl(0, "FknotesFunction", { link = "Function" })
  vim.api.nvim_set_hl(0, "FknotesStatement", { link = "Statement" })
  vim.api.nvim_set_hl(0, "FknotesType", { link = "Type" })
end

return M
