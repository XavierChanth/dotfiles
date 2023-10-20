require('xavierchanth.global');

if vim.g.vscode then
    require("xavierchanth.vscode")
else
    require("xavierchanth.nvim")
end
