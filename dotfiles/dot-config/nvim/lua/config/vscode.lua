if not vim.g.vscode then
  return {}
end


-- Manual Installation Steps
-- I don't use vscode enough to make this worth automating
--
-- VSCode extensions to install:
--
-- VSCode Neovim   - asvetliakov.vscode-neovim
-- Auto Hide -VIM  - Vitchu.vscode-autohide-vim
-- Error Lens      - usernamehw.errorlens
-- Trailing Spaces - shardulm94.trailing-spaces
--
-- Keymaps to add
-- Ctrl+- Terminal: Focus Terminal [when: !view.terminal.visible]
-- Ctrl+- View: Hide Panel [when: view.terminal.visible]
-- Cmd+w  View: Hide Panel  [when: panelFocus]
-- Cmd+w  View: Toggle Primary Side Bar Visibility  [when: sideBarFocus]

local vscode = require("vscode")
local map = vim.keymap.set

-- Neovim settings
vim.g.clipboard = vim.g.vscode_clipboard
vim.notify = vscode.notify

-- VSCode settings
local global_settings = {
  ["editor.autoClosingBrackets"] = "never",
  ["editor.autoClosingComments"] = "never",
  ["editor.autoClosingDelete"] = "never",
  ["editor.autoClosingOvertype"] = "never",
  ["editor.autoClosingQuotes"] = "never",
  ["files.autoSave"] = "afterDelay",
  ["files.autoSaveDelay"] = 500,
  ["editor.accessibilitySupport"] = "off",
  ["editor.fontSize"] = 14,
  ["editor.fontFamily"] = "'JetBrainsMono Nerd Font'",
  ["editor.fontLigatures"] = true,
  ["editor.formatOnSave"] = true,
  ["editor.glyphMargin"] = false,
  ["editor.guides.bracketPairs"] = true,
  ["editor.guides.bracketPairsHorizontal"] = true,
  ["editor.guides.highlightActiveIndentation"] = true,
  ["editor.lineNumbers"] = "relative",
  ["editor.minimap.enabled"] = false,
  ["editor.renderWhitespace"] = "all",
  ["editor.tabSize"] = 2,
  ["explorer.compactFolders"] = false,
  ["explorer.confirmDelete"] = false,
  ["explorer.confirmDragAndDrop"] = false,
  ["git.confirmSync"] = false,
  ["git.enableCommitSigning"] = true,
  ["git.inputValidationLength"] = 1000,
  ["git.inputValidationSubjectLength"] = 100,
  ["git.openDiffOnClick"] = false,
  ["git.openRepositoryInParentFolders"] = "always",
  ["git.suggestSmartCommit"] = false,
  ["scm.defaultViewMode"] = "tree",
  ["scm.diffDecorationsIgnoreTrimWhitespace"] = "true", --Vscode wants a string for this one
  ["telemetry.telemetryLevel"] = "off",
  ["terminal.integrated.fontFamily"] = "'JetBrainsMono Nerd Font'",
  ["window.title"] = "${rootName}",
  ["workbench.activityBar.location"] = "top",
  ["workbench.editor.editorActionsLocation"] = "titleBar",
  ["workbench.editor.showTabs"] = "single",
  ["workbench.panel.opensMaximized"] = "always",
  ["workbench.sideBar.location"] = "right",
  ["workbench.startupEditor"] = "readme",
  ["workbench.panel.defaultLocation"] = "left",
  ["workbench.layoutControl.enabled"] = false,
  ["workbench.tree.indent"] = 12,
  ["workbench.tree.renderIndentGuides"] = "always",
  ["vscode-neovim.statusLineSeparator"] = " | ",
  -- Tables don't work ["editor.rulers"] = { 80, 120 },
  -- ["extensions.experimental.affinity"] = {
  --   ["asvetliakov.vscode-neovim"] = 1,
  --, },
}

for key, value in pairs(global_settings) do
  if vscode.has_config(key) then
    local current = vscode.get_config(key)
    if (type(value) ~= "string" or #value ~= #current) and value ~= current then
      vscode.update_config(key, value, "global")
    end
  else
    vscode.update_config(key, value, "global")
  end
end

-- Neovim Keymaps
map("n", "<leader>qq", function()
  vscode.action("workbench.action.closeWindow")
end);

-- Search and replace
map("n", "<leader>sg", function()
  vscode.action("workbench.action.findInFiles")
end)
map("n", "<leader>sr", function()
  vscode.action("workbench.action.replaceInFiles")
end)

-- Views
map("n", "<leader>e", function()
  vscode.action("workbench.view.explorer")
end)
map("n", "<leader>xx", function()
  vscode.action("workbench.actions.view.problems")
end)
map("n", "<leader>gg", function()
  vscode.action("workbench.view.scm")
end)
map("n", "<leader>du", function()
  vscode.action("workbench.view.debug")
  vscode.action("workbench.debug.action.toggleRepl")
end)

-- Telescope Muscle memory
map("n", "<leader>j", function()
  vscode.action("workbench.action.quickOpen")
end)

-- Buffers/Tabs
map("n", "<leader>bd", function()
  vscode.action("workbench.action.closeActiveEditor")
end)
map("n", "<leader>bo", function()
  vscode.action("workbench.action.closeOtherEditors")
end)

-- Resets
map("n", "<leader>\\", function()
  vscode.action("workbench.action.splitEditor")
end)

return {}
