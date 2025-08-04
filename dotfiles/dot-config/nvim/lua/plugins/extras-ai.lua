return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      suggestions = { enabled = false },
      panel = { enabled = false },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    build = "make tiktoken", -- Only on MacOS or Linux
    init = function()
      vim.treesitter.language.register("markdown", "copilot-chat")
    end,
    opts = {
      model = "claude-3.5-sonnet",
      temperature = 0.1,

      -- Enable intelligent resource processing (skips unnecessary resources to save tokens)
      resource_processing = true,

      headers = {
        user = "## 👤 You: ",
        assistant = "## 🤖 Copilot: ",
        tool = "## 🔧 Tool: ",
      },

      window = {
        layout = "float",
        border = "none",
        width = 1,
        height = 1,
      },

      -- providers = {},

      -- functions = {},

      -- prompts = {},

      mappings = {
        complete = {
          insert = "<CR>",
        },
      },
    },
    keys = {
      {
        "<leader>ll",
        function()
          local mode = vim.api.nvim_get_mode().mode
          require("CopilotChat").open({
            selection = function(source)
              local select = require("CopilotChat.select")
              if mode == "v" then
                return select.visual(source)
              end
              return select.buffer(source)
            end,
          })
        end,
        mode = { "n", "v" },
        desc = "Copilot",
      },
    },
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "bundled_build.lua", -- Bundles `mcp-hub` binary along with the neovim plugin
    cmd = { "MCPHub" },
    keys = {
      {
        "<leader>lm",
        "<cmd>MCPHub<CR>",
        desc = "MCPHub",
      },
    },
    opts = {
      use_bundled_binary = true, -- Use local `mcp-hub` binary
      config = vim.fn.expand("~/.config/mcphub/servers.json"),
      port = 37373,

      mcp_request_timeout = 5000, -- in ms

      auto_approve = false, -- Auto approve mcp tool calls
      auto_toggle_mcp_servers = true, -- Let LLMs start and stop MCP servers automatically

      extensions = {
        copilotchat = {
          enabled = true,
          convert_tools_to_functions = true, -- Convert MCP tools to CopilotChat functions
          convert_resources_to_functions = true, -- Convert MCP resources to CopilotChat functions
          add_mcp_prefix = true, -- Add "mcp_" prefix to function names
        },
      },

      workspace = {
        enabled = true, -- Enable project-local configuration files
        look_for = { ".mcphub/servers.json", ".vscode/mcp.json", ".cursor/mcp.json" }, -- Files to look for when detecting project boundaries (VS Code format supported)
        reload_on_dir_changed = true, -- Automatically switch hubs on DirChanged event
        port_range = { min = 40000, max = 41000 }, -- Port range for generating unique workspace ports
        get_port = nil, -- Optional function returning custom port number. Called when generating ports to allow custom port assignment logic
      },

      global_env = {},
      native_servers = {},

      builtin_tools = {
        edit_file = {
          parser = {
            track_issues = true,
            extract_inline_content = true,
          },
          locator = {
            fuzzy_threshold = 0.8,
            enable_fuzzy_matching = true,
          },
          ui = {
            go_to_origin_on_complete = true,
            keybindings = {
              accept = ".",
              reject = ",",
              next = "n",
              prev = "p",
              accept_all = "ga",
              reject_all = "gr",
            },
          },
        },
      },
      ui = {
        window = {
          width = 1, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
          height = 1, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
          align = "center", -- "center", "top-left", "top-right", "bottom-left", "bottom-right", "top", "bottom", "left", "right"
          relative = "editor",
          zindex = 50,
          border = "rounded", -- "none", "single", "double", "rounded", "solid", "shadow"
        },
        wo = { -- window-scoped options (vim.wo)
          winhl = "Normal:MCPHubNormal,FloatBorder:MCPHubBorder",
        },
      },
      json_decode = nil, -- Custom JSON parser function (e.g., require('json5').parse for JSON5 support)
      on_ready = function(hub)
        -- Called when hub is ready
      end,
      on_error = function(err)
        -- Called on errors
      end,
      log = {
        level = vim.log.levels.WARN,
        to_file = false,
        file_path = nil,
        prefix = "MCPHub",
      },
    },
  },
}
