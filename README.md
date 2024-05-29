# freeze.nvim

Simple plugin to screenshot your currently highlighted text and pass it into Charm's [freeze](https://github.com/charmbracelet/freeze) CLI.

<img  width="50%" src="screenshot.png" />

## Installation

- neovim 0.8.0+ required
- Install using your favorite plugin manager

```lua
-- Packer
use {
    "ndom91/freeze.nvim",
}
```

```lua
-- lazy.nvim
{
    "ndom91/freeze.nvim",
    keys = {
      {
        "<leader>f",
        function() require("freeze").exec() end,
        mode = { "n", "v" },
        desc = "[F]reeze",
        noremap = true,
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
}
```

## Usage

After adding it to your plugin manager of choice and installing, you can simply call it with any keybinding you like.

```lua
vim.keymap.set("n", "<leader>f", function() freeze:exec() end)
```

### Options

All available options are listed below

```lua
{
    "ndom91/freeze.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
        -- Defaults
        debug = false,
        theme = "dracula",
        windowControls = true,
        showLineNumbers = true,

        -- Rest
        backgroundColor = "#1E1E1E",
        margin = 2,
        padding = 2,
        borderRadius = 8,
        borderWidth = 1,
        borderColor = "#515151",
        shadowBlur = 20,
        shadowX = 0,
        shadowY = 10,
        fontFamily = "monospace",
        fontSize = 16,
        fontLigatures = true,
    }
}
```

## Development

### Run tests

Running tests requires [plenary.nvim][plenary] to be checked out in the parent directory of _this_ repository.
You can then run:

```bash
nvim --headless --noplugin -u tests/minimal.vim -c "PlenaryBustedDirectory tests/ {minimal_init = 'tests/minimal.vim'}"
```

Or if you want to run a single test file:

```bash
nvim --headless --noplugin -u tests/minimal.vim -c "PlenaryBustedDirectory tests/path_to_file.lua {minimal_init = 'tests/minimal.vim'}"
```

[nvim-lua-guide]: https://github.com/nanotee/nvim-lua-guide
[plenary]: https://github.com/nvim-lua/plenary.nvim
