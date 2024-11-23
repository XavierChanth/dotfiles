local normal_mode = {
  fzf = {
    j = "down",
    k = "up",
    -- if you chose to enter insert mode, you can't go back
    i = "enable-search+unbind(j)+unbind(k)+unbind(i)+unbind(a)",
    a = "enable-search+unbind(j)+unbind(k)+unbind(i)+unbind(a)",
  },
}
return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  opts = {
    -- "fzf-tmux", -- has an initial overhead which doesn't feel great
    winopts = {
      width = 0.85,
      height = 0.85,
      preview = {
        layout = "flex",
        default = "bat",
        wrap = "wrap",
      },
    },
    keymap = {
      fzf = {
        ["ctrl-d"] = "preview-page-down",
        ["ctrl-u"] = "preview-page-up",
        ["ctrl-o"] = "toggle-preview",
      },
    },
    lsp = { jump_to_single_result = true },
    grep = {
      actions = {
        ["ctrl-q"] = {
          function(...)
            require("fzf-lua.actions").file_edit_or_qf(...)
          end,
        },
      },
    },
    fzf_tmux_opts = { ["-p"] = "85%,85%", ["--margin"] = "0,0" },
  },
  keys = {
    {
      "<leader><space>",
      function()
        if Util.worktree.is_inside(Util.root.cwd()) then
          require("fzf-lua").git_files({
            cmd = "git ls-files --others --cached --exclude-standard",
            git_icons = false,
          })
        else
          require("fzf-lua").files({})
        end
      end,
      desc = "Git files",
    },
    {
      "<leader>sf",
      function()
        require("fzf-lua").files({})
      end,
      desc = "Find files",
    },
    {
      "<leader>sb",
      function()
        require("fzf-lua").buffers({})
      end,
      desc = "Buffers",
    },
    {
      "<leader>sh",
      function()
        require("fzf-lua").helptags({})
      end,
      desc = "Help Pages",
    },
    {
      "<leader>sk",
      function()
        require("fzf-lua").keymaps({})
      end,
      desc = "Key Maps",
    },
    {
      "<leader>sm",
      function()
        require("fzf-lua").marks({})
      end,
      desc = "Marks",
    },
    {
      "<leader>sg",
      function()
        require("fzf-lua").live_grep({})
      end,
      desc = "Grep workspace",
    },
    {
      "<leader>sc",
      function()
        require("fzf-lua").live_grep_resume({})
      end,
      desc = "Continue grep workspace",
    },
    {
      "<leader>sG",
      function()
        require("fzf-lua").lgrep_curbuf({})
      end,
      desc = "Grep buffer",
    },
    {
      "<leader>ss",
      function()
        require("fzf-lua").lsp_document_symbols({})
      end,
      desc = "Symbols (Buffer)",
    },
    {
      "<leader>sS",
      function()
        require("fzf-lua").lsp_live_workspace_symbols({})
      end,
      desc = "Symbols (Workspace)",
    },
    {
      "<leader>rr",
      function()
        require("fzf-lua").commands({})
      end,
      desc = "Run commands",
    },
    {
      "<leader>m",
      function()
        local terminals = {}
        for k, _ in pairs(Util.terminal.get_terminals()) do
          table.insert(terminals, tostring(k))
        end
        if #terminals == 0 then
          vim.notify("No opened terminals", vim.log.levels.WARN)
          return
        end

        require("fzf-lua").fzf_exec(terminals, {
          winopts = {
            header = "<ctrl-x> to close",
          },
          actions = {
            enter = function(selected)
              Util.terminal.existing_terminal(selected[1])
              vim.schedule(vim.cmd.startinsert)
            end,
            ["ctrl-x"] = function(selected)
              Util.terminal.remove(selected[1])
            end,
          },
        })
      end,
      desc = "Find terminals",
    },
    {
      "<leader>j",
      function()
        require("fzf-lua").buffers({
          keymap = normal_mode,
        })
      end,
      desc = "Jump to buffer (all)",
    },
  },
}
