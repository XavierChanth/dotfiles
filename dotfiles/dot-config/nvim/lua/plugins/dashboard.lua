return {
  "snacks.nvim",
  opts = {
    dashboard = {
      sections = {
        { section = "header" },
        function()
          local root = Snacks.git.get_root()
          if root then
            return {
              {
                title = "repo: ",
                desc = vim.fs.basename(root),
                icon = " ",
                key = "b",
                action = Util.git.browse,
              },
              {
                desc = "jj term",
                icon = " ",
                action = function()
                  Util.jj.float()
                end,
                key = "j",
              },
              -- {
              --   section = "terminal",
              --   cmd = "jj log -r @ --no-pager",
              --   height = 3,
              --   padding = 1,
              -- },
              {
                desc = "pull requests",
                icon = " ",
                key = "p",
                action = Util.git.prs,
              },
              {
                desc = "issues",
                icon = " ",
                key = "i",
                action = Util.git.issues,
                padding = 1,
              },
            }
          end
        end,
        { title = "session" },
        {
          desc = "restore",
          icon = " ",
          key = "s",
          action = function()
            require("persistence").load()
          end,
        },
        {
          desc = "quit",
          icon = " ",
          key = "q",
          action = ":qa",
          padding = 1,
        },
        { section = "startup" },
      },
      preset = {
        header = Util.logo,
        keys = {},
      },
    },
  },
}
