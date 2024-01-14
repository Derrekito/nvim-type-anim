local TypeAnim = {}
-- Global state for animation control
TypeAnim.anim_state = {
    is_paused = false,
    is_active = false,
    defer_id = nil,
    put_char = nil,
    resume_state = nil
}


function TypeAnim.get_file_path()
    local current_file_dir = vim.fn.expand('%:p:h')  -- Directory of the current file
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2] + 1
    local paths = {}
    for path in line:gmatch("[^ ]+") do
        table.insert(paths, path)
    end

    local file_under_cursor
    local cumulative_len = 0
    for _, path in ipairs(paths) do
        path = path:gsub("[*]", "")  -- Remove asterisks or special characters
        cumulative_len = cumulative_len + #path
        if col <= cumulative_len then
            file_under_cursor = path
            break
        end
        cumulative_len = cumulative_len + 1
    end

    if file_under_cursor then
        -- Resolve the full path (handles both absolute and relative paths)
        local full_path = vim.fn.resolve(vim.fn.fnamemodify(current_file_dir .. '/' .. file_under_cursor, ':p'))
        return full_path
    end

    return nil  -- Return nil if no file path is found under the cursor
end

-- Function to animate typing the contents of a file
function TypeAnim.type_anim(filename)
    -- If no filename is given, try to get the file under the cursor
    if not filename or filename == '' then
        filename = TypeAnim.get_file_path()
        if not filename then
            print("No filename provided and no file found under cursor.")
            return
        end
        -- Sanitize the filename to remove any trailing characters like asterisks
        filename = filename:gsub("[*]", "")
    end

    -- Read the content of the file
    local file = io.open(filename, "r")
    if not file then
        print("File not found: " .. filename)
        return
    end
    local content = file:read("*all")
    file:close()

    -- Create a new buffer and set it as the current modifiable buffer
    local buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_set_current_buf(buf)
    vim.api.nvim_buf_set_option(buf, 'modifiable', true)

    -- Extract the file extension and set the filetype of the buffer
    local extension = filename:match("^.+(%..+)$")
    if extension then
        local filetype = extension:sub(2) -- Remove the dot from the extension
        vim.api.nvim_buf_set_option(buf, 'filetype', filetype)
    end

    -- Insert the file content character by character
    local function put_char(buff, cont, index, line, col)
        if not TypeAnim.anim_state.is_active or index > #cont then
            TypeAnim.anim_state.is_active = false
            return -- End the animation
        end

        if index > #cont then
            return -- End the recursion when all characters are processed
        end

        if TypeAnim.anim_state.is_paused then
            -- Save the current state for later resumption
            TypeAnim.anim_state.resume_state = {buff, cont, index, line, col}
            return -- Pause the animation
        end
        local char = content:sub(index, index)
        local next_index = index + 1
        local next_line, next_col

        if char == "\n" then
            -- Insert a new line. The new line should be below the current line
            vim.api.nvim_buf_set_lines(buff, line + 1, line + 1, false, {""})
            next_line = line + 1
            next_col = 0
        else
            -- Replace the character at the current position
            vim.api.nvim_buf_set_text(buff, line, col, line, col, {char})
            next_line = line
            next_col = col + 1
        end

        -- Continue with the next character
        vim.defer_fn(function() put_char(buff, content, next_index, next_line, next_col) end, 50)
    end
    -- Inside type_anim, after defining put_char
    TypeAnim.anim_state.put_char = put_char
    TypeAnim.anim_state.is_active = true
    -- Continue with the next character
    TypeAnim.anim_state.defer_id = vim.defer_fn(function()
        put_char(buf, content, 1, 0, 0)
    end, 50)
end

-- Function to resume the animation from the paused state
function TypeAnim.resume_anim()
    if TypeAnim.anim_state.resume_state then
        -- Resume from the saved state
        TypeAnim.anim_state.is_paused = false
        if not table.unpack then
            table.unpack = unpack
        end
        TypeAnim.anim_state.put_char(table.unpack(TypeAnim.anim_state.resume_state))
        TypeAnim.anim_state.resume_state = nil
    end
end

function TypeAnim.toggle_anim()
    TypeAnim.anim_state.is_paused = not TypeAnim.anim_state.is_paused
    if not TypeAnim.anim_state.is_paused and TypeAnim.anim_state.resume_state then
        TypeAnim.resume_anim()
    end
end

function TypeAnim.kill_anim()
    TypeAnim.anim_state.is_active = false
end

return TypeAnim
