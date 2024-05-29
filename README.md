# freeze.nvim

Simple plugin to screenshot your currently highlighted text and pass it into Charm's [freeze](https://github.com/charmbracelet/freeze) CLI.

<img  width="50%" src="screenshot.png" />

## ⚡️ Requirements

- Neovim >= **0.8.0**
- Linux: [xclip](https://github.com/astrand/xclip) (x11) or [wl-clipboard](https://github.com/bugaevc/wl-clipboard) (wayland)
- MacOS: [pbcopy](https://ss64.com/mac/pbcopy.html)
- Windows: No additional requirements

> [!WARNING]
> Run `:checkhealth freeze` after installation to ensure requirements are satisfied.

## 📦 Installation

### [Packer](https://github.com/wbthomason/packer.nvim)
```lua
use {
  "ndom91/freeze.nvim",
  requires = { "nvim-lua/plenary.nvim" },
  config = function()
    require('freeze').setup({
      fontSize = 12,
    })
  end
}
```

### [Lazy](https://github.com/folke/lazy.nvim)

```lua
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


## 🏗️ Usage

After adding it to your plugin manager of choice and installing, you can simply call it with any keybinding you like.

```lua
vim.keymap.set("n", "<leader>f", function() freeze:exec() end)
```

### Options

All available options are listed below, these are all passed on to [Charm's CLI flags](https://github.com/charmbracelet/freeze#flags).

```lua
{
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
  fontLigatures = true
}
```

## 👷 Development

With NixOS, you can make use of the devshell in `flake.nix`.

```sh
nix develop
```

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

- [nvim-lua-guide]: https://github.com/nanotee/nvim-lua-guide
- [plenary]: https://github.com/nvim-lua/plenary.nvim
