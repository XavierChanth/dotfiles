return {
  {
    -- Let's see if this thing is actually good or if I still think it's just
    -- a distraction
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    -- add a config function to copilot setup
    opts = {
      suggestions = { enabled = true },
      panel = { enabled = false },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    build = "make tiktoken", -- Only on MacOS or Linux
    keys = {
      {
        "<leader>a",
        "",
        mode = { "n", "v" },
        desc = "+ai",
      },
      {
        "<leader>aa",
        function()
          require("CopilotChat").toggle()
        end,
        mode = { "n", "v" },
        desc = "CopilotChat",
      },
      {
        "<leader>ap",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.fzflua").pick(actions.prompt_actions())
        end,
        desc = "CopilotChat - Prompt actions",
      },
    },
    opts = {
      model = "gpt-4o",
      -- model = "claude-3.5-sonnet",
      auto_insert_mode = true,
      question_header = "  You ",
      answer_header = "  Copilot ",
      window = {
        width = 0.4,
      },
    },
  },
}
