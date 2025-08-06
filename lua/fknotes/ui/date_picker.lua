
local Popup = require("nui.popup")
local Menu = require("nui.menu")
local Text = require("nui.text")
local event = require("nui.utils.autocmd").event

local M = {}

local current_date = os.date("*t") -- Current date table {year, month, day}
local popup = nil
local on_select_callback = nil

-- Helper: Get days in a month
local function days_in_month(year, month)
  local t = os.time({ year = year, month = month + 1, day = 0 })
  return tonumber(os.date("%d", t))
end

-- Helper: Weekday of first of month (0 = Monday)
local function first_weekday(year, month)
  local t = os.time({ year = year, month = month, day = 1 })
  return (os.date("%w", t) + 6) % 7
end

-- Render the calendar grid
local function render_calendar()
  local year = current_date.year
  local month = current_date.month
  local days = days_in_month(year, month)
  local first_day_wday = first_weekday(year, month)

  local lines = {}

  -- Styled header
  local header_str = "  " .. os.date("%B %Y", os.time({ year = year, month = month, day = 1 })) .. "  "
  table.insert(lines, header_str)

  table.insert(lines, "") -- spacer
  table.insert(lines, "  Mo Tu We Th Fr Sa Su")

  local day_counter = 1
  local current_week_days = {}
  local grid_lines = {}

  -- Leading spaces for first week
  for _ = 0, first_day_wday - 1 do
    table.insert(current_week_days, "  ")
  end

  while day_counter <= days do
    table.insert(current_week_days, string.format("%2d", day_counter))
    if #current_week_days == 7 then
      table.insert(grid_lines, "  " .. table.concat(current_week_days, " "))
      current_week_days = {}
    end
    day_counter = day_counter + 1
  end

  if #current_week_days > 0 then
    while #current_week_days < 7 do
      table.insert(current_week_days, "  ")
    end
    table.insert(grid_lines, "  " .. table.concat(current_week_days, " "))
  end

  for _, line in ipairs(grid_lines) do
    table.insert(lines, line)
  end

  table.insert(lines, "")
  table.insert(lines, "  < Prev Month   Next Month >")

  -- Write to buffer
  local buf = popup.bufnr
  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  -- Highlight the header manually
  vim.api.nvim_buf_add_highlight(buf, -1, "FkNotesHeader", 0, 0, -1)
end

-- Go to previous month
local function prev_month()
  current_date.month = current_date.month - 1
  if current_date.month == 0 then
    current_date.month = 12
    current_date.year = current_date.year - 1
  end
  render_calendar()
end

-- Go to next month
local function next_month()
  current_date.month = current_date.month + 1
  if current_date.month == 13 then
    current_date.month = 1
    current_date.year = current_date.year + 1
  end
  render_calendar()
end

-- Select a date
local function select_date(day)
  local selected_date_str = string.format("%04d-%02d-%02d", current_date.year, current_date.month, day)
  if on_select_callback then
    on_select_callback(selected_date_str)
  end
  popup:unmount()
end

-- Main entry point
function M.open(callback)
  on_select_callback = callback
  current_date = os.date("*t")

  popup = Popup({
    position = "50%",
    size = { width = 30, height = 15 },
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
      text = {
        top = Text(" Select Due Date ", "FkNotesHeader"),
        bottom = Text("  [h/l] Month | [j/k] Day | [Enter] Select ", "FkNotesFooter2"),
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:FknotesComment",
      cursorline = false,
      number = false,
      relativenumber = false,
    },
  })

  popup:mount()
  render_calendar()

  -- Navigation keys
  popup:map("n", "h", prev_month, { noremap = true })
  popup:map("n", "l", next_month, { noremap = true })
  popup:map("n", "<left>", prev_month, { noremap = true })
  popup:map("n", "<right>", next_month, { noremap = true })

  -- Enter to select current day
  popup:map("n", "<cr>", function()
    select_date(current_date.day)
  end, { noremap = true })

  -- ESC to close
  popup:map("n", "<esc>", function()
    popup:unmount()
  end, { noremap = true })

  -- Auto close on buffer leave
  popup:on(event.BufLeave, function()
    popup:unmount()
  end)
end

return M
