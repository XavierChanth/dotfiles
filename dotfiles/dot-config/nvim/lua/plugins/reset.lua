local plugins = {
  "folke/tokyonight.nvim",
  "echasnovski/mini.pairs",
  "nvim-pack/nvim-spectre",
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
