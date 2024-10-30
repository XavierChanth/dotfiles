if not vim.g.vscode then
  return {}
end

-- Manual Installation Steps
-- I don't use vscode enough to make this worth automating
--
-- VSCode extensions to install:
--
-- VSCode Neovim   - asvetliakov.vscode-neovim
-- Error Lens      - usernamehw.errorlens
-- Trailing Spaces - shardulm94.trailing-spaces
--
-- Keymaps to add
-- Ctrl+- Terminal: Focus Terminal [when: !view.terminal.visible]
-- Ctrl+- View: Hide Panel [when: view.terminal.visible]

-- Cmd+w  View: Hide Panel  [when: panelFocus]
-- Cmd+w  View: Toggle Primary Side Bar Visibility  [when: sideBarFocus]

local vscode = require("vscode")

-- Neovim settings
vim.g.clipboard = vim.g.vscode_clipboard
vim.notify = vscode.notify

-- VSCode settings
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    for key, value in pairs(Util.vscode.settings) do
      if vscode.has_config(key) then
        local current = vscode.get_config(key)
        if (type(value) ~= "string" or #value ~= #current) and value ~= current then
          vscode.update_config(key, value, "global")
        end
      else
        vscode.update_config(key, value, "global")
      end
    end
  end,
})

-- Keymaps
vim.api.nvim_create_autocmd("BufEnter", {
  once = true,
  callback = function()
    for _, map in ipairs(Util.vscode.keymaps) do
      vim.keymap.set(map.mode or "n", map[1], map[2], { desc = map.desc })
    end
  end,
})

return {}
