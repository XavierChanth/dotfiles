M = {}

function M.add(opts)
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	opts = opts or {}
	opts.attach_mappings = function()
		actions.select_default:replace(function(prompt_bufnr, _)
			local selected_entry = action_state.get_selected_entry()
			local current_line = action_state.get_current_line()

			actions.close(prompt_bufnr)

			local branch = selected_entry ~= nil and selected_entry.value or current_line

			if branch == nil then
				return
			end

			local name = branch:gsub("^origin/", "", 1)
			local path = require("util.root").git({ bare = true }) .. "/" .. name

			require("git-worktree").create_worktree(path, name)
		end)

		return true
	end
	require("telescope.builtin").git_branches(opts)
end

function M.telescope()
	require("telescope").extensions.git_worktree.git_worktrees()
end

return M
