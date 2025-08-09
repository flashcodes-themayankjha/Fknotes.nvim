local fknotes = {}

function fknotes.setup(config)
  require("fknotes.config").setup(config)
end

function fknotes.open_menu()
  require("fknotes.ui.menu").open_main_menu()
end

return fknotes