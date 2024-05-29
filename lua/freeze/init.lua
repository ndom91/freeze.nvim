local Job = require("plenary.job")
local opts = require("freeze.config").opts
local utils = require("freeze.utils")
local debug = require("freeze.debug")

local freeze = {}

freeze.setup = function(o)
  require("freeze.config").setup(o)

  vim.api.nvim_create_user_command("Freeze", function()
    freeze.exec()
  end, { range = true })
end

freeze.exec = function()
  -- 0. Get buffer contents
  local lines = {}
  local buf = vim.api.nvim_get_current_buf()
  local start_line, end_line = utils.get_visual_selection_range()

  if start_line and end_line then
    -- Use visual mode selected lines
    lines = vim.api.nvim_buf_get_lines(buf, start_line - 1, end_line, false)
  else
    -- Use all lines in buffer
    lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  end

  debug.log(vim.inspect(lines))

  local textpath = "/tmp/_nvim_freeze_code.txt"
  local imgpath = "/tmp/_nvim_freeze.png"

  local args = {
    "--theme",
    opts.theme,
    textpath,
    "-o",
    imgpath,

    "--language",
    vim.bo.filetype,
  }

  if opts.backgroundColor then
    table.insert(args, "--background " .. opts.backgroundColor)
  end

  if opts.margin then
    table.insert(args, "--margin " .. opts.margin)
  end

  if opts.padding then
    table.insert(args, "--padding " .. opts.padding)
  end

  if opts.borderRadius then
    table.insert(args, "--border.radius " .. opts.borderRadius)
  end

  if opts.borderWidth then
    table.insert(args, "--border.width " .. opts.borderWidth)
  end

  if opts.borderColor then
    table.insert(args, "--border.color " .. opts.borderColor)
  end

  if opts.fontSize then
    table.insert(args, "--font.size " .. opts.fontSize)
  end

  if opts.fontFamily then
    table.insert(args, "--font.family " .. opts.fontFamily)
  end

  if opts.shadowBlur then
    table.insert(args, "--shadow.blur " .. opts.shadowBlur)
  end

  if opts.shadowY then
    table.insert(args, "--shadow.y " .. opts.shadowY)
  end

  if opts.shadowX then
    table.insert(args, "--shadow.x " .. opts.shadowX)
  end

  if opts.windowControls then
    table.insert(args, "--window")
  end

  if opts.showLineNumbers then
    table.insert(args, "--show-line-numbers")
  end

  debug.log("Args" .. vim.inspect(args))

  if #lines ~= 0 then
    -- 1. Write text to file
    local _, err_msg = pcall(vim.fn.writefile, lines, textpath)

    if err_msg ~= 0 then
      vim.notify("Error writing file: " .. err_msg, vim.log.levels.ERROR, { plugin = "freeze.nvim" })
    end

    -- 2. Run `freeze` on file to generate image
    local job = Job:new({
      command = "freeze",
      args = args,
      on_exit = function(_, code)
        if code == 0 then
          local msg = ""
          -- 3. Copy png file to clipboard
          msg = "Screenshot copied to clipboard!"
          vim.defer_fn(function()
            utils.copy_image_to_clipboard(imgpath)
          end, 0)
          vim.defer_fn(function()
            vim.notify(msg, vim.log.levels.INFO, { plugin = "freeze.nvim" })
          end, 0)

          -- 4. Cleanup
          vim.defer_fn(function()
            vim.fn.delete(textpath)
            vim.fn.delete(imgpath)
          end, 0)
        else
          vim.defer_fn(function()
            vim.notify(
              "Some error occured while executing freeze.nvim",
              vim.log.levels.ERROR,
              { plugin = "freeze.nvim" }
            )
          end, 0)
        end
      end,
      on_stderr = function(proc, code)
        debug.log(code .. vim.inspect(proc))
      end,
      writer = table.concat(lines, "\n"),
      cwd = vim.fn.getcwd(),
    })
    job:sync()
  else
    vim.notify("Unable to get lines to generate screenshot", vim.log.levels.WARN, { plugin = "freeze.nvim" })
  end

  if opts.debug then
    debug.print_log()
  end
end

return freeze
