
local M = {}

function M.setup()
  -- Load FKNotes highlight colors
  require("fknotes.ui.colorscheme").setup()

  -- Main menu command and keymap
  vim.api.nvim_create_user_command("FkNotes", function()
    require("fknotes.ui.menu").open_main_menu()
  end, {})

  vim.keymap.set("n", "<leader>fn", function()
    require("fknotes.ui.menu").open_main_menu()
  end, { desc = "Open FKNotes Menu" })

  -- New task command and keymap
  vim.api.nvim_create_user_command("FkNewTask", function()
    require("fknotes.ui.task_form").new_task()
  end, {})

  vim.keymap.set("n", "<leader>nt", function()
    require("fknotes.ui.task_form").new_task()
  end, { desc = "Create New FKNotes Task" })

   vim.api.nvim_create_user_command("FkAllTasks", function()
    require("fknotes.ui.task_browser").show_browser()
   end, {})
   
  vim.keymap.set("n","<leader>at",function ()
    require("fknotes.ui.task_browser").show_browser()
  end,{ desc = "Browse ALl Tasks" })
end

return M
