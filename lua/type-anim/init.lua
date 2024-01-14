-- init.lua
local TypeAnim = require('type-anim')

function TypeAnim.setup()
    vim.api.nvim_create_user_command('AnimToggle', TypeAnim.toggle_anim, {})
    vim.api.nvim_create_user_command('AnimKill', TypeAnim.kill_anim, {})

    -- Create the TypeAnim command
    vim.api.nvim_create_user_command('TypeAnim',
        function(opts)
            -- Stop any currently running animation first
            TypeAnim.kill_anim()

            -- Start the new animation
            TypeAnim.type_anim(opts.args)
        end,
        { nargs = '?' }  -- Accepts zero or one argument
    )
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
