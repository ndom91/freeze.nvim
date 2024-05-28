local opts = require("freeze.config").opts
local Job = require("plenary.job")

local freeze = {}

print("freeeze! 0")

freeze.init = function(o)
  require("freeze.config").setup(o)
  -- vim.g.freeze = freeze.exec
  -- vim.api.nvim_create_user_command("Freeze", freeze.exec(), {})
  vim.keymap.set("n", "<Leader>f", function()
    freeze.exec()
  end)
end

freeze.exec = function()
  print("freeeze! 1")
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  -- local args = {
  --   "--font",
  --   opts.font,
  --   "--language",
  --   vim.bo.filetype,
  --   "--line-offset",
  --   opts.lineOffset,
  --   "--line-pad",
  --   opts.linePad,
  --   "--pad-horiz",
  --   opts.padHoriz,
  --   "--pad-vert",
  --   opts.padVert,
  --   "--shadow-blur-radius",
  --   opts.shadowBlurRadius,
  --   "--shadow-color",
  --   opts.shadowColor,
  --   "--shadow-offset-x",
  --   opts.shadowOffsetX,
  --   "--shadow-offset-y",
  --   opts.shadowOffsetY,
  --   "--theme",
  --   opts.theme,
  -- }

  local textCode = table.concat(lines, "\n")

  if #textCode ~= 0 then
    -- 1. Write text to file
    vim.defer_fn(function()
      if vim.fn.executable("wl-copy") == 1 then
        vim.api.nvim_exec2(string.format("silent !echo %s > /tmp/_nvim_freeze_code.txt", textCode), { output = false })
      end
    end, 0)

    -- 2. Run `freeze` outputting to tmp png file
    local job = Job:new({
      command = "freeze",
      args = {
        "/tmp/_nvim_freeze_code.txt",
        "-o /tmp/_nvim_freeze.png",
      },
      on_exit = function(_, code, ...)
        if code == 0 then
          local msg = ""
          -- 3. Copy tmp png file to clipboard

          msg = "Snapped to clipboard"
          vim.defer_fn(function()
            if vim.fn.executable("wl-copy") == 1 then
              vim.api.nvim_exec2(
                string.format("silent !wl-copy < /tmp/_nvim_freeze.png", opts.output),
                { output = true }
              )
            end
          end, 0)
          vim.defer_fn(function()
            vim.notify(msg, vim.log.levels.INFO, { plugin = "freeze.nvim" })
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
      on_stderr = function(_, data, ...)
        if opts.debug then
          print(vim.inspect(data))
        end
      end,
      writer = textCode,
      cwd = vim.fn.getcwd(),
    })
    job:sync()
  else
    vim.notify("Please select code snippet in visual mode first!", vim.log.levels.WARN)
  end
end

return freeze
