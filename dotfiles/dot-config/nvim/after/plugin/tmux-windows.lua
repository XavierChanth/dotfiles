vim.api.nvim_create_user_command("Oc", function(opts)
  local tmux = require("utils.tmux")
  local cmd = { "opencode"  }

  if #opts.fargs > 0 then
    table.insert(cmd, 1, opts.args)
    table.insert(cmd, 1, "--prompt")
  end

  tmux.splitw({
    cmd = cmd,
  })
end, { nargs = "*" })
