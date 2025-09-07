
local config_module = require("fknotes.config")

local M = {}

-- Make the config accessible to other modules
M.config = config_module.get()

function M.setup(opts)
  -- Merge user options with defaults
  config_module.setup(opts)
  M.config = config_module.get()

  -- Load colors
  pcall(require, "fknotes.ui.colorscheme")

  -- Define helper to safely require modules
  local function safe_require(module, fn)
    local ok, mod = pcall(require, module)
    if ok then
      fn(mod)
    else
      vim.notify("[FkNotes] Failed to load " .. module .. ": " .. debug.traceback(), vim.log.levels.ERROR)
    end
  end

  -- Autocmd to reload colors on colorscheme change
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
      require("fknotes.ui.colorscheme").setup()
    end,
  })

  -- Main Menu Command
  vim.api.nvim_create_user_command("FkNotes", function()
    safe_require("fknotes.ui.menu", function(menu)
      menu.open_main_menu()
    end)
  end, {})

  -- New Task Command
  vim.api.nvim_create_user_command("FkNewTask", function()
    safe_require("fknotes.ui.task_form", function(form)
      form.new_task()
    end)
  end, {})

  -- Browse All Tasks Command
  vim.api.nvim_create_user_command("FkAllTasks", function()
    safe_require("fknotes.ui.task_browser", function(browser)
      browser.show_browser()
    end)
  end, {})

  -- New Notebook Command
  vim.api.nvim_create_user_command("FkNewNotebook", function()
    safe_require("fknotes.ui.new_notebook_form", function(form)
      form.open(function(notebook_data)
        -- TODO: Handle saving the new notebook data
        vim.notify(
          "New Notebook: " .. notebook_data.name .. " - " .. notebook_data.description,
          vim.log.levels.INFO
        )
      end)
    end)
  end, {})

  -- Set keymaps from config
  local keymaps = M.config.keymaps
  if keymaps then
    vim.keymap.set("n", keymaps.open_menu, function()
      safe_require("fknotes.ui.menu", function(menu)
        menu.open_main_menu()
      end)
    end, { desc = "Open FKNotes Menu" })

    vim.keymap.set("n", keymaps.new_task, function()
      safe_require("fknotes.ui.task_form", function(form)
        form.new_task()
      end)
    end, { desc = "Create New FKNotes Task" })

    vim.keymap.set("n", keymaps.browse_tasks, function()
      safe_require("fknotes.ui.task_browser", function(browser)
        browser.show_browser()
      end)
    end, { desc = "Browse All FKNotes Tasks" })

    vim.keymap.set("n", keymaps.new_notebook, function()
      safe_require("fknotes.ui.new_notebook_form", function(form)
        form.open(function(notebook_data)
          -- TODO: Handle saving the new notebook data
          vim.notify(
            "New Notebook: " .. notebook_data.name .. " - " .. notebook_data.description,
            vim.log.levels.INFO
          )
        end)
      end)
    end, { desc = "Create New FKNotes Notebook" })
  end
end

return M
