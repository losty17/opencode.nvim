# opencode.nvim

Neovim plugin for [opencode](https://opencode.ai) — a terminal CLI for interacting with AI models.

## Features

- Toggle a vertical panel with opencode running
- Horizontally resizable (drag the border or use `:vertical resize +/-`)
- Default keymap: `<leader>oc`
- Remembers terminal buffer across toggles

## Installation

### lazy.nvim

```lua
{
  "anomalyco/opencode.nvim",
  config = function()
    require("opencode").setup()
  end
}
```

### packer.nvim

```lua
use {
  "anomalyco/opencode.nvim",
  config = function()
    require("opencode").setup()
  end
}
```

## Configuration

```lua
require("opencode").setup({
  cmd = "opencode",      -- command to run
  width = 80,            -- panel width
  side = "right",        -- "left" or "right"
})
```

## Usage

Press `<leader>oc` to toggle the opencode panel.

Resize the panel:
- Drag the vertical border with your mouse
- Or run `:vertical resize +10` / `:vertical resize -10`
