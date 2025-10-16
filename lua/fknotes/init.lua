
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

  --------------------------------------------------------------------
  -- 🔹 Colorscheme auto reload
  --------------------------------------------------------------------
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
      require("fknotes.ui.colorscheme").setup()
       require("fknotes.highlighter.highlights").setup()
        require("fknotes.highlighter.signs").setup()
    end,
  })

  --------------------------------------------------------------------
  -- 🔹 FkNotes Core Commands
  --------------------------------------------------------------------
  vim.api.nvim_create_user_command("FkNotes", function()
    safe_require("fknotes.ui.menu", function(menu)
      menu.open_main_menu()
    end)
  end, {})

  vim.api.nvim_create_user_command("FkNewTask", function()
    safe_require("fknotes.ui.task_form", function(form)
      form.new_task()
    end)
  end, {})

  vim.api.nvim_create_user_command("FkAllTasks", function()
    safe_require("fknotes.ui.task_browser", function(browser)
      browser.show_browser()
    end)
  end, {})

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

  --------------------------------------------------------------------
  -- 🔹 Keymaps from config
  --------------------------------------------------------------------
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

  --------------------------------------------------------------------
  -- 🔹 Inline @fknotes Parser + Highlighter Integration
  --------------------------------------------------------------------
  -- Load and attach internal highlighter (clone of todo-comments)
  safe_require("fknotes.highlighter.highlights", function(highlights)
    highlights.setup()
  end)

  safe_require("fknotes.highlighter.signs", function(signs)
    signs.setup()
  end)

  safe_require("fknotes.highlighter", function(hl)
    hl.attach_autocmd()
  end)

  --------------------------------------------------------------------
  -- 🔹 Optional: Task Deadline Notification System
  --------------------------------------------------------------------
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      safe_require("fknotes.core.notify", function(notify)
        if notify.check_due_tasks then
          notify.check_due_tasks()
        end
      end)
    end,
  })

  ---------------------------------------------------------------------------
  -- 🔍 Detect Inline @fknotes Typing & Notify User
  ---------------------------------------------------------------------------

  -- Flag to prevent multiple triggers in the same buffer session
  local fknotes_triggered = {}

  vim.api.nvim_create_autocmd({ "TextChangedI", "TextChanged" }, {
    callback = function(args)
      local bufnr = args.buf
      if fknotes_triggered[bufnr] then return end

      local line = vim.api.nvim_get_current_line()
      if line:find("@fknotes") then
        fknotes_triggered[bufnr] = true

        local ok, fidget = pcall(require, "fidget")
        if ok and fidget and fidget.notify then
          -- Use Fidget for fancy popup if available
          fidget.notify("Inline FKNotes detected", vim.log.levels.INFO, {
            title = "🪶 FKNotes Initialized",
            timeout = 2000,
          })
        else
          -- Fallback to vim.notify
          vim.notify("🪶 FKNotes initialized (inline task detected)", vim.log.levels.INFO, {
            title = "FKNotes",
          })
        end
      end
    end,
  })

  vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function(args)
      fknotes_triggered[args.buf] = false
    end,
  })

  --------------------------------------------------------------------
  -- 🔹 Status Message
  --------------------------------------------------------------------
  -- vim.schedule(function()
  --   vim.notify("[FkNotes] Initialized successfully 🚀", vim.log.levels.INFO)
  -- end)
end

return M
