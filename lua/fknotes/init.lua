
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

  -- Create user commands
  local commands = {
    FkNotes = { module = "fknotes.ui.menu", func = "open_main_menu" },
    FkNewTask = { module = "fknotes.ui.task_form", func = "new_task" },
    FkAllTasks = { module = "fknotes.ui.task_browser", func = "show_browser" },
    FkQuickNotes = { module = "fknotes.ui.quick_notes_form", func = "new" },
  }

  for cmd, action in pairs(commands) do
    vim.api.nvim_create_user_command(cmd, function()
      safe_require(action.module, function(mod)
        mod[action.func]()
      end)
    end, {})
  end

  -- Set keymaps from config
  local keymaps = M.config.keymaps
  if keymaps then
    local keymap_actions = {
      open_menu = { module = "fknotes.ui.menu", func = "open_main_menu" },
      new_task = { module = "fknotes.ui.task_form", func = "new_task" },
      browse_tasks = { module = "fknotes.ui.task_browser", func = "show_browser" },
      quick_notes = { module = "fknotes.ui.quick_notes_form", func = "new" },
    }

    for action, key in pairs(keymaps) do
      local keymap_action = keymap_actions[action]
      if keymap_action then
        vim.keymap.set("n", key, function()
          safe_require(keymap_action.module, function(mod)
            mod[keymap_action.func]()
          end)
        end, { desc = "FkNotes: " .. action })
      end
    end
  end
end

return M
