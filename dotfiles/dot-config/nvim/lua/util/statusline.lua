M = {}

-- From LazyVim's UI settings
local command_component = function()
  ---@diagnostic disable-next-line: undefined-field
  if require("noice").api.status.command.has() then
    ---@diagnostic disable-next-line: undefined-field
    return require("noice").api.status.command.get()
  end
  return ""
end

-- From LazyVim's UI settings
local mode_component = function()
  ---@diagnostic disable-next-line: undefined-field
  if require("noice").api.status.mode.has() then
    ---@diagnostic disable-next-line: undefined-field
    return require("noice").api.status.mode.get()
  end
  return ""
end

-- From slimline's filetype_lsp component
local lsp_component = function()
  local attached_clients = vim.lsp.get_clients({ bufnr = 0 })
  local it = vim.iter(attached_clients)
  it:map(function(client)
    local name = client.name:gsub("language.server", "ls")
    return name
  end)
  local names = it:totable()
  local lsp_clients = string.format("%s", table.concat(names, ","))
  return lsp_clients
end

local slimline_themes = {
  minimal = {
    style = "fg",
    spaces = { left = "", right = "" },
    sep = {
      hide = { first = true, last = true },
      left = "",
      right = "",
    },
  },
  bubble = {
    spaces = { left = "", right = "" },
    sep = {
      hide = { first = true, last = true },
      left = "",
      right = "",
    },
  },
}

local lualine_themes = {
  minimal = {
    options = {
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
    },
  },
  bubble = {
    options = {
      component_separators = { left = "|", right = "|" },
      section_separators = { left = "", right = "" },
    },
  },
}

local statuslines = {
  lualine = function(selected_theme)
    return {
      "nvim-lualine/lualine.nvim",
      opts = vim.tbl_deep_extend("force", {
        sections = {
          lualine_c = {
            LazyVim.lualine.pretty_path(),
          },
          lualine_x = {
            command_component,
            mode_component,
          },
          lualine_y = {
            "diagnostics",
            lsp_component,
            "filetype",
          },
          lualine_z = {
            "progress",
            "location",
          },
        },
        extensions = {
          "lazy",
          "mason",
          "nvim-dap-ui",
          "oil",
          "quickfix",
          "toggleterm",
          "trouble",
        },
      }, lualine_themes[selected_theme]),
    }
  end,
  slimline = function(selected_theme)
    return {
      "sschleemilch/slimline.nvim",
      event = "VeryLazy",
      opts = vim.tbl_deep_extend("force", {
        components = {
          left = {
            "mode",
            "path",
          },
          right = {
            command_component,
            mode_component,
            "diagnostics",
            "filetype_lsp",
            "progress",
          },
        },
        hl = {
          modes = {
            normal = "Function", -- blue
            insert = "String", -- green
            pending = "error", -- red
            visual = "Keyword", -- purple
            command = "Boolean", -- orange
          },
        },
      }, slimline_themes[selected_theme]),
    }
  end,
}

---@class StatusLineOpts
---@field statusline string
---|"'lualine'"
---|"'slimline'"
---@field theme string
---|"'minimal'"
---|"'bubble'"

---@param opts StatusLineOpts
function M.get(opts)
  local disable_lualine = {}
  if opts.statusline ~= "lualine" then
    disable_lualine = {
      "nvim-lualine/lualine.nvim",
      enabled = false,
    }
  end
  return {
    statuslines[opts.statusline](opts.theme),
    disable_lualine,
  }
end

return M
