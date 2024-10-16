local plugins = {}

-- disabled plugins - added by LazyVim, but I don't want.
local disabled = {
  "echasnovski/mini.pairs",
  "akinsho/bufferline.nvim",
  -- "nvim-lualine/lualine.nvim",
  "nvim-neo-tree/neo-tree.nvim",
}

for _, plugin in ipairs(disabled) do
  if type(plugin) == "string" then
    plugins[#plugins + 1] = { plugin }
  else
    plugins[#plugins + 1] = plugin
  end
  plugins[#plugins].enabled = false
end

return plugins
