local opts = require("freeze.config").opts
local debug = require("freeze.debug")

local M = {}

---@return number | nil start_pos
---@return number | nil end_pos
M.get_visual_selection_range = function()
  local mode = vim.fn.mode()
  if mode == "V" or mode == "v" then
    local start_pos = vim.fn.getpos("v")[2]
    local end_pos = vim.fn.getpos(".")[2]
    return start_pos, end_pos
  else
    return nil, nil
  end
end

---@param imgpath string
---@return number | nil code
M.copy_image_to_clipboard = function(imgpath)
  if opts.clip_cmd then
    local command = opts.clip_cmd
    local _, exit_code = M.execute(command)
    return exit_code

    -- Windows
  elseif (vim.fn.has("win32") == 1 or vim.fn.has("wsl") == 1) and vim.fn.executable("powershell.exe") then
    local command = string.format("Get-ChildItem %s Path> | Set-Clipboard", imgpath)
    local _, exit_code = M.execute(command)
    return exit_code

    -- MacOS
  elseif vim.fn.has("mac") == 1 then
    if vim.fn.executable("pbcopy") then
      local command = string.format("pbcopy < %s", imgpath)
      local _, exit_code = M.execute(command)
      return exit_code
    end

    -- Linux (Wayland)
  elseif os.getenv("WAYLAND_DISPLAY") and vim.fn.executable("wl-paste") then
    local command = string.format("wl-copy < %s", imgpath)
    local _, exit_code = M.execute(command)
    return exit_code

    -- Linux (X11)
  elseif os.getenv("DISPLAY") and vim.fn.executable("xclip") then
    local command = string.format("xclip -selection clipboard -t image/png %s", imgpath)
    local _, exit_code = M.execute(command)
    return exit_code
  else
    return nil
  end
end

---@param input_cmd string
---@param execute_directly? boolean
---@return string | nil output
---@return number exit_code
M.execute = function(input_cmd, execute_directly)
  local shell = vim.o.shell:lower()
  local cmd

  -- execute command directly if shell is powershell or pwsh or explicitly requested
  if execute_directly or shell:match("powershell") or shell:match("pwsh") then
    cmd = input_cmd

    -- WSL requires the command to have the format:
    -- powershell.exe -Command 'command "path/to/file"'
  elseif vim.fn.has("wsl") == 1 then
    if input_cmd:match("curl") then
      cmd = input_cmd
    else
      cmd = "powershell.exe -NoProfile -Command '" .. input_cmd:gsub("'", '"') .. "'"
    end

    -- cmd.exe requires the command to have the format:
    -- powershell.exe -Command "command 'path/to/file'"
  elseif vim.fn.has("win32") == 1 then
    cmd = 'powershell.exe -NoProfile -Command "' .. input_cmd:gsub('"', "'") .. '"'

    -- otherwise (linux, macos), execute the command directly
  else
    cmd = "sh -c " .. vim.fn.shellescape(input_cmd)
  end

  local output = vim.fn.system(cmd)
  local exit_code = vim.v.shell_error

  debug.log("Shell: " .. shell)
  debug.log("Command: " .. cmd)
  debug.log("Exit code: " .. exit_code)
  debug.log("Output: " .. output)

  return output, exit_code
end

return M
