# opencode.nvim

Neovim plugin for [opencode](https://opencode.ai) — a terminal CLI for interacting with AI models.

## Features

- Toggle a panel with opencode running
- Resizable (drag the border or use `:resize` / `:vertical resize`)
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
  width = 80,            -- panel width (for left/right)
  height = 20,           -- panel height (for top/bottom)
  side = "right",        -- "left", "right", "top", or "bottom"
})
```

## Usage

Press `<leader>oc` to toggle the opencode panel.

Resize the panel:
- Drag the border with your mouse
- Or run `:resize +10` / `:resize -10` (vertical splits: `:vertical resize +10` / `:vertical resize -10`)
