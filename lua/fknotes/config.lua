-- Default configuration for FkNotes
-- To override, call require('fknotes').setup(your_config)

local M = {}

M.config = {
  -- General settings
  default_note_dir = vim.fn.expand('~/notes'),
  obsidian_path = nil, -- Path to your Obsidian vault, if you use it

  -- Task management
  default_task_priority = 'medium',
  default_task_due_date = 'today',

  -- UI settings
  ui = {
    colorscheme = nil, -- Set to a colorscheme name to force a specific theme
    border_style = 'rounded', -- 'rounded', 'single', 'double', 'solid'
    menu_width = 55,
    menu_height = 15,
    task_browser_width = 80,
    task_browser_height = 20,
    task_form_width = 60,
    task_form_height = 17,
    date_picker_width = 34,
    date_picker_height = 15,
  },

  -- Storage settings
  storage = {
    file_format = 'json', -- 'json' or 'markdown'
    tasks_subdir = 'tasks',
    notes_subdir = 'notes',
  },

  -- Export settings
  export = {
    default_format = 'markdown',
    export_dir = vim.fn.expand('~/exported_notes'),
  },

  -- Keybindings
  keymaps = {
    open_menu = "<leader>fn",
    new_task = "<leader>nt",
    browse_tasks = "<leader>ln",
  }
}

-- Function to get the current configuration
function M.get()
  return M.config
end

-- Function to merge user options with defaults
function M.setup(options)
  options = options or {}
  M.config = vim.tbl_deep_extend('force', M.config, options)
end

return M