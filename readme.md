# FKNotes

A simple and efficient task management plugin for Neovim, designed to help you organize your daily tasks without leaving your favorite editor.

## Features

- **Daily Task Management:** Organize your tasks by date.
- **Simple Interface:** Easy-to-use menu and forms for managing tasks.
- **Persistent Storage:** Tasks are saved in a JSON file, so you won't lose your data.
- **Customizable:** Configure the plugin to your liking.

## Seamless Integration with FKvim

FKNotes is natively supported by [FKvim](https://github.com/mayankjha-personal/fkvim), my personalized Neovim configuration. This integration provides a powerful and cohesive note-taking experience directly within your customized development environment.

When used with FKvim, FKNotes benefits from:

- **Effortless Setup:** No additional configuration is needed. FKNotes is pre-configured and ready to use out-of-the-box with FKvim.
- **Harmonious Design:** The UI components and color schemes of FKNotes are designed to perfectly match the aesthetic of FKvim, ensuring a consistent and visually appealing experience.
- **Optimized Workflow:** Keybindings and commands are thoughtfully integrated into the FKvim workflow, making task management a natural part of your development process.

## Installation

Install FKNot I’m now attaching my Aadhaar card, which is a valid government-issued ID for Indian citizens. My name “Mayank Jha” matches the ID, except for the missing middle name,es I’m now attaching my Aadhaar card, which is a valid government-issued ID for Indian citizens. My name “Mayank Jha” matches the ID, except for the missing middle name, using your favorite plugin manager.

**Packer:**

```lua
use 'flashcodes-themayankjha/Fknotes.nvim'
```

**vim-plug:**

```vim
Plug 'flashcodes-themayankjha/Fknotes.nvim'
```

## Usage

FKNotes provides the following commands and keybindings to manage your tasks:

- **Open Main Menu:**
  - Command: `:FkNotes`
  - Keybinding: `<leader>fn`

- **Create New Task:**
  - Command: `:FkNewTask`
  - Keybinding: `<leader>nt`

## Configuration

To get started, add the following to your `init.lua` or a dedicated plugin configuration file:

```lua
require('fknotes').setup()
```

You can also customize the highlight colors for the buttons in the plugin:

```lua
vim.cmd([[
  highlight FkNotesRedButton guifg=#f7768e gui=bold
  highlight FkNotesBlueButton guifg=#7dcfff gui=bold
]])
```

## Screenshot

![image](https://github.com/user-attachments/assets/a31b2a8d-b7cd-43ec-9fb5-e6ffd8312cc2)
