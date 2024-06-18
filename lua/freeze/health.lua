local M = {}

local ok = vim.health.ok or vim.health.report_ok
local start = vim.health.start or vim.health.report_start
local warn = vim.health.warn or vim.health.report_warn
local error = vim.health.error or vim.health.report_error

M.check = function()
  start("freeze.nvim")

  if vim.fn.executable("freeze") then
    ok("Charm `freeze` is installed")
  else
    error("Charm `freeze` is not installed")
  end

  -- Linux (Wayland)
  if (os.getenv("WAYLAND_DISPLAY") or os.getenv("XDG_SESSION_TYPE") == "wayland") then
    if vim.fn.executable("wl-copy") then
      ok("`wl-clipboard` is installed")
    else
      error("`wl-clipboard` is not installed")
    end

    -- Linux (X11)
  elseif os.getenv("DISPLAY") then
    if vim.fn.executable("xclip") then
      ok("`xclip` is installed")
    else
      error("`xclip` is not installed")
    end

    -- MacOS
  elseif vim.fn.has("mac") == 1 then
    if vim.fn.executable("osascript") then
      ok("`osascript` is installed")
    else
      error("`osascript` is not installed")
    end
    if vim.fn.executable("pngpaste") then
      ok("`pngpaste` is installed")
    else
      warn("`pngpaste` is not installed")
    end

    -- Windows
  elseif vim.fn.has("win32") == 1 or vim.fn.has("wsl") == 1 then
    if vim.fn.executable("powershell.exe") then
      ok("`powershell.exe` is installed")
    else
      error("`powershell.exe` is not installed")
    end

    -- Other OS
  else
    error("Operating system is not supported")
  end
end

return M
