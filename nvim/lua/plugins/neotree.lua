return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      mappings = {
        ["w"] = {
          function(state)
            local current_node = state.tree:get_node()
            local path = current_node:get_id()

            -- If you want to set the root as well
            -- require("neo-tree.sources.filesystem.commands").set_root(state)
            vim.cmd("cd " .. path)
            vim.print("cwd: " .. path)
            require("cmake-tools").select_cwd(path)
          end,
          desc = "set working directory",
        },
      },
    },
  },
}
