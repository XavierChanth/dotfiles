return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,
	opts = {
		integrations = {
			aerial = true,
			alpha = true,
			cmp = true,
			dashboard = true,
			flash = true,
			gitsigns = true,
			headlines = true,
			illuminate = true,
			indent_blankline = { enabled = true },
			leap = true,
			lsp_trouble = true,
			mason = true,
			markdown = true,
			mini = true,
			native_lsp = {
				enabled = true,
				underlines = {
					errors = { "undercurl" },
					hints = { "undercurl" },
					warnings = { "undercurl" },
					information = { "undercurl" },
				},
			},
			navic = { enabled = true, custom_bg = "lualine" },
			neotest = true,
			neotree = true,
			noice = true,
			notify = true,
			semantic_tokens = true,
			telescope = true,
			treesitter = true,
			treesitter_context = true,
			which_key = true,
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		init = function()
			vim.g.lualine_laststatus = vim.o.laststatus
			if vim.fn.argc(-1) > 0 then
				-- set an empty statusline till lualine loads
				vim.o.statusline = " "
			else
				-- hide the statusline on the starter page
				vim.o.laststatus = 0
			end
		end,
		opts = function()
			-- PERF: we don't need this lualine require madness 🤷
			local lualine_require = require("lualine_require")
			lualine_require.require = require

			local icons = require("lazyvim.config").icons

			vim.o.laststatus = vim.g.lualine_laststatus

			return {
				options = {
					theme = "auto",
					globalstatus = true,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch" },

					-- TODO: configure lualine

					-- lualine_c = {
					-- 	LazyVim.lualine.root_dir(),
					-- 	{
					-- 		"diagnostics",
					-- 		symbols = {
					-- 			error = icons.diagnostics.Error,
					-- 			warn = icons.diagnostics.Warn,
					-- 			info = icons.diagnostics.Info,
					-- 			hint = icons.diagnostics.Hint,
					-- 		},
					-- 	},
					-- 	{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
					-- 	{ LazyVim.lualine.pretty_path() },
					-- },
					-- lualine_x = {
					--        -- stylua: ignore
					--        {
					--          function() return require("noice").api.status.command.get() end,
					--          cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
					--          color = LazyVim.ui.fg("Statement"),
					--        },
					--        -- stylua: ignore
					--        {
					--          function() return require("noice").api.status.mode.get() end,
					--          cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
					--          color = LazyVim.ui.fg("Constant"),
					--        },
					--        -- stylua: ignore
					--        {
					--          function() return "  " .. require("dap").status() end,
					--          cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
					--          color = LazyVim.ui.fg("Debug"),
					--        },
					-- 	{
					-- 		require("lazy.status").updates,
					-- 		cond = require("lazy.status").has_updates,
					-- 		color = LazyVim.ui.fg("Special"),
					-- 	},
					-- 	{
					-- 		"diff",
					-- 		symbols = {
					-- 			added = icons.git.added,
					-- 			modified = icons.git.modified,
					-- 			removed = icons.git.removed,
					-- 		},
					-- 		source = function()
					-- 			local gitsigns = vim.b.gitsigns_status_dict
					-- 			if gitsigns then
					-- 				return {
					-- 					added = gitsigns.added,
					-- 					modified = gitsigns.changed,
					-- 					removed = gitsigns.removed,
					-- 				}
					-- 			end
					-- 		end,
					-- 	},
					-- },
					lualine_y = {
						{ "progress", separator = " ", padding = { left = 1, right = 0 } },
						{ "location", padding = { left = 0, right = 1 } },
					},
					-- lualine_z = {
					-- 	function()
					-- 		return " " .. os.date("%R")
					-- 	end,
					-- },
				},
				extensions = { "neo-tree", "lazy" },
			}
		end,
	},
}
