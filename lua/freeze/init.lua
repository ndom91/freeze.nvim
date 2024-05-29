local opts = require("freeze.config").opts
local Job = require("plenary.job")
local utils = require("freeze.utils")

local freeze = {}

freeze.exec = function()
  print("freeze.exec()")
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

  local textpath = "/tmp/_nvim_freeze_code.txt"
  local imgpath = "/tmp/_nvim_freeze.png"

  local args = {
    "--theme",
    opts.theme,
    textpath,
    "-o",
    imgpath,
    -- "--font",
    -- opts.font,
    "--language",
    vim.bo.filetype,
    -- "--line-offset",
    -- opts.lineOffset,
    -- "--line-pad",
    -- opts.linePad,
    -- "--pad-horiz",
    -- opts.padHoriz,
    -- "--pad-vert",
    -- opts.padVert,
    -- "--shadow-blur-radius",
    -- opts.shadowBlurRadius,
    -- "--shadow-color",
    -- opts.shadowColor,
    -- "--shadow-offset-x",
    -- opts.shadowOffsetX,
    -- "--shadow-offset-y",
    -- opts.shadowOffsetY,
  }

  if #lines ~= 0 then
    -- 1. Write text to file
    local tempbuf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(tempbuf, 0, -1, false, lines)
    local _, err_msg = pcall(vim.fn.writefile, lines, textpath)

    if err_msg ~= 0 then
      vim.notify("Error writing file: " .. err_msg, vim.log.levels.ERROR, { plugin = "freeze.nvim" })
    end

    -- 2. Run `freeze` outputting to tmp png file
    local job = Job:new({
      command = "freeze",
      args = args,
      on_exit = function(_, code)
        if code == 0 then
          local msg = ""
          -- 3. Copy tmp png file to clipboard
          msg = "Text frozen to clipboard!"
          vim.defer_fn(function()
            utils.copy_image_to_clipboard(imgpath)
          end, 0)
          vim.defer_fn(function()
            vim.notify(msg, vim.log.levels.INFO, { plugin = "freeze.nvim" })
          end, 0)

          -- Cleanup
          vim.defer_fn(function()
            vim.api.nvim_buf_delete(tempbuf, { force = true })
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
      on_stderr = function(a, data)
        print("freeze.on_error", vim.inspect(a))
        if opts.debug then
          print(vim.inspect(data))
        end
      end,
      writer = table.concat(lines, "\n"),
      cwd = vim.fn.getcwd(),
    })
    job:sync()
  else
    vim.notify("Unable to get lines to generate screenshot", vim.log.levels.WARN, { plugin = "freeze.nvim" })
  end
end

return freeze
