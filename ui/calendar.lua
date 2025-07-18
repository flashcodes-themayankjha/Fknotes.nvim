local NuiMenu = require("nui.menu")
local event = require("nui.utils.autocmd").event
local task_form = require("fknotes.ui.task_form")
local task_browser = require("fknotes.ui.task_browser")

local M = {}

-- Main FKNotes Menu
function M.open()
  local menu = NuiMenu({
    position = "50%",
    size = {
      width = 40,
      height = 10,
    },
    border = {
      style = "rounded",
      text = {
        top = " FKNotes Menu ",
        top_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
    },
  }, {
    lines = {
      NuiMenu.item("📋  Add New Task"),
      NuiMenu.item("📝  Add New Note"),
      NuiMenu.item("📄  Browse All Notes"),
      NuiMenu.item("✅  Browse All Tasks"),
    },
    max_width = 40,
    separator = {
      char = "-",
      text_align = "right",
    },
    keymap = {
      focus_next = { "j", "<Down>" },
      focus_prev = { "k", "<Up>" },
      close = { "<Esc>" },
      submit = { "<CR>" },
    },
    on_close = function()
      vim.cmd("echo 'FKNotes menu closed'")
    end,
    on_submit = function(item)
      local label = item.text
      if label:find("Add New Task") then
        task_form.new_task()
      elseif label:find("Browse All Tasks") then
        task_browser.open()
      elseif label:find("Add New Note") then
        vim.notify("Note creation not implemented yet", vim.log.levels.INFO)
      elseif label:find("Browse All Notes") then
        vim.notify("Note browser not implemented yet", vim.log.levels.INFO)
      end
    end,
  })

  menu:mount()

  menu:on(event.BufLeave, function()
    menu:unmount()
  end)
end

return M

