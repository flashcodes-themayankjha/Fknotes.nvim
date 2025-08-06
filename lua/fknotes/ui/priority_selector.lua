
-- lua/fknotes/ui/priority_selector.lua
local Popup = require("nui.popup")
local Text = require("nui.text")
local event = require("nui.utils.autocmd").event

local M = {}

local priorities = {
  { label = "🔴 High", value = "high" },
  { label = "🟠 Medium", value = "medium" },
  { label = "🟢 Low", value = "low" },
  { label = "⚪ None", value = "none" },
}

function M.open_priority_picker(callback)
  local selected = 1

  local popup = Popup({
    position = "50%",
    size = {
      width = 30,
      height = 8,
    },
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
      text = {
        top = Text(" Select Priority ", "FknotesTitle"),
        bottom = Text(" [↑↓] Move  [Enter] Choose  [q] Quit ", "FknotesComment"),
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:FknotesComment",
      cursorline = true,
    },
  })

  local function render()
    local lines = {}
    for i, item in ipairs(priorities) do
      local prefix = (i == selected) and "➤ " or "  "
      table.insert(lines, prefix .. item.label)
    end

    vim.api.nvim_buf_set_option(popup.bufnr, "modifiable", true)
    vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(popup.bufnr, "modifiable", false)
  end

  popup:mount()
  render()

  popup:map("n", "<up>", function()
    selected = (selected - 2 + #priorities) % #priorities + 1
    render()
  end, { noremap = true })

  popup:map("n", "k", function()
    selected = (selected - 2 + #priorities) % #priorities + 1
    render()
  end, { noremap = true })

  popup:map("n", "<down>", function()
    selected = (selected % #priorities) + 1
    render()
  end, { noremap = true })

  popup:map("n", "j", function()
    selected = (selected % #priorities) + 1
    render()
  end, { noremap = true })

  popup:map("n", "<cr>", function()
    local selected_priority = priorities[selected]
    popup:unmount()

    -- Safely return selected value to callback
    vim.schedule(function()
      if callback and type(callback) == "function" then
        callback(selected_priority)
      end
    end)
  end, { noremap = true })

  popup:map("n", "q", function()
    popup:unmount()
  end, { noremap = true })

  popup:on(event.BufLeave, function()
    popup:unmount()
  end)
end

return M
