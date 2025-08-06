
local M = {}

function M.setup()
  local function get_fg(group)
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
    if ok and hl and hl.fg then
      return string.format("#%06x", hl.fg)
    end
    return nil
  end

  -- Dynamically pull fg colors from current theme
  local green   = get_fg("DiffAdd")     or "#50fa7b"
  local yellow  = get_fg("WarningMsg")  or "#f1fa8c"
  local red     = get_fg("ErrorMsg")    or "#ff5555"
  local gray    = get_fg("Comment")     or "#6272a4"
  local subtle  = get_fg("LineNr")      or "#5c6370"

  -- Link to standard highlight groups
  vim.api.nvim_set_hl(0, "FkNotesBlueButton", { link = "Button" })
  vim.api.nvim_set_hl(0, "FkNotesRedButton", { link = "ErrorMsg" })
  vim.api.nvim_set_hl(0, "FkNotesTitle", { link = "Title" })
  vim.api.nvim_set_hl(0, "FkNotesComment", { link = "Comment" })
  vim.api.nvim_set_hl(0, "FkNotesIdentifier", { link = "Identifier" })
  vim.api.nvim_set_hl(0, "FkNotesFunction", { link = "Function" })
  vim.api.nvim_set_hl(0, "FkNotesStatement", { link = "Statement" })
  vim.api.nvim_set_hl(0, "FkNotesType", { link = "Type" })

  -- Task status highlights (using dynamic colors)
  vim.api.nvim_set_hl(0, "FkNotesDone",    { fg = green, bold = true })
  vim.api.nvim_set_hl(0, "FkNotesSoon",    { fg = yellow, bold = true })
  vim.api.nvim_set_hl(0, "FkNotesExpired", { fg = red, bold = true })
  vim.api.nvim_set_hl(0, "FkNotesPending", { fg = gray })
  vim.api.nvim_set_hl(0, "FkNotesNone",    { fg = subtle })

  -- Footer/Header links
  vim.api.nvim_set_hl(0, "FkNotesHeader",  { link = "FkNotesTitle" })
  vim.api.nvim_set_hl(0, "FkNotesFooter",  { link = "FkNotesComment" })
  vim.api.nvim_set_hl(0, "FkNotesFooter2", { link = "FkNotesType" })
end

return M
