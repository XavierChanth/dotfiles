local function action(id)
  return function()
    require("vscode").action(id)
  end
end

---@class util.vscode.keymaps
return {
  -- Search and replace
  { "<leader>sg", action("workbench.action.findInFiles") },
  { "<leader>sr", action("workbench.action.replaceInFiles") },
  -- Views
  { "<leader>e", action("workbench.view.explorer") },
  { "<leader>xx", action("workbench.actions.view.problems") },
  { "<leader>gg", action("workbench.view.scm") },

  -- Telescope Replacements
  { "<leader><space>", action("workbench.action.quickOpen") },
  { "<leader>j", action("workbench.action.quickOpen") },

  -- Buffers/Tabs/Windows
  { "<leader>bd", action("workbench.action.closeActiveEditor") },
  { "<leader>bo", action("workbench.action.closeOtherEditors") },
  -- { "<leader>-", action("workbench.action.splitEditor") }, -- TODO
  { "<leader>\\", action("workbench.action.splitEditor") },
  { "<leader>qq", action("workbench.action.closeWindow") },
  -- LSP
  { "<leader>ss", action("workbench.action.gotoSymbol") },
}
