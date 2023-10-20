require('xavierchanth.lazy-init')

require('lazy').setup({
  require('xavierchanth.config.global'),
}, {
  custom_keys = {
    ["<localleader>l"] = false,
    ["<localleader>t"] = false,
  }
})

require('xavierchanth.config.global')