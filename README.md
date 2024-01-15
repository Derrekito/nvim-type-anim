# nvim-type-anim

`nvim-type-anim` enhances the Neovim experience by providing a visually engaging way to display file contents, with user-friendly controls for managing the animation. It is a unique tool for presentations, educational purposes, or to add an interesting visual effect to your Neovim environment.

## Installation

Using packer.nvim:

```lua
use {'derrekito/nvim-type-anim'}
```

Using LazyVim

```lua
return {
    'Derrekito/nvim-type-anim',
    lazy = true,
    config = function()
        require("type-anim").setup({
            AnimToggleKey="<space>",
            AnimKillKey="<C-C>"
        })
    end
}
```

## Usage
### Commands
- `:TypeAnim [file]` Starts the typing animation with the content of [file]. If [file] is omitted and the command is used in a Netrw buffer, it animates the file currently selected.
- `:TypeAnimToggle` Toggles the animation, pausing or resuming it.
- `:TypeAnimKill` Stops the animation and cleans up, restoring any original key mappings.

### Keybindings
- `AnimToggleKey` The key used to toggle the animation. Default is <space>.
- `AnimKillKey` The key used to stop the animation. Default is <C-c>.

### Configuration
You can customize the plugin's behavior by passing a configuration table to the setup function:

```lua
require("type-anim").setup({
    AnimToggleKey = "<space>", -- Key to toggle the animation
    AnimKillKey = "<C-c>"      -- Key to stop the animation
})
```
## Contributing
Contributions are welcome! Please feel free to submit a pull request or create an issue if you have ideas or find bugs.

## License
This plugin is released under the MIT License.
