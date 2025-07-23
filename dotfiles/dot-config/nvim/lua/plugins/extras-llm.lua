return {
  -- {
  --   " NickvanDyke/opencode.nvim",
  --   version = false,
  -- },
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
      -- config
      model = "claude-3.5-sonnet",
      -- auto_insert_mode = true,
      -- style
      question_header = "##   You ",
      answer_header = "##   Copilot ",
      window = {
        layout = "float",
        border = "rounded",
        width = 1,
        height = 1,
      },
      -- maps
      mappings = {
        complete = {
          insert = "<C-n>",
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
