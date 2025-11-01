local flat = nil
return {
  load = function(spec)
    vim.pack.add(spec)
    for _, plugin in ipairs(spec) do
      if plugin.data and plugin.data.config then
        require(plugin.data.config)
      end
    end
  end,
  install = function()
    if flat == nil then
      local spec = require("assets.pack-spec")
      flat = {}
      for _, v in ipairs(spec.init) do
        table.insert(flat, v)
      end
      for _, v in ipairs(spec.lazy) do
        table.insert(flat, v)
      end
      for _, lang in pairs(spec.ft) do
        for _, v in ipairs(lang) do
          table.insert(flat, v)
        end
      end
    end
    vim.pack.add(flat)
  end,
}
