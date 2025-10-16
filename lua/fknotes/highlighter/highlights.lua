
local M = {}

-- Safely fetch color from highlight group
local function hl_color(group, attr)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group })
  if ok and hl and hl[attr] then
    return string.format("#%06x", hl[attr])
  end
end

-- Blend fallback colors with theme tones
function M.setup()
  local set_hl = vim.api.nvim_set_hl

  -- Try pulling dynamic colors from the current theme
  local accent = {
    blue = hl_color("Function", "fg") or "#2563EB",
    red = hl_color("Error", "fg") or "#DC2626",
    yellow = hl_color("WarningMsg", "fg") or "#FACC15",
    green = hl_color("String", "fg") or "#16A34A",
    purple = hl_color("Keyword", "fg") or "#9333EA",
    orange = hl_color("Constant", "fg") or "#F59E0B",
    teal = hl_color("Type", "fg") or "#0D9488",
    grey = hl_color("Comment", "fg") or "#808080",
  }

  -- Keyword (@fknotes)
  set_hl(0, "FkNotesKeyword", { fg = accent.yellow, bold = true })

  -- Main Tags & Titles
  local tag_palette = {
    TODO = { color = accent.blue },
    FIX = { color = accent.red },
    NOTE = { color = accent.orange },
    WARN = { color = accent.yellow },
    PERF = { color = accent.green },
    HACK = { color = accent.purple },
    TASK = { color = accent.teal },
  }
  for name, spec in pairs(tag_palette) do
    -- For the tag like "TODO:"
    set_hl(0, "FkNotesTag" .. name, { fg = "#FFFFFF", bg = spec.color, bold = true })
    -- For the title text
    set_hl(0, "FkNotesTitle" .. name, { fg = spec.color })
  end

  -- Priorities
  set_hl(0, "FkNotesPriorityHigh", { fg = accent.red, bold = true })
  set_hl(0, "FkNotesPriorityMedium", { fg = accent.orange, bold = true })
  set_hl(0, "FkNotesPriorityLow", { fg = accent.green, bold = true })

  -- Meta info (date, #tags)
  set_hl(0, "FkNotesMeta", { fg = "#FFFFFF", italic = true })
end

return M
