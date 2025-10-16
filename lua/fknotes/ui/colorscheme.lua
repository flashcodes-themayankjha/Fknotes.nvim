
local M = {}

function M.setup()
  local config = require("fknotes.config").get()
  local colorscheme_name = config.ui.colorscheme

  if colorscheme_name then
    vim.cmd("colorscheme " .. colorscheme_name)
  end

  local function get_fg(group, fallback)
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
    if ok and hl and hl.fg then
      return string.format("#%06x", hl.fg)
    end
    return fallback
  end

  -- Catppuccin Mocha fallbacks
  local fallback_colors = {
    green   = "#a6da95",
    yellow  = "#f9e2af",
    red     = "#f38ba8",
    gray    = "#6c7086",
    peach   = "#f5a97f",
    title   = "#f0c6c6",
    grey    = "#939ab7",
    subtle  = "#585b70",
    pink    = "#f5bde6", -- for selected date
  }

  -- Try getting from current theme, else fallback to Catppuccin
  local green   = get_fg("DiffAdd",      fallback_colors.green)
  local yellow  = get_fg("WarningMsg",   fallback_colors.yellow)
  local red     = get_fg("ErrorMsg",     fallback_colors.red)
  local comment_color = get_fg("Comment", fallback_colors.gray)
  local normal_fg = get_fg("Normal", "#FFFFFF")

  -- Link common groups
  vim.api.nvim_set_hl(0, "FkNotesBlueButton", { link = "Function" })
  vim.api.nvim_set_hl(0, "FkNotesRedButton", { link = "ErrorMsg" })
  vim.api.nvim_set_hl(0, "FkNotesTitle", { link = "Title" })
  vim.api.nvim_set_hl(0, "FkNotesComment", { link = "Comment" })
  vim.api.nvim_set_hl(0, "FkNotesIdentifier", { link = "Identifier" })
  vim.api.nvim_set_hl(0, "FkNotesFunction", { link = "Function" })
  vim.api.nvim_set_hl(0, "FkNotesStatement", { link = "Statement" })
  vim.api.nvim_set_hl(0, "FkNotesType", { link = "Type" })

  -- Task status groups
  vim.api.nvim_set_hl(0, "FkNotesDone",    { fg = green, bold = true })
  vim.api.nvim_set_hl(0, "FkNotesSoon",    { fg = yellow, bold = true })
  vim.api.nvim_set_hl(0, "FkNotesExpired", { fg = red, bold = true })
  vim.api.nvim_set_hl(0, "FkNotesPending", { fg = normal_fg })
  vim.api.nvim_set_hl(0, "FkNotesNone",    { fg = comment_color })

  -- Header/footer
  vim.api.nvim_set_hl(0, "FkNotesHeader",  { link = "FkNotesTitle" })
  vim.api.nvim_set_hl(0, "FkNotesFooter",  { link = "FkNotesComment" })
  vim.api.nvim_set_hl(0, "FkNotesFooter2", { link = "FkNotesType" })

  -- Selected date in calendar
    vim.api.nvim_set_hl(0, "FkNotesSelectedDate", {fg = "pink", bold = true })
end

return M
