local plugins = {
  "echasnovski/mini.pairs",
  "nvim-pack/nvim-spectre",
  "nvim-neo-tree/neo-tree.nvim",
  "akinsho/bufferline.nvim",
}

local res = {}

for _, plugin in ipairs(plugins) do
  if type(plugin) == "string" then
    res[#res + 1] = { plugin }
  else
    res[#res + 1] = plugin
  end
  res[#res].enabled = false
end

return res
