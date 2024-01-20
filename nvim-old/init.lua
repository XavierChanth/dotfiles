if vim.g.vscode then
    require('xavierchanth.global');
    require("xavierchanth.vscode")
else
    require('xavierchanth.global');
    require('xavierchanth')
end
