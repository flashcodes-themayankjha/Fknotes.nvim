# FKNotes

A simple and efficient task management plugin for Neovim, designed to help you organize your daily tasks without leaving your favorite editor.

## Features
<img width="1702" height="727" alt="image" src="https://github.com/user-attachments/assets/1e20a842-ca0d-44e4-8f22-879e19601e22" />

- **Daily Task Management:** Organize your tasks by date.
- **Simple Interface:** Easy-to-use menu and forms for managing tasks.
- **Customizable:** Configure the plugin to your liking.
- **Persistent Storage:** Tasks are saved in a JSON file, so you won't lose your data and also Auto Sync with Obsidian .
<img width="1710" height="1071" alt="image" src="https://github.com/user-attachments/assets/da5ee4ad-e1fa-4621-a73c-c3eea1ac9e4d" />


## Seamless Integration with FKvim

FKNotes is natively supported by [FKvim](https://github.com/Flash-codes/fkvim/), my personalized Neovim configuration. This integration provides a powerful and cohesive note-taking experience directly within your customized development environment.

When used with FKvim, FKNotes benefits from:

- **Effortless Setup:** No additional configuration is needed. FKNotes is pre-configured and ready to use out-of-the-box with FKvim.
- **Harmonious Design:** The UI components and color schemes of FKNotes are designed to perfectly match the aesthetic of FKvim, ensuring a consistent and visually appealing experience.
- **Optimized Workflow:** Keybindings and commands are thoughtfully integrated into the FKvim workflow, making task management a natural part of your development process.

## Installation

> Note: for now This plugin is under development, So nvim package manager wont be able to recognise this , so manually install it for 
beta test and Star this repo for Stable versions 

```shell
git clone https://github.com/flashcodes-themayankjha/Fknotes.nvim.git ~/.config/nvim/lua/fknotes

```

```lua
    {
  dir = vim.fn.stdpath("config") .. "/lua/fknotes",
  -- full path to your plugin repo
  name = "fknotes",                   
  config = function()
    require("fknotes").setup()
  end,
  lazy = false,  -- load on startup (or use event = "VeryLazy" if you prefer)
},

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

<img width="1702" height="727" alt="image" src="https://github.com/user-attachments/assets/4360884d-c14a-4dd0-9baf-de57bb2c0080" />
<em>Don't Allow Duplication <em>

<img width="1706" height="724" alt="image" src="https://github.com/user-attachments/assets/db61151a-9de9-4345-b439-8f30285a0438" />
<em> Easy and Fast Task Management <em>



## 🔮 Roadmap / Future

Planned enhancements:

- [ ] 📓 Full Notes browser/edit, browsable like tasks
- [ ] 🔍 Telescope-powered search, quick task+note fuzzy-find
- [ ] 🗓️ Calendar/date picker
- [ ] 🔄 Recurring & repeating tasks
- [ ] 📦 Markdown export to custom locations/vaults
- [ ] 📱 Sync & reminders
- [ ] ☁️ Cloud sync (WIP/beta)
- [ ] And more—file issues or suggestions!

---


## 🙏 Credits & Contributing

Created with ❤️ by [Mayank Jha](https://github.com/flashcodes-themayankjha)  
Big thanks to Neovim, [nui.nvim](https://github.com/MunifTanjim/nui.nvim), [Catppuccin](https://github.com/catppuccin/catppuccin), and all FKvim contributors.

**Found a bug or have ideas?**  
Pull requests, issues, and stars are all appreciated!

---
