<div align="center">

# FkNotes.nvim

**A simple yet powerful note-taking and task management plugin for Neovim, inspired by the FkVim ecosystem.**

</div>

<p align="center">
  <img src="https://img.shields.io/badge/Made%20with-Lua-blue.svg?style=for-the-badge&logo=lua" />
  <img src="https://img.shields.io/badge/Powered%20by-Neovim-green.svg?style=for-the-badge&logo=neovim" />
  <a href="https://github.com/flashcodes-themayankjha/Fknotes.nvim/stargazers"><img src="https://img.shields.io/github/stars/flashcodes-themayankjha/Fknotes.nvim?style=for-the-badge" /></a>
  <a href="https://github.com/flashcodes-themayankjha/Fknotes.nvim/blob/main/LICENSE"><img src="https://img.shields.io/github/license/flashcodes-themayankjha/Fknotes.nvim?style=for-the-badge" /></a>
</p>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#screenshots">Screenshots</a> •
  <a href="#installation">Installation</a> •
  <a href="#configuration">Configuration</a> •
  <a href="#usage">Usage</a> •
  <a href="#contributing">Contributing</a>
</p>

---

FkNotes is a lightweight and easy-to-use note-taking plugin for Neovim, designed to help you manage your tasks and notes without leaving your editor. It is built with performance and simplicity in mind, and is a proud member of the **FkVim** family of plugins.

## Features

-   **Task Management:** Create, browse, and manage tasks with priorities and due dates.
-   **Note Taking (Upcoming):** A simple yet effective way to jot down your thoughts and ideas.
-   **Highly Configurable:** Customize the plugin to fit your workflow.
-   **Export:** Export your tasks and notes to Markdown files.
-   **Beautiful UI:** A clean and modern UI built with `nui.nvim`.

## Dependencies

`FkNotes.nvim` requires the following plugin to work:

-   [nui.nvim](https://github.com/MunifTanjim/nui.nvim)

You must ensure that `nui.nvim` is installed. Here is an example of how to install it with `lazy.nvim`:

```lua
{
  'MunifTanjim/nui.nvim',
  lazy = true,
},
```

## Screenshots & FkVim Ecosystem

<table align="center">
  <tr>
    <td align="center">
      <img width="400" alt="FkNotes Menu" src="https://github.com/user-attachments/assets/b4fe551b-cfda-4b64-8067-b830114d11d1" />
      <br>
      FkNotes Menu
    </td>
    <td align="center">
      <img width="400" alt="New Task Menu" src="https://github.com/user-attachments/assets/46de455b-87b0-41f7-b495-1bbcc63cc468" />
      <br>
      New Task Menu
    </td>
  </tr>
  <tr>
    <td align="center">
      <img width="400" alt="Custom Calendar UI" src="https://github.com/user-attachments/assets/ea202eac-6eef-4034-9f5c-61e19c5fc772" />
      <br>
      Custom Calendar UI
    </td>
    <td align="center">
      <img width="400" alt="Browser tasks" src="https://github.com/user-attachments/assets/b6310f4b-85c0-4ea8-947d-d396bc5f6a71" />
      <br>
      Browser tasks
    </td>
  </tr>
</table>

FkNotes is designed to work seamlessly with other plugins in the FkVim ecosystem. For the best experience, it is recommended to use FkNotes with [FkVim](https://github.com/your-username/fkvim), a full-featured Neovim configuration with a focus on performance and aesthetics.

## Installation

Install FkNotes using your favorite plugin manager.

### with `packer.nvim`

```lua
use 'flashcodes-themayankjha/Fknotes.nvim'
```

### with `lazy.nvim`

```lua
{
  'flashcodes-themayankjha/Fknotes.nvim',
  config = function()
    require('fknotes').setup({
      -- your configuration here
    })
  end
}
```

## Configuration

To set up and configure FkNotes, add the following to your `init.lua` or a dedicated configuration file. Here are the default settings:

```lua
require('fknotes').setup({
  -- General settings
  default_note_dir = vim.fn.expand('~/notes'), -- Default directory for notes and tasks
  obsidian_path = nil, -- Path to your Obsidian vault, if you use it

  -- Task management
  default_task_priority = 'medium', -- 'high', 'medium', 'low', or 'none'
  default_task_due_date = 'today', -- Default due date for new tasks

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
})
```

> [!WARNING]
> The **Notes** feature is not yet implemented. It is a planned feature for a future release.

## Usage

FkNotes provides the following commands and default keybindings:

| Command | Default Keymap | Description |
| :--- | :--- | :--- |
| `:FkNotes` | `<leader>fn` | Open the main menu. |
| `:FkNewTask` | `<leader>nt` | Create a new task. |
| `:FkAllTasks` | `<leader>ln` | Browse all tasks. |


## Contributing

Contributions are welcome! If you have any ideas, suggestions, or bug reports, please open an issue or submit a pull request. We would love to have you as a contributor!

If you like this plugin, please consider giving it a ⭐ on GitHub to show your support and to help others discover it.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

<div align="center">
  <br>
  Made with ❤️ by <a href="https://github.com/flashcodes-themayankjha">Mayank Jha</a>
</div>
