local M = {}

function M.format(component, text, hl_group)
  text = text:gsub("%%", "%%%%")
  if not hl_group or hl_group == "" then
    return text
  end
  ---@type table<string, string>
  component.hl_cache = component.hl_cache or {}
  local lualine_hl_group = component.hl_cache[hl_group]
  if not lualine_hl_group then
    local utils = require("lualine.utils.utils")
    ---@type string[]
    local gui = vim.tbl_filter(function(x)
      return x
    end, {
      utils.extract_highlight_colors(hl_group, "bold") and "bold",
      utils.extract_highlight_colors(hl_group, "italic") and "italic",
    })

    lualine_hl_group = component:create_hl({
      fg = utils.extract_highlight_colors(hl_group, "fg"),
      gui = #gui > 0 and table.concat(gui, ",") or nil,
    }, "LV_" .. hl_group) --[[@as string]]
    component.hl_cache[hl_group] = lualine_hl_group
  end
  return component:format_hl(lualine_hl_group) .. text .. component:get_default_hl()
end

local function pretty_path(opts)
  opts = vim.tbl_extend("force", {
    relative = "cwd",
    modified_hl = "MatchParen",
    directory_hl = "",
    filename_hl = "Bold",
    modified_sign = "",
    readonly_icon = " 󰌾 ",
    length = 3,
  }, opts or {})

  return function(self)
    local path = vim.fn.expand("%:p") --[[@as string]]

    if path == "" then
      return ""
    end

    local root = require("util.root").root({ normalize = true })
    local cwd = require("util.root").cwd()

    if opts.relative == "cwd" and path:find(cwd, 1, true) == 1 then
      path = path:sub(#cwd + 2)
    else
      path = path:sub(#root + 2)
    end

    local sep = package.config:sub(1, 1)
    local parts = vim.split(path, "[\\/]")

    if opts.length == 0 then
      parts = parts
    elseif #parts > opts.length then
      parts = { parts[1], "…", table.concat({ unpack(parts, #parts - opts.length + 2, #parts) }, sep) }
    end

    if opts.modified_hl and vim.bo.modified then
      parts[#parts] = parts[#parts] .. opts.modified_sign
      parts[#parts] = M.format(self, parts[#parts], opts.modified_hl)
    else
      parts[#parts] = M.format(self, parts[#parts], opts.filename_hl)
    end

    local dir = ""
    if #parts > 1 then
      dir = table.concat({ unpack(parts, 1, #parts - 1) }, sep)
      dir = M.format(self, dir .. sep, opts.directory_hl)
    end

    local readonly = ""
    if vim.bo.readonly then
      readonly = M.format(self, opts.readonly_icon, opts.modified_hl)
    end
    return dir .. parts[#parts] .. readonly
  end
end

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
      event = "VeryLazy",
      opts = vim.tbl_deep_extend("force", {
        options = {
          theme = "auto",
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = { pretty_path() },
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
  return {
    statuslines[opts.statusline](opts.theme),
  }
end

return M
