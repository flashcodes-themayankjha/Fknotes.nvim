Perfect 🧠 — below is a **complete `README.md`** for your current version of **FKNotes.nvim**, including:

* Explanation of the plugin and its purpose
* The new `@fknotes` inline system
* Dynamic highlighting, diagnostics, and sign behavior
* Example usage and setup instructions
* Developer and contributor notes

This version reads like a modern Neovim plugin README (similar style to `todo-comments.nvim` and `lazy.nvim`), tailored for your FKvim ecosystem.

---

# 🗒️ FKNotes.nvim

### *Inline Notes, Tasks, and TODO Management for FKvim & Neovim*

> **FKNotes.nvim** brings inline notes, colorful TODO-style highlights, and task tracking directly into your Neovim workflow — tightly integrated with the FKvim ecosystem.
> It’s a hybrid of **todo-comments**, **task manager**, and **git blame**, all in one neat package.

---

## ✨ Features

✅ **Inline Task System** using `@fknotes` annotations
✅ **Dynamic color highlights** that adapt to your colorscheme
✅ **Diagnostic integration** — every note/task appears in buffer diagnostics
✅ **Gutter signs** with icons and theme-based colors
✅ **Task reminders** with due date notifications
✅ **Full FKNotes UI** for browsing, creating, and managing notes
✅ **Auto-update on save or color change**
✅ **No external dependencies** — internal clone of `todo-comments.nvim`

---

## 🚀 Installation

With [Lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "flashcodes-themayankjha/Fknotes.nvim",
  config = function()
    require("fknotes").setup({
      keymaps = {
        open_menu = "<leader>fn",
        new_task = "<leader>ft",
        browse_tasks = "<leader>fa",
        new_notebook = "<leader>fb",
      },
      -- optional: allow theme adaptive colors
      use_theme_colors = true,
    })
  end,
}
```

---

## 🧠 Usage

### 🪶 Inline Notes & Tasks

You can now embed notes, TODOs, and tasks directly inside your code using the `@fknotes` tag.

Example:

```python
@fknotes TODO: Refactor login flow @high –2025-10-20  #auth #priority
def login():
    pass
```

✅ **Automatically detected and highlighted**
✅ Added to the **FKNotes Task Menu**
✅ **Diagnostic entry** shown in the location list
✅ **Sign icon** in the buffer gutter
✅ Notifies if the **due date** is near

---

### 🧭 Commands

| Command          | Description                   |
| ---------------- | ----------------------------- |
| `:FkNotes`       | Open main FKNotes dashboard   |
| `:FkNewTask`     | Create a new FKNotes task     |
| `:FkAllTasks`    | Browse all stored tasks       |
| `:FkNewNotebook` | Create a new FKNotes notebook |

---

## 🎨 Inline Syntax

Inline FKNotes follow this syntax:

```
@fknotes <TAG>: <Task Name> @<priority> –<due_date>  #tags
```

Example:

```lua
@fknotes FIX: Handle 404 edge case @medium –2025-10-18 #bug #http
```

### Supported Tags

| Tag  | Meaning                   | Color               |
| ---- | ------------------------- | ------------------- |
| TODO | To-do / future task       | 🟦 Blue             |
| FIX  | Bug or error              | 🟥 Red              |
| NOTE | Informational note        | 🟧 Orange           |
| WARN | Warning / caution         | 🟨 Yellow           |
| PERF | Performance improvement   | 🟩 Green            |
| HACK | Experimental or temp code | 🟪 Purple           |
| TASK | General task item         | 🩵 Teal             |
| DUE  | Due soon                  | 🟡 Yellow underline |

---

## 🧩 Internal Modules

FKNotes now includes a built-in clone of `todo-comments.nvim` for inline parsing and highlighting.

### 📂 Structure

```
lua/fknotes/
│
├── core/
│   ├── config.lua
│   ├── diagnostics.lua
│   ├── notify.lua
│   ├── parser.lua
│   ├── storage.lua
│   └── export.lua
│
├── highlighter/
│   ├── init.lua          # Main parser and highlight logic
│   ├── highlights.lua    # Dynamic color system (theme-aware)
│   └── signs.lua         # Dynamic gutter icons and diagnostics
│
├── ui/
│   ├── init.lua          # Menu / Task Browser
│   └── config.lua
│
└── plugin/
    └── fknnotes.vim      # Entry point (for runtimepath)
```

---

## 🌈 Dynamic Colors

FKNotes dynamically adapts its highlights and signs to the current Neovim colorscheme.
It reads from your active highlight groups like `Function`, `String`, `Error`, `Keyword`, etc.

If you change colorschemes:

```vim
:colorscheme catppuccin
```

FKNotes will **instantly restyle** itself — highlights, signs, and diagnostics update automatically.

---

## 🔔 Task Reminders

When a task’s due date is close (within 2 days), FKNotes will notify you:

```
⚠️  Task 'Refactor login flow' is due soon (2025-10-18)
```

Notifications integrate directly with `fknotes.core.notify`.

---

## 🧩 Developer Notes

* Inline scanning runs automatically on:

  * `BufReadPost`
  * `BufWritePost`
  * `TextChanged`

* Tasks are stored through `fknotes.core.storage`

* Diagnostics integrate with Neovim’s built-in LSP diagnostics API

* Fully asynchronous; no performance hit on large files

---

## 🧑‍💻 Contributing

FKNotes is part of the [FKvim](https://github.com/flashcodes-themayankjha/FKvim) ecosystem.
We welcome contributions — whether it’s new highlight styles, better parsing, or UI features.

Open an issue or PR on:
👉 **[https://github.com/flashcodes-themayankjha/Fknotes.nvim](https://github.com/flashcodes-themayankjha/Fknotes.nvim)**

---

## 💡 Example Demo

![FKNotes Example Screenshot](https://raw.githubusercontent.com/flashcodes-themayankjha/Fknotes.nvim/main/assets/demo.png)

---

## 🏁 Credits

* Inspired by [`todo-comments.nvim`](https://github.com/folke/todo-comments.nvim)
* Built for FKvim by [@TheMayankJha](https://github.com/flashcodes-themayankjha)
* Icons from [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)

---

## 📜 License

Licensed under the **MIT License**.
See [LICENSE](./LICENSE) for more details.

---

Would you like me to also generate a **`demo.png` mockup** (showing colorful FKNotes inline annotations + signs) that fits this README preview section?
It would look great in your repo homepage.

