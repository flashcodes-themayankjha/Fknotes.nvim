
local M = {}

function M.setup()
  -- Load colors
  local ok_colors = pcall(require, "fknotes.ui.colorscheme")
  if ok_colors then
    require("fknotes.ui.colorscheme").setup()
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
