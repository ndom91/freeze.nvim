# freeze.nvim

Neovim plugin to consume some text, pass it into Charm's [freeze](https://github.com/charmbracelet/freeze) CLI to generate a screenshot, and then put it into your clipboard.

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
  lazy = false,
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

You can call freeze with a keybinding or with the `Freeze` command. To make sure the `Freeze` command is always available, make sure to disable lazy loading of the plugin (`lazy = false` in the `Lazy.nvim` configuration).

```lua
vim.keymap.set("n", "<leader>f", function() freeze.exec() end)
```

In `normal` mode, it will pass on the entire current buffer to be screenshotted. However, if you highlight a block of text in `visual` mode, only that will be used for the screenshot.

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

- nvim-lua-guide: https://github.com/nanotee/nvim-lua-guide
- plenary: https://github.com/nvim-lua/plenary.nvim

## 📝 License

MIT
