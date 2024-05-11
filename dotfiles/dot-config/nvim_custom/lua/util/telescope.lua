M = {}
M.command = {}
-- Just the command name, nice and clean
function M.command.entry_maker(opts)
	local make_display = function(entry)
		return require("telescope.pickers.entry_display").create({
			separator = "▏",
			items = {
				{ width = 100 },
				{ remaining = true },
			},
		})({
			{ entry.name, "TelescopeResultsIdentifier" },
		})
	end

	return function(entry)
		return require("telescope.make_entry").set_default_entry_mt({
			name = entry.name,
			bang = entry.bang,
			nargs = entry.nargs,
			complete = entry.complete,
			definition = entry.definition,
			--
			value = entry,
			ordinal = entry.name,
			display = make_display,
		}, opts)
	end
end

-- Finder that allows you to specify a regex filter
function M.command.finder(opts)
	local regex = opts.regex or ".*"
	return require("telescope.finders").new_table({
		results = (function()
			local command_iter = vim.api.nvim_get_commands({})
			local commands = {}

			for _, cmd in pairs(command_iter) do
				if cmd.name:find(regex) ~= nil then
					table.insert(commands, cmd)
				end
			end

			local need_buf_command = vim.F.if_nil(opts.show_buf_command, true)

			if need_buf_command then
				local buf_command_iter = vim.api.nvim_buf_get_commands(0, {})
				buf_command_iter[true] = nil -- remove the redundant entry
				for _, cmd in pairs(buf_command_iter) do
					if cmd.name:find(regex) ~= nil then
						table.insert(commands, cmd)
					end
				end
			end
			return commands
		end)(),
		entry_maker = opts.entry_maker or M.command.entry_maker(opts),
	})
end

-- Picker that allows you to specify a regex filter
function M.command.picker(opts)
	require("telescope.builtin")["commands"]({
		finder = M.command.finder(opts),
		theme = "dropdown",
	})
end

function M.builtin(builtin, opts)
	return require("telescope.builtin")[builtin](opts)
end

function M.git_files(opts)
	if opts.cwd == nil then
		opts.cwd = require("util.root").git()
	end
	return pcall(M.builtin("git_files", opts)) or M.find_files(opts)
end

function M.find_files(opts)
	return M.builtin("find_files", opts)
end

function M.config()
	return M.git_files({
		cwd = vim.fn.expand("$HOME/.dotfiles"),
		show_untracked = true,
		git_command = { "/bin/zsh", "-c", "git ls-files --exclude-standard --cached" },
	})
end

M.defaults = {
	mappings = {
		n = {
			["o"] = require("telescope.actions.layout").toggle_preview,
		},
		i = {
			["<C-o>"] = require("telescope.actions.layout").toggle_preview,
		},
	},
	results_title = false,
	sorting_strategy = "ascending",
	layout_strategy = "flex",
	layout_config = {
		anchor = "top",
		prompt_position = "top",
	},
}

return M
