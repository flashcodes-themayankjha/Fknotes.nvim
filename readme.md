> This plugin is in early development stage 



<img width="1702" height="727" alt="image" src="https://github.com/user-attachments/assets/1e20a842-ca0d-44e4-8f22-879e19601e22" />

<img width="1710" height="1071" alt="image" src="https://github.com/user-attachments/assets/da5ee4ad-e1fa-4621-a73c-c3eea1ac9e4d" />


 

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



- **Open Main Menu:**
  - Command: `:FkNotes`
  - Keybinding: `<leader>fn`

- **Create New Task:**
  - Command: `:FkNewTask`
  - Keybinding: `<leader>nt`


  
```





