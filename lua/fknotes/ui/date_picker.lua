
local Popup = require("nui.popup")
local Text = require("nui.text")
local event = require("nui.utils.autocmd").event

local M = {}

local current_date = os.date("*t") -- Current date {year, month, day}
local selected_day = current_date.day
local popup = nil
local on_select_callback = nil

-- Days in month
local function days_in_month(year, month)
  local t = os.time({ year = year, month = month + 1, day = 0 })
  return tonumber(os.date("%d", t))
end

-- Weekday of 1st day of month (0 = Monday)
local function first_weekday(year, month)
  local t = os.time({ year = year, month = month, day = 1 })
  return (os.date("%w", t) + 6) % 7
end

-- Render calendar
local function render_calendar()
  local year = current_date.year
  local month = current_date.month
  local days = days_in_month(year, month)
  local first_day_wday = first_weekday(year, month)

  local lines = {}

  -- Header
  table.insert(lines, "  " .. os.date("%B %Y", os.time({ year = year, month = month, day = 1 })))
  table.insert(lines, "")
  table.insert(lines, "  Mo Tu We Th Fr Sa Su")

  local current_week_days = {}
  local day_counter = 1
  local day_positions = {} -- Track where each day is on the grid

  for _ = 0, first_day_wday - 1 do
    table.insert(current_week_days, "  ")
  end

  local row_index = 3 -- Line offset in buffer

  while day_counter <= days do
    table.insert(current_week_days, string.format("%2d", day_counter))
    if #current_week_days == 7 then
      local line = "  " .. table.concat(current_week_days, " ")
      table.insert(lines, line)
      for i, day_str in ipairs(current_week_days) do
        local day_num = tonumber(day_str)
        if day_num then
          day_positions[day_num] = { row = row_index, col = 2 + (i - 1) * 3 }
        end
      end
      current_week_days = {}
      row_index = row_index + 1
    end
    day_counter = day_counter + 1
  end

  -- Remaining days
  if #current_week_days > 0 then
    while #current_week_days < 7 do
      table.insert(current_week_days, "  ")
    end
    local line = "  " .. table.concat(current_week_days, " ")
    table.insert(lines, line)
    for i, day_str in ipairs(current_week_days) do
      local day_num = tonumber(day_str)
      if day_num then
        day_positions[day_num] = { row = row_index, col = 2 + (i - 1) * 3 }
      end
    end
  end

  table.insert(lines, "")
  table.insert(lines, "  < Prev Month   Next Month >")

  local buf = popup.bufnr
  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  -- Highlight header
  vim.api.nvim_buf_add_highlight(buf, -1, "FkNotesHeader", 0, 0, -1)

  -- Highlight selected day
  if day_positions[selected_day] then
    local pos = day_positions[selected_day]
    vim.api.nvim_buf_add_highlight(buf, -1, "FkNotesSelectedDate", pos.row, pos.col, pos.col + 2)
  end
end

-- Move selected day
local function move_day(delta)
  local max_day = days_in_month(current_date.year, current_date.month)
  selected_day = math.max(1, math.min(selected_day + delta, max_day))
  render_calendar()
end

-- Prev / next month
local function prev_month()
  current_date.month = current_date.month - 1
  if current_date.month == 0 then
    current_date.month = 12
    current_date.year = current_date.year - 1
  end
  selected_day = 1
  render_calendar()
end

local function next_month()
  current_date.month = current_date.month + 1
  if current_date.month == 13 then
    current_date.month = 1
    current_date.year = current_date.year + 1
  end
  selected_day = 1
  render_calendar()
end

-- Select date
local function select_date()
  local selected_date_str = string.format("%04d-%02d-%02d", current_date.year, current_date.month, selected_day)
  if on_select_callback then
    on_select_callback(selected_date_str)
  end
  popup:unmount()
end

-- Main entry
function M.open(callback)
  on_select_callback = callback
  current_date = os.date("*t")
  selected_day = current_date.day

  popup = Popup({
    position = "50%",
    size = { width = 40, height = 20 },
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
    },
  })

  popup:mount()
  render_calendar()


-- Month navigation
popup:map("n", "h", prev_month, { noremap = true })
popup:map("n", "<left>", prev_month, { noremap = true })

popup:map("n", "l", next_month, { noremap = true })
popup:map("n", "<right>", next_month, { noremap = true })

-- Day navigation
popup:map("n", "j", function() move_day(1) end, { noremap = true })
popup:map("n", "<down>", function() move_day(1) end, { noremap = true })

popup:map("n", "k", function() move_day(-1) end, { noremap = true })
popup:map("n", "<up>", function() move_day(-1) end, { noremap = true })

-- Confirm / exit
popup:map("n", "<cr>", select_date, { noremap = true })
popup:map("n", "<esc>", function() popup:unmount() end, { noremap = true })

  popup:on(event.BufLeave, function() popup:unmount() end)
end

return M
