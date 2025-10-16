local M = {}
local signs_module = require("fknotes.highlighter.signs")
local signs = signs_module.get_signs()

-- Map keyword to sign
local keyword_sign_map = {
    TODO = signs[1],
    FIX = signs[2],
    NOTE = signs[3],
    WARN = signs[4],
    PERF = signs[5],
    HACK = signs[6],
    TASK = signs[7],
    DUE = signs[8],
}

M.todo_split_buf = nil

-- Define the header highlight group if it doesn't exist
if vim.fn.hlID("FkNotesHeader") == 0 then
    vim.cmd("highlight FkNotesHeader guifg=#FFD700 gui=bold")
end

-- Function to safely get the file icon (using nvim-web-devicons)
local function get_file_icon(filename)
    -- Check if the required function exists before calling it
    if vim.fn.exists("*WebDevIconsGetFileTypeIcon") == 1 then
        return vim.fn.WebDevIconsGetFileTypeIcon(filename, false)
    end
    -- Fallback icon if the plugin or function is not available
    return " " -- A generic folder icon
end

-- FUNCTION: Search project-wide and return results (uses rg)
local function get_project_todos()
    -- Use ripgrep (-n: line number, -i: case insensitive) to find all keywords in the project
    local keywords_pattern = table.concat(vim.tbl_keys(keyword_sign_map), "|")
    local grep_command = string.format("rg -n -i -g '!*.git/' -g '!*.log' '(%s)[: ]' .", keywords_pattern)
    
    local output = vim.fn.system(grep_command)
    local lines = vim.split(output, "\n")
    local project_todos = {}
    
    -- Parse ripgrep output: filename:line_num:match_text
    for _, line in ipairs(lines) do
        local filename, line_nr, text = line:match("([^:]+):(%d+):(.*)")
        if filename and line_nr and text then
            -- Find the keyword that triggered the match
            for kw, sign in pairs(keyword_sign_map) do
                if text:match(kw) then
                    table.insert(project_todos, {
                        file = filename,
                        line = tonumber(line_nr),
                        text = text:gsub("^%s+", ""), -- remove leading whitespace
                        keyword = kw,
                        sign = sign,
                    })
                    break
                end
            end
        end
    end

    -- Group by file
    local todos_by_file = {}
    for _, todo in ipairs(project_todos) do
        if not todos_by_file[todo.file] then
            todos_by_file[todo.file] = {}
        end
        table.insert(todos_by_file[todo.file], todo)
    end

    return todos_by_file
end

-- FUNCTION: Formats output in a compact, file-grouped structure (todo-comments style)
local function update_split_for_project()
    if not M.todo_split_buf or not vim.api.nvim_buf_is_valid(M.todo_split_buf) then return end

    local todos_by_file = get_project_todos()
    local lines = {}
    local highlights = {}
    local todo_map = {} -- To map display line number back to the original todo item
    local current_line = 0

    table.insert(lines, "Project Todos (ripgrep)")
    table.insert(highlights, { line = 0, hl_group = "FkNotesHeader" })
    current_line = current_line + 1

    for file, todos in pairs(todos_by_file) do
        -- File Header (Breadcrumb Style)
        local file_icon = get_file_icon(file)
        table.insert(lines, "") -- Empty line for separation
        current_line = current_line + 1
        
        -- File path line
        table.insert(lines, string.format("%s %s", file_icon, file))
        table.insert(highlights, { line = current_line, hl_group = "Comment" }) 
        current_line = current_line + 1

        -- List TODOs under the file
        for _, todo in ipairs(todos) do
            local sign_icon = todo.sign.icon
            local sign_name = todo.sign.name
            
            -- Format: [Icon] [Line #] | [KEYWORD]: [Text]
            local todo_line = string.format(" %s %d | %s: %s", sign_icon, todo.line, todo.keyword, todo.text)
            
            table.insert(lines, todo_line)
            
            -- Highlight the sign
            table.insert(highlights, { line = current_line, hl_group = sign_name, col_start = 1, col_end = 1 + #sign_icon })

            -- Create the map for jumping
            todo_map[current_line] = { file = todo.file, line = todo.line }
            
            current_line = current_line + 1
        end
    end

    vim.api.nvim_buf_set_option(M.todo_split_buf, "modifiable", true)
    vim.api.nvim_buf_set_lines(M.todo_split_buf, 0, -1, false, lines)
    vim.api.nvim_buf_clear_namespace(M.todo_split_buf, -1, 0, -1)

    -- Apply highlights
    for _, hl in ipairs(highlights) do
        vim.api.nvim_buf_add_highlight(M.todo_split_buf, -1, hl.hl_group, hl.line, hl.col_start or 0, hl.col_end or -1)
    end

    vim.api.nvim_buf_set_option(M.todo_split_buf, "modifiable", false)
    vim.api.nvim_buf_set_var(M.todo_split_buf, "fknotes_project_todo_map", todo_map)
end


-- Public function to show the split (HORIZONTAL SPLIT)
function M.show_all_todos()
    local orig_win = vim.api.nvim_get_current_win()
    
    if not M.todo_split_buf or not vim.api.nvim_buf_is_valid(M.todo_split_buf) then
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
        vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
        vim.api.nvim_buf_set_option(buf, "modifiable", true)
        vim.api.nvim_buf_set_option(buf, "filetype", "todo_project")
        M.todo_split_buf = buf

        -- Use botright split
        vim.cmd("botright split")
        vim.api.nvim_win_set_buf(0, buf)
        vim.api.nvim_win_set_height(0, 10) -- Default height
        
        -- Keymaps
        vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", [[<Cmd>lua require'fknotes.core.todo_list'.jump_to_project_todo()<CR>]], { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(buf, "n", "q", "<Cmd>close<CR>", { noremap = true, silent = true })

        -- Move cursor back to original window
        vim.api.nvim_set_current_win(orig_win)
    else
        -- If buffer exists, try to jump to the window or reopen
        local wins = vim.api.nvim_tabpage_list_wins(0)
        local todo_win = nil
        for _, win in ipairs(wins) do
            if vim.api.nvim_win_get_buf(win) == M.todo_split_buf then
                todo_win = win
                break
            end
        end

        if todo_win then
            vim.api.nvim_set_current_win(todo_win)
        else
            -- Window closed but buffer exists, reopen the split
            vim.cmd("botright split")
            vim.api.nvim_win_set_buf(0, M.todo_split_buf)
            vim.api.nvim_win_set_height(0, 10)
            vim.api.nvim_set_current_win(orig_win)
        end
    end

    update_split_for_project()
end

-- Jump function (retained)
function M.jump_to_project_todo()
    if not M.todo_split_buf or not vim.api.nvim_buf_is_valid(M.todo_split_buf) then return end
    
    local buf = M.todo_split_buf
    local line_nr = vim.api.nvim_win_get_cursor(0)[1] - 1 
    
    local todo_map = vim.api.nvim_buf_get_var(buf, "fknotes_project_todo_map")
    local target_todo = todo_map[line_nr]

    if target_todo then
        -- Open the file and jump to the line
        vim.cmd("edit " .. target_todo.file)
        vim.api.nvim_win_set_cursor(0, { target_todo.line, 0 })
        
        -- Close the split after jumping
        local wins = vim.api.nvim_tabpage_list_wins(0)
        for _, win in ipairs(wins) do
            if vim.api.nvim_win_get_buf(win) == M.todo_split_buf then
                vim.api.nvim_win_close(win, true)
                M.todo_split_buf = nil
                break
            end
        end
    end
end

return M
