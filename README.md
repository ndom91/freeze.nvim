# freeze.nvim

Simple plugin to screenshot your currently highlighted text and pass it into Charm's [freeze](https://github.com/charmbracelet/freeze) CLI.

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
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
}
```

## Usage

After adding it to your plugin manager of choice and installing, you can simply call it with any keybinding you like.

```lua
vim.keymap.set("n", "<leader>ss", function() freeze:snap() end)
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
