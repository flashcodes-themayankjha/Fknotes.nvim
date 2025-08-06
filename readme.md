> This plugin is in early development stage 



<img width="1702" height="727" alt="image" src="https://github.com/user-attachments/assets/1e20a842-ca0d-44e4-8f22-879e19601e22" />

<img width="1710" height="1071" alt="image" src="https://github.com/user-attachments/assets/da5ee4ad-e1fa-4621-a73c-c3eea1ac9e4d" />


 

## Installation

Fknotes.nvim can be installed using your favorite Neovim package manager.

### Lazy.nvim

```lua
{
  'flashcodes-mayankjha/Fknotes.nvim',
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
  'flashcodes-mayankjha/Fknotes.nvim',
  config = function()
    require('fknotes').setup({
      -- Your custom configuration options here
    })
  end
}
```

### Vim-Plug

```vim
Plug 'flashcodes-mayankjha/Fknotes.nvim'

" In your init.vim or after Plug 'flashcodes-mayankjha/Fknotes.nvim'
lua << EOF
  require('fknotes').setup({
    -- Your custom configuration options here
  })
EOF
```

## Configuration

You can pass a table of options to the `setup()` function to customize Fknotes.nvim. These options will be merged with the plugin's default settings.

Example:

```lua
require('fknotes').setup({
  obsidian_path = vim.fn.expand('~/my_new_obsidian_vault'),
})
```



- **Open Main Menu:**
  - Command: `:FkNotes`
  - Keybinding: `<leader>fn`

- **Create New Task:**
  - Command: `:FkNewTask`
  - Keybinding: `<leader>nt`


  
```





