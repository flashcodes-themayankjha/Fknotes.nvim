# FkNotes.nvim

![Neovim](https://img.shields.io/badge/Neovim-0.9%2B-57AD57?style=for-the-badge&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/Lua-5.1%2B-2C2D72?style=for-the-badge&logo=lua&logoColor=white)

FkNotes.nvim is a powerful Neovim plugin designed to help you manage your notes, tasks, and knowledge base directly within your editor. It provides a seamless experience for creating, organizing, and interacting with your personal information, integrating features like task management, date picking, and priority selection.

> This is Configured to use with [Fkvim](https://github.com/TheFlashCodes/FKvim)

## Features

- **Task Management:** Create, view, and manage tasks with priorities and due dates.
- **Note Organization:** Store and link notes, potentially integrating with external knowledge bases like Obsidian.
- **Intuitive UI:** User-friendly interface for browsing tasks, selecting dates, and setting priorities.
- **Customizable:** Highly configurable to fit your workflow and preferences.
- **Export Functionality:** Export your notes and tasks (details to be added based on `export.lua`).

## Screenshots

<img width="1702" height="727" alt="image" src="https://github.com/user-attachments/assets/1e20a842-ca0d-44e4-8f22-879e19601e22" />
<img width="1710" height="1071" alt="image" src="https://github.com/user-attachments/assets/da5ee4ad-e1fa-4621-a73c-c3eea1ac9e4d" />

## Installation

FkNotes.nvim can be installed using your favorite Neovim package manager.

### Lazy.nvim

```lua
{
  'flashcode-themayankjha/Fknotes.nvim',
  config = function()
    require('fknotes').setup({
      -- Your custom configuration options here
      -- For example:
      -- default_note_dir = vim.fn.expand('~/my_custom_notes'),
    })
  end
}
```

### Packer.nvim

```lua
use {
  'flashcode-themayankjha/Fknotes.nvim',
  config = function()
    require('fknotes').setup({
      -- Your custom configuration options here
    })
  end
}
```

### Vim-Plug

```vim
Plug 'flashcode-themayankjha/Fknotes.nvim'

" In your init.vim or after Plug 'flashcode-themayankjha/Fknotes.nvim'
lua << EOF
  require('fknotes').setup({
    -- Your custom configuration options here
  })
EOF
```

## Configuration

You can pass a table of options to the `setup()` function to customize FkNotes.nvim. These options will be merged with the plugin's default settings.

Here are the available configuration options:

```lua
require('fknotes').setup({
  -- Path to your default notes directory.
  -- All new notes and tasks will be stored here by default.
  -- Default: vim.fn.expand('~/notes')
  default_note_dir = vim.fn.expand('~/notes'),

  -- Path to your Obsidian vault.
  -- If set, FkNotes.nvim can integrate with your Obsidian notes.
  -- Default: nil (no Obsidian integration)
  obsidian_path = nil,

  -- Default priority for new tasks.
  -- Can be 'low', 'medium', or 'high'.
  -- Default: 'medium'
  default_task_priority = 'medium',

  -- Default due date for new tasks.
  -- Can be 'today', 'tomorrow', 'next_week', or a specific date string (e.g., 'YYYY-MM-DD').
  -- Default: 'today'
  default_task_due_date = 'today',

  -- UI configuration options
  ui = {
    -- Colorscheme to use for FkNotes UI elements.
    -- If nil, uses your current Neovim colorscheme.
    -- Default: nil
    colorscheme = nil,

    -- Border style for floating windows (e.g., 'rounded', 'single', 'double', 'none').
    -- Default: 'rounded'
    border_style = 'rounded',

    -- Width of the main menu window.
    -- Default: 40
    menu_width = 80,

    -- Height of the main menu window.
    -- Default: 11
    menu_height = 20,

    -- Width of the task browser window.
    -- Default: 80
    task_browser_width = 100,

    -- Height of the task browser window.
    -- Default: 20
    task_browser_height = 30,

    -- Width of the task form window.
    -- Default: 60
    task_form_width = 80,

    -- Height of the task form window.
    -- Default: 17
    task_form_height = 25,
  },

  -- Storage configuration options
  storage = {
    -- File format for storing notes and tasks (e.g., 'markdown', 'json').
    -- Default: 'markdown' , remember for task file_format should be json else task browser won't work
    file_format = 'json',

    -- Directory within default_note_dir to store tasks.
    -- Default: 'tasks'
    tasks_subdir = 'tasks',

    -- Directory within default_note_dir to store general notes.
    -- Default: 'notes'
    notes_subdir = 'notes',
  },

  -- Export configuration options
  export = {
    -- Default export format (e.g., 'html', 'pdf', 'text').
    -- Default: 'markdown'
    default_format = 'markdown',

    -- Directory to save exported files.
    -- Default: vim.fn.expand('~/exported_notes')
    export_dir = vim.fn.expand('~/exported_notes'),
  },
})
```

## Usage

### Commands

- `:FkNotes`: Opens the main FkNotes menu.
- `:FkNewTask`: Opens a form to create a new task.
- `:FkBrowseTasks`: Opens the task browser to view and manage tasks.

### Keybindings

You can set up your own keybindings in your `init.lua` or `init.vim`. Here are some common ones:

```lua
-- Lua
vim.api.nvim_set_keymap('n', '<leader>fn', ':FkNotes<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>nt', ':FkNewTask<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>bt', ':FkBrowseTasks<CR>', { noremap = true, silent = true })
```

```vim
" Vimscript
nnoremap <leader>fn :FkNotes<CR>
nnoremap <leader>nt :FkNewTask<CR>
nnoremap <leader>bt :FkBrowseTasks<CR>
```

## Contributing

Contributions are welcome! If you find a bug or have a feature request, please open an issue on the [GitHub repository](https://github.com/flashcodes-themayankjha/Fknotes.nvim/issues).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
