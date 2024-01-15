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
```lua
require('type-anim').setup()
```

### Commands

`TypeAnim`
`AnimToggle`
`AnimKill`
