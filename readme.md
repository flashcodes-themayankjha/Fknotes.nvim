<div align="center">

# 🗒️ FKNotes.nvim

**Inline notes, tasks, and TODOs for Neovim, inspired by the FkVim ecosystem.**

<a href="https://github.com/TheFlashCodes/FKvim">
  <img src="https://img.shields.io/badge/FkVim-Ecosystem-blueviolet.svg?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCI+PHBhdGggZD0iTTkuODYgMy41bDIuNjcgMy43NEwxNC40OCAzLjVoMy41MkwxMiAxMy4yOCAzLjk4IDMuNWg5Ljg4ek0xMiAxNS4wNGwtMy44NyA1LjQ2aDcuNzVsLTMuODgtNS40NnoiIGZpbGw9IiNmZmYiLz48L3N2Zz4=" alt="FkVim Ecosystem"/>
</a>

</div>

<p align="center">
  <img src="https://img.shields.io/badge/Made%20with-Lua-blue.svg?style=for-the-badge&logo=lua" />
  <img src="https://img.shields.io/badge/Powered%20by-Neovim-green.svg?style=for-the-badge&logo=neovim" />
  <a href="https://github.com/flashcodes-themayankjha/Fknotes.nvim/stargazers"><img src="https://img.shields.io/github/stars/flashcodes-themayankjha/Fknotes.nvim?style=for-the-badge" /></a>
  <a href="https://github.com/flashcodes-themayankjha/Fknotes.nvim/blob/main/LICENSE"><img src="https://img.shields.io/github/license/flashcodes-themayankjha/Fknotes.nvim?style=for-the-badge" /></a>
</p>

<p align="center">
  <a href="#-features">Features</a> •
  <a href="#-installation">Installation</a> •
  <a href="#-usage--syntax">Usage & Syntax</a> •
  <a href="#-customization">Customization</a> •
  <a href="#-contributing">Contributing</a>
</p>

---

**FKNotes.nvim** brings powerful, inline note-taking and task management directly into your Neovim workflow. It combines the convenience of `todo-comments.nvim` with a persistent task database and a modern UI, all tightly integrated with the FKvim ecosystem.

## ✨ Features

-   **Flexible Inline Syntax**: Capture tasks and notes naturally with `@fknotes`.
-   **Smart Parsing**: Recognizes priorities, due dates, and tags in any order.
-   **Relative Due Dates**: Set deadlines with intuitive formats like `-2d` (2 days from now), `-3w` (3 weeks), or `-1m` (1 month).
-   **Flexible Priorities**: Specify priority with `@high` or as a tag like `#medium`.
-   **Granular Highlighting**: `todo-comments.nvim`-style highlighting for each part of your note.
-   **Persistent Storage**: Inline tasks are saved to a JSON file and won't be lost when you close the buffer.
-   **UI for Management**: A clean and modern UI to browse, create, and manage tasks and notebooks.
-   **Gutter Signs & Diagnostics**: Get instant visual feedback for your notes in the sign column and diagnostics panel.
-   **Theme Aware**: Dynamically adapts to your colorscheme for a native look and feel.

## 🧩 Dependencies

`FkNotes.nvim` requires the following plugin to work:

-   [**MunifTanjim/nui.nvim**](https://github.com/MunifTanjim/nui.nvim)

## 🚀 Installation

Install with your favorite plugin manager.

### with `lazy.nvim`

```lua
{
  'flashcodes-themayankjha/Fknotes.nvim',
  dependencies = { "MunifTanjim/nui.nvim" },
  config = function()
    require('fknotes').setup({
      -- your configuration here
    })
  end
}
```

## ⚙️ Configuration

Here are the default settings. You only need to include the keys you wish to override in your `setup()` call.

```lua
require('fknotes').setup({
  -- General settings
  default_note_dir = vim.fn.expand('~/notes'), -- Default directory for notes and tasks

  -- UI settings
  ui = {
    border_style = 'rounded', -- 'rounded', 'single', 'double', 'solid'
    -- Window dimensions
    menu_width = 55,
    menu_height = 15,
    task_browser_width = 80,
    task_browser_height = 20,
  },

  -- Keybindings
  keymaps = {
    open_menu = "<leader>fn",
    new_task = "<leader>nt",
    browse_tasks = "<leader>ln",
    new_notebook = "<leader>nn",
  }
})
```

## 📝 Usage & Syntax

### Inline Task Syntax

The power of FKNotes lies in its flexible inline syntax. Start a line with `@fknotes` followed by a `TAG` and a colon.

`@fknotes <TAG>: <Your Title> [@priority | #priority] [-<date>] [#tags...]`

-   **TAG**: `TODO`, `FIX`, `NOTE`, `PERF`, `WARN`, `HACK`, `TASK`. This is required.
-   **Title**: The description of your task.
-   **Priority**: Optional. Use either `@<level>` or `#<level>` (e.g., `@high`, `#medium`).
-   **Due Date**: Optional. Use an absolute date (`-YYYY-MM-DD`) or a relative one (`-2d`, `-3w`, `-1m`, `-1y`).
-   **Tags**: Optional. Add as many `#tags` as you like.

**The metadata (priority, date, tags) can be in any order after the title.**

#### Examples

```lua
-- A simple TODO
-- @fknotes TODO: Implement the new feature

-- A complex task with metadata in a different order
-- @fknotes FIX: Bug in the API response -2d #fkvim @high

-- A note with a relative date and a tag
-- @fknotes NOTE: Review the documentation -1w #docs

-- A performance task with a priority tag
-- @fknotes PERF: Optimise database queries #high #db
```

### Commands

| Command          | Description                   |
| ---------------- | ----------------------------- |
| `:FkNotes`       | Open the main FKNotes menu.   |
| `:FkNewTask`     | Open the form to create a new task. |
| `:FkAllTasks`    | Open the task browser to view all tasks. |
| `:FkNewNotebook` | Open the form to create a new notebook. |

## 🎨 Customization

FKNotes provides granular highlight groups so you can customize the look and feel to match your theme perfectly.

### Highlighting Example

For a note like `@fknotes FIX: Critical bug @high -2d #auth`:

-   `@fknotes` is highlighted with `FkNotesKeyword` (Yellow)
-   `FIX:` is highlighted with `FkNotesTagFIX` (Red Background, White Text)
-   `Critical bug` is highlighted with `FkNotesTitleFIX` (Red Text)
-   `@high` is highlighted with `FkNotesPriorityHigh` (Red Text)
-   `-2d` is highlighted with `FkNotesMeta` (White/Grey Text)
-   `#auth` is highlighted with `FkNotesMeta` (White/Grey Text)

### Highlight Groups

You can override any of these groups using `vim.api.nvim_set_hl`.

| Group                   | Description                                |
| ----------------------- | ------------------------------------------ |
| `FkNotesKeyword`        | The initial `@fknotes` keyword.            |
| `FkNotesTag<TAG>`       | The tag itself (e.g., `FkNotesTagFIX`).    |
| `FkNotesTitle<TAG>`     | The title text (e.g., `FkNotesTitleFIX`).  |
| `FkNotesPriorityHigh`   | High priority text (`@high` or `#high`).   |
| `FkNotesPriorityMedium` | Medium priority text.                      |
| `FkNotesPriorityLow`    | Low priority text.                         |
| `FkNotesMeta`           | Due dates and `#tags`.                     |

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/flashcodes-themayankjha/Fknotes.nvim/issues).

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---
<div align="center">
  Made with ❤️ by <a href="https://github.com/flashcodes-themayankjha">Mayank Jha</a>
</div>