# FkNotes - A Simple Note-Taking Plugin for Neovim

FkNotes is a lightweight and easy-to-use note-taking plugin for Neovim, designed to help you manage your tasks and notes without leaving your editor.

## Features

- **Task Management:** Create, browse, and manage tasks with priorities and due dates.
- **Note Taking (Upcoming):** A simple yet effective way to jot down your thoughts and ideas.
- **Configurable:** Customize the plugin to fit your workflow.
- **Export:** Export your tasks and notes to Markdown files.

## Installation

Install FkNotes using your favorite plugin manager. For example, with `packer.nvim`:

```lua
use 'your-username/FkNotes.nvim'
```

## Setup and Configuration

To set up and configure FkNotes, add the following to your `init.lua` or a dedicated configuration file:

```lua
require('fknotes').setup({
  -- General settings
  default_note_dir = vim.fn.expand('~/my_notes'), -- Default directory for notes and tasks
  obsidian_path = nil, -- Path to your Obsidian vault, if you use it

  -- Task management
  default_task_priority = 'medium', -- 'high', 'medium', 'low', or 'none'
  default_task_due_date = 'today', -- Default due date for new tasks

  -- UI settings
  ui = {
    colorscheme = nil, -- Set to a colorscheme name to force a specific theme
    border_style = 'rounded', -- 'rounded', 'single', 'double', 'solid'
    menu_width = 55,
    menu_height = 11,
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
})
```

### Note

The **Notes** feature is not yet implemented. It is a planned feature for a future release.

## Usage

FkNotes provides the following commands and default keybindings:

- `:FkNotes` or `<leader>fn`: Open the main menu.
- `:FkNewTask` or `<leader>nt`: Create a new task.
- `:FkAllTasks` or `<leader>ln`: Browse all tasks.

## Contributing

Contributions are welcome! Please feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.