-- init.lua
local TypeAnim = require('type-anim.type-anim')

function TypeAnim.setup(opts)
    -- Ensure opts is a table
    opts = opts or {}
    -- Key bindings setup
    local AnimToggleKey = opts.AnimToggleKey or "<space>"
    local AnimKillKey = opts.AnimKillKey or "<C-c>"

    -- Function to find the original keymap for a given key
    local function find_original_keymap(key)
        local mappings = vim.api.nvim_get_keymap('n')
        for _, map in ipairs(mappings) do
            if map.lhs == key then
                return map
            end
        end
        return nil
    end

    -- Save original key mappings before setting new ones
    local AnimKillKey_orig = find_original_keymap(AnimKillKey)
    local AnimToggleKey_orig = find_original_keymap(AnimToggleKey)

    -- Store the keys in a table
    TypeAnim.keys = {
        AnimToggleKey_orig = AnimToggleKey_orig,
        AnimKillKey_orig = AnimKillKey_orig,
        AnimToggleKey = AnimToggleKey,
        AnimKillKey = AnimKillKey
    }

    -- Create user commands
    vim.api.nvim_create_user_command('TypeAnimToggle', TypeAnim.toggle_anim, {})
    vim.api.nvim_create_user_command('TypeAnimKill', TypeAnim.kill_anim, {})

    -- Set up key mappings
    if TypeAnim.toggle_anim then
        vim.keymap.set("n", AnimToggleKey, TypeAnim.toggle_anim, { silent = true })
    else
        print("Error: TypeAnim.toggle_anim function not found.")
    end

    if TypeAnim.kill_anim then
        vim.keymap.set("n", AnimKillKey, TypeAnim.kill_anim, { silent = true })
    else
        print("Error: TypeAnim.kill_anim function not found.")
    end

    -- Create the TypeAnim command
    vim.api.nvim_create_user_command('TypeAnim',
        function(args)
            -- Start the new animation with provided argument
            TypeAnim.type_anim(args.args)
        end,
        { nargs = '?' }  -- Accepts zero or one argument
    )
end

return TypeAnim
