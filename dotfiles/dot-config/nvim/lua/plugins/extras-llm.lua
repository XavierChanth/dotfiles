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
}
