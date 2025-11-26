require("oil").setup({
  columns = {
    -- "icon",
    -- "permissions",
    -- "size",
    -- "mtime",
  },
  view_options = {
    show_hidden = true,
    natural_order = true,
    case_insensitive = true,
  },
  cleanup_delay_ms = 1,
  use_default_keymaps = false,
  keymaps = {
    ["<leader>e"] = "actions.close",
    ["<leader>E"] = "actions.close",
    ["q"] = "actions.close",
    ["<backspace>"] = "actions.parent",
    ["<CR>"] = "actions.select",
    ["<leader>."] = function()
      local cwd = require("oil").get_current_dir()
      vim.cmd("cd " .. cwd)
    end,
    ["<leader><CR>"] = {
      callback = function()
        local augroup =
          vim.api.nvim_create_augroup("oil-open-all", { clear = true })
        vim.api.nvim_create_autocmd("QuickFixCmdPost", {
          group = augroup,
          callback = function()
            vim.api.nvim_del_augroup_by_id(augroup)
            local timer = vim.uv.new_timer()
            if timer ~= nil then
              timer:start(
                10,
                0,
                vim.schedule_wrap(function()
                  vim.cmd("cclose")
                  vim.cmd("ldo e %")
                end)
              )
            end
          end,
        })
        require("oil.actions").send_to_loclist.callback()
      end,
    },
    ["<C-r>"] = "actions.refresh",
    ["H"] = "actions.toggle_hidden",
    ["g?"] = "actions.show_help",
    ["gx"] = "actions.open_external",
    ["<C-t>"] = function() -- opens a new tmux window at the current dir
      require("utils.tmux").neww({
        cwd = require("oil").get_current_dir(),
      })
    end,
    ["\\"] = function()
      require("utils.tmux").splitw({
        cwd = require("oil").get_current_dir(),
      })
    end,
    ["-"] = function()
      require("utils.tmux").splitw({
        cwd = require("oil").get_current_dir(),
        vertical = true,
      })
    end,
  },
  float = {
    padding = 8,
  },
})
