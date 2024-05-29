local config = {}

config.opts = {
  debug = false,
  theme = "dracula",
  windowControls = true,
  showLineNumbers = true,
}

--- @param opts table
config.setup = function(opts)
  config.opts = vim.tbl_deep_extend("force", config.opts, opts or {})
end

return config
