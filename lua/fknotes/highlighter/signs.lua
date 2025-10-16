
local M = {}

-- Helper to get colors dynamically from theme
local function hl_color(group, attr)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group })
  if ok and hl and hl[attr] then
    return string.format("#%06x", hl[attr])
  end
end

local accent = {
  blue = hl_color("Function", "fg") or "#2563EB",
  red = hl_color("Error", "fg") or "#DC2626",
  yellow = hl_color("WarningMsg", "fg") or "#FACC15",
  green = hl_color("String", "fg") or "#16A34A",
  purple = hl_color("Keyword", "fg") or "#9333EA",
  orange = hl_color("Constant", "fg") or "#F59E0B",
  teal = hl_color("Type", "fg") or "#0D9488",
}

local signs = {
  { name = "FkNotesTODO", icon = "", color = accent.blue },
  { name = "FkNotesFIX", icon = "", color = accent.red },
  { name = "FkNotesNOTE", icon = "", color = accent.orange },
  { name = "FkNotesWARN", icon = "", color = accent.yellow },
  { name = "FkNotesPERF", icon = "󰈸", color = accent.green },
  { name = "FkNotesHACK", icon = "", color = accent.purple },
  { name = "FkNotesTASK", icon = "", color = accent.teal },
  { name = "FkNotesDUE", icon = "󰥔", color = accent.yellow },
}

function M.get_signs()
  return signs
end

function M.setup()
  local fg_default = hl_color("Normal", "fg") or "#FFFFFF"

  -- Define the highlight and sign dynamically
  for _, sign in ipairs(signs) do
    local hl_name = sign.name
    vim.api.nvim_set_hl(0, hl_name, { fg = sign.color or fg_default, bold = true })
    vim.fn.sign_define(hl_name, { text = sign.icon, texthl = hl_name, numhl = "" })
  end
end

return M
