return {
	{
		"stevearc/oil.nvim",
		keys = {
			{
				"<leader>e",
				function()
					require("oil").open()
				end,
				desc = "Oil",
			},
			{
				"<leader>E",
				function()
					require("oil").open(require("util.root").git())
				end,
				desc = "Oil (root dir)",
			},
		},
		opts = {
			columns = {
				"icon",
				-- "permissions",
				-- "size",
				-- "mtime",
			},
			view_options = {
				show_hidden = true,
			},
			use_default_keymaps = false,
			keymaps = {
				["<leader>e"] = "actions.close",
				["<leader>E"] = "actions.close",
				["q"] = "actions.close",
				["<C-c>"] = "actions.close",
				["<backspace>"] = "actions.parent",
				["<CR>"] = "actions.select",
				["<C-l>"] = "actions.refresh",
				["H"] = "actions.toggle_hidden",
				["g?"] = "actions.show_help",
				["<leader>rs"] = "actions.change_sort",
				["gx"] = "actions.open_external",
			},
			float = {
				padding = 8,
			},
		},
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		opts = {
			menu = {
				width = vim.api.nvim_win_get_width(0) - 4,
			},
			settings = {
				save_on_toggle = true,
			},
		},
		keys = function()
			local keys = {
				{
					"<leader>H",
					function()
						require("harpoon"):list():add()
					end,
					desc = "Harpoon File",
				},
				{
					"<leader>h",
					function()
						local harpoon = require("harpoon")
						harpoon.ui:toggle_quick_menu(harpoon:list())
					end,
					desc = "Harpoon Quick Menu",
				},
			}

			for i = 1, 5 do
				table.insert(keys, {
					"<leader>" .. i,
					function()
						require("harpoon"):list():select(i)
					end,
					desc = "Harpoon to File " .. i,
				})
			end
			return keys
		end,
	},
}
