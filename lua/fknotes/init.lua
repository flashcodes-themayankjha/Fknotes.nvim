
local M = {}

-- Deep merge utility function
local function deep_merge(t1, t2)
  for k, v in pairs(t2) do
    if type(v) == "table" and type(t1[k]) == "table" then
      t1[k] = deep_merge(t1[k], v)
    else
      t1[k] = v
    end
  end
  return t1
end

M.config = {}

function M.setup(opts)
  opts = opts or {}

  local defaults = {
    default_note_dir = vim.fn.expand('~/notes'),
    obsidian_path = nil,
    default_task_priority = 'medium',
    default_task_due_date = 'today',
    ui = {
      colorscheme = nil,
      border_style = 'rounded',
      menu_width = 80,
      menu_height = 20,
      task_browser_width = 100,
      task_browser_height = 30,
      task_form_width = 80,
      task_form_height = 25,
      date_picker_width = 34,
      date_picker_height = 15,
    },
    storage = {
      file_format = 'markdown',
      tasks_subdir = 'tasks',
      notes_subdir = 'notes',
    },
    export = {
      default_format = 'markdown',
      export_dir = vim.fn.expand('~/exported_notes'),
    },
  }

  M.config = deep_merge(defaults, opts)

  -- Load colors
  local ok_colors = pcall(require, "fknotes.ui.colorscheme")
  if ok_colors then
    require("fknotes.ui.colorscheme").setup(M.config.ui.colorscheme)
  else
    vim.notify("[FkNotes] colorscheme module not found", vim.log.levels.WARN)
  end

  -- Define helper to safely require modules
  local function safe_require(module, fn)
    local ok, mod = pcall(require, module)
    if ok then
      fn(mod)
    else
      vim.notify("[FkNotes] Failed to load " .. module, vim.log.levels.ERROR)
    end
  end

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    require("fknotes.ui.colorscheme").setup()
  end,
})


  -- Main Menu
  vim.api.nvim_create_user_command("FkNotes", function()
    safe_require("fknotes.ui.menu", function(menu)
      menu.open_main_menu()
     end)
  end, {})

  vim.keymap.set("n", "<leader>fn", function()
    safe_require("fknotes.ui.menu", function(menu)
      menu.open_main_menu()
    end)
  end, { desc = "Open FKNotes Menu" })

  -- New Task
  vim.api.nvim_create_user_command("FkNewTask", function()
    safe_require("fknotes.ui.task_form", function(form)
      form.new_task()
    end)
  end, {})

  vim.keymap.set("n", "<leader>nt", function()
    safe_require("fknotes.ui.task_form", function(form)
      form.new_task()
    end)
  end, { desc = "Create New FKNotes Task" })

 -- Browse All Tasks
   vim.api.nvim_create_user_command("FkAllTasks", function()
    safe_require("fknotes.ui.task_browser", function(browser)
      browser.show_browser()
    end)
  end, {})

  vim.keymap.set("n", "<leader>ln", function()
    safe_require("fknotes.ui.task_browser", function(browser)
      browser.show_browser()
    end)
  end, { desc = "Browse All FKNotes Tasks" })
end

return M
