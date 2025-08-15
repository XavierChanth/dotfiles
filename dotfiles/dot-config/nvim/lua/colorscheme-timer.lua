-- A wrapper which reloads the colorscheme based on the contents of the file
-- stored in $HOME/.local/state/colorscheme/colorscheme.lua
package.path = require("platform").home .. "/.local/state/colorscheme/?.lua;" .. package.path

local M = {}

local timer = vim.uv.new_timer()

local function try_switch()
	package.loaded["colorscheme"] = nil
	local theme = require("colorscheme")
	if theme ~= vim.g.colors_name then
		vim.cmd.colorscheme(theme)
	end
end

function M.get()
	return require("colorscheme")
end

function M.start(time)
	if timer ~= nil then
		timer:start(0, time, vim.schedule_wrap(try_switch))
	end
end

return M
