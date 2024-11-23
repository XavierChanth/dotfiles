return {
  {
    "jiaoshijie/undotree",
    opts = {
      ignore_filetype = { "undotree", "undotreeDiff", "qf", "dashboard" },
    },
    keys = {
      {
        "<leader>uh",
        function()
          require("undotree").toggle()
        end,
        desc = "Undo history",
      },
    },
  },
}
