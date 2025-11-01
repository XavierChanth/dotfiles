local M = {}

-- Platform based information
M.home = os.getenv("HOME")
M.is_gui = vim.g.vscode
M.supports_terminal = not vim.g.vscode

local is_windows = nil
function M.is_windows()
	if is_windows == nil then
		is_windows = vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 or vim.fn.has("win16") == 1
	end
	return is_windows
end

return M
