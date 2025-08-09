local M = {}
M.ns_id = vim.api.nvim_create_namespace("quick_notes_form")

function M.new()
  -- Create a new buffer for the form
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')

  -- Initial content for the form
  local lines = {
    '# Quick Notes',
    '---',
    '## Title',
    '',
    '---',
    '## Notes',
    '',
    '---',
    '## Actions',
    '[Save] [Download] [Open] [Reset]'
  }

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Open the buffer in a new window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = 80,
    height = 25,
    row = 10,
    col = 10,
    style = 'minimal',
    border = 'single'
  })

  -- Key mappings for the buttons
  vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', '<Cmd>lua require("fknotes.ui.quick_notes_form").handle_cr()<CR>', { noremap = true, silent = true })

  vim.api.nvim_create_autocmd("CursorMoved", {
    buffer = buf,
    callback = function()
      M.update_button_highlight()
    end,
  })

  return { buf = buf, win = win }
end

function M.save()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local title = ""
  local notes = {}
  local in_notes = false
  for _, line in ipairs(lines) do
    if line:match("^## Title") then
      in_notes = false
    elseif line:match("^## Notes") then
      in_notes = true
    elseif in_notes then
      table.insert(notes, line)
    elseif title == "" and not line:match("^# Quick Notes") and not line:match("^---") and not line:match("^## Title") then
      title = line
    end
  end
  local filename = vim.fn.input("Enter filename (e.g., my_notes.md): ")
  if filename == "" then
    print("Save cancelled.")
    return
  end
  local file = io.open(filename, "w")
  if file then
    file:write("# " .. title .. "\n\n")
    file:write(table.concat(notes, "\n"))
    file:close()
    print("Notes saved to " .. filename)
  else
    print("Error saving notes.")
  end
end

function M.reset()
  local buf = vim.api.nvim_get_current_buf()
  local lines = {
    '# Quick Notes',
    '---',
    '## Title',
    '',
    '---',
    '## Notes',
    '',
    '---',
    '## Actions',
    '[Save] [Download] [Open] [Reset]'
  }
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

function M.open()
  local filename = vim.fn.input("Enter filename to open: ")
  if filename == "" then
    print("Open cancelled.")
    return
  end
  local file = io.open(filename, "r")
  if file then
    local content = file:read("*a")
    file:close()
    local lines = vim.split(content, "\n")
    local title = ""
    local notes = {}
    if #lines > 0 and lines[1]:match("^# ") then
      title = lines[1]:sub(3)
      table.remove(lines, 1)
    end
    notes = lines
    local buf = vim.api.nvim_get_current_buf()
    local form_lines = {
      '# Quick Notes',
      '---',
      '## Title',
      title,
      '---',
      '## Notes',
    }
    for _, line in ipairs(notes) do
      table.insert(form_lines, line)
    end
    table.insert(form_lines, '---')
    table.insert(form_lines, '## Actions')
    table.insert(form_lines, '[Save] [Download] [Open] [Reset]')
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, form_lines)
  else
    print("Error opening file.")
  end
end

function M.download()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local title = ""
  local notes = {}
  local in_notes = false
  for _, line in ipairs(lines) do
    if line:match("^## Title") then
      in_notes = false
    elseif line:match("^## Notes") then
      in_notes = true
    elseif in_notes then
      table.insert(notes, line)
    elseif title == "" and not line:match("^# Quick Notes") and not line:match("^---") and not line:match("^## Title") then
      title = line
    end
  end
  local dir = vim.fn.input("Enter directory to save in: ")
  if dir == "" then
    print("Download cancelled.")
    return
  end
  local filename = vim.fn.input("Enter filename (e.g., my_notes.md): ")
  if filename == "" then
    print("Download cancelled.")
    return
  end
  local file = io.open(dir .. "/" .. filename, "w")
  if file then
    file:write("# " .. title .. "\n\n")
    file:write(table.concat(notes, "\n"))
    file:close()
    print("Notes downloaded to " .. dir .. "/" .. filename)
  else
    print("Error downloading notes.")
  end
end

function M.handle_cr()
  local line = vim.api.nvim_get_current_line()
  if line:match("[Save]") then
    M.save()
  elseif line:match("[Download]") then
    M.download()
  elseif line:match("[Open]") then
    M.open()
  elseif line:match("[Reset]") then
    M.reset()
  end
end

function M.update_button_highlight()
  local buf = vim.api.nvim_get_current_buf()
  local line_num = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_buf_get_lines(buf, line_num - 1, line_num, false)[1]

  vim.api.nvim_buf_clear_namespace(buf, M.ns_id, 0, -1)

  if line:match("## Actions") then
    local col_start, col_end
    if line:match("[Save]") then
      col_start, col_end = line:find("[Save]")
    elseif line:match("[Download]") then
      col_start, col_end = line:find("[Download]")
    elseif line:match("[Open]") then
      col_start, col_end = line:find("[Open]")
    elseif line:match("[Reset]") then
      col_start, col_end = line:find("[Reset]")
    end

    if col_start then
      vim.api.nvim_buf_add_highlight(buf, M.ns_id, "Visual", line_num - 1, col_start - 1, col_end)
    end
  end
end

return M
