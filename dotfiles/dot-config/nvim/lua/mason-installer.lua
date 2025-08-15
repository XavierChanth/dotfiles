local M = {}

function M.install_packages(packages)
	vim.api.nvim_create_autocmd("User", {
		pattern = "VeryLazy",
		callback = function()
			local ok, reg = pcall(require, "mason-registry")
			if ok then
				for _, id in ipairs(packages) do
					local ok2, package = pcall(reg.get_package, id)
					if ok2 then
						local ok3, installed = pcall(package.is_installed, package)
						if ok3 and not installed then
							print("ok3 and not installed")
							pcall(package.install, package)
						end
					end
				end
			end
		end,
	})
end

return M
