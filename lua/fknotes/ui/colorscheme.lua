
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

  -- FkNotes specific highlight groups for task statuses and UI elements
  vim.api.nvim_set_hl(0, "FkNotesDone",    { fg = "#50fa7b", bold = true })   -- Green for done tasks
  vim.api.nvim_set_hl(0, "FkNotesSoon",    { fg = "#f1fa8c", bold = true })   -- Yellow for tasks due soon
  vim.api.nvim_set_hl(0, "FkNotesExpired", { fg = "#ff5555", bold = true })   -- Red for expired tasks
  vim.api.nvim_set_hl(0, "FkNotesPending", { fg = "#50fa7b" })   -- Green for pending tasks
  vim.api.nvim_set_hl(0, "FkNotesNone",    { fg = "#6272a4" })   -- Gray for tasks with no due date

  vim.api.nvim_set_hl(0, "FkNotesHeader",  { link = "FknotesTitle" })
  vim.api.nvim_set_hl(0, "FkNotesFooter",  { link = "FknotesComment" })
  vim.api.nvim_set_hl(0, "FkNotesFooter2", { link = "FknotesType" })
end

return M
