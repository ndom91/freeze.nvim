local config = {}

config.opts = {
  debug = true,
  theme = "dracula",
  windowControls = true,
  -- backgroundColor = "#1E1E1E",
  -- margin = 2,
  -- padding = 2,
  -- borderRadius = 8,
  -- borderWidth = 1,
  -- borderColor = "#515151",
  -- shadowBlur = 20,
  -- shadowX = 0,
  -- shadowY = 10,
  showLineNumbers = true,
  -- fontFamily = "monospace",
  -- fontSize = 16,
  -- fontLigatures = true,
}

--- @param opts table
config.setup = function(opts)
  config.opts = vim.tbl_deep_extend("force", config.opts, opts or {})
end

return config
