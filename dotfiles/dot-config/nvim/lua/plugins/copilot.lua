return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    build = "make tiktoken", -- Only on MacOS or Linux
    init = function()
      vim.treesitter.language.register("markdown", "copilot-chat")
    end,
    dependencies = {
      { "github/copilot.vim", cmd = "Copilot" },
    },
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
        submit_prompt = {
          insert = "<C-CR>",
        },
      },
    },
    keys = {
      {
        "<leader>a",
        function()
          local mode = vim.api.nvim_get_mode().mode
          local input = vim.fn.input("Ask Copilot: ")

          if input == "" then
            require("CopilotChat").open()
            return
          end
          require("CopilotChat").ask(input, {
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
        desc = "Copilot - Quick Chat",
      },
    },
  },
}
