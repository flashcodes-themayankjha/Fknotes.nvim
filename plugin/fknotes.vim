if exists('g:loaded_fknotes') | finish | endif

command! Fknotes lua require('fknotes').open_menu()

let g:loaded_fknotes = 1