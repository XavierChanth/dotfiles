local function get_client(bufnr)
	return vim.lsp.get_clients({ bufnr = bufnr, name = "clangd" })[1]
end

local function switch_source_header(bufnr)
	local method_name = "textDocument/switchSourceHeader"
	bufnr = (bufnr == 0 and vim.api.nvim_get_current_buf()) or bufnr
	local client = get_client(bufnr)

	if not client then
		return vim.notify(
			("method %s is not supported by any servers active on the current buffer"):format(method_name)
		)
	end
	local params = vim.lsp.util.make_text_document_params(bufnr)
	client:request(method_name, params, function(err, result)
		if err then
			error(tostring(err))
		end
		if not result then
			vim.notify("corresponding file cannot be determined")
			return
		end
		vim.cmd.edit(vim.uri_to_fname(result))
	end, bufnr)
end

local function symbol_info()
	local bufnr = vim.api.nvim_get_current_buf()
	local clangd_client = get_client(bufnr)

	if not clangd_client or not clangd_client:supports_method("textDocument/symbolInfo") then
		return vim.notify("Clangd client not found", vim.log.levels.ERROR)
	end
	local win = vim.api.nvim_get_current_win()
	local params = vim.lsp.util.make_position_params(win, clangd_client.offset_encoding)
	clangd_client:request("textDocument/symbolInfo", params, function(err, res)
		if err or #res == 0 then
			-- Clangd always returns an error, there is not reason to parse it
			return
		end
		local container = string.format("container: %s", res[1].containerName) ---@type string
		local name = string.format("name: %s", res[1].name) ---@type string
		vim.lsp.util.open_floating_preview({ name, container }, "", {
			height = 2,
			width = math.max(string.len(name), string.len(container)),
			focusable = false,
			focus = false,
			border = "rounded",
			title = "Symbol Info",
		})
	end, bufnr)
end
return {
	cmd = {
		"clangd",
		"--query-driver=/usr/bin/clang++",
		"--background-index",
		"--clang-tidy",
		"--header-insertion=iwyu",
		"--completion-style=detailed",
		"--function-arg-placeholders",
		"--fallback-style=llvm",
		"--enable-config",
	},
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto", "cc" },
	root_markers = {
		"compile_commands.json",
	},
	capabilities = {
		textDocument = {
			completion = {
				editsNearCursor = true,
			},
		},
		offsetEncoding = { "utf-16" },
	},
	init_options = {
		usePlaceholders = true,
		completeUnimported = true,
		clangdFileStatus = true,
	},
	single_file_support = true,
	on_attach = function(_, buf)
		vim.keymap.set("n", "<leader>ch", function()
			switch_source_header(buf)
		end, { buffer = buf, desc = "Switch Source/Header (C/C++)" })
		vim.keymap.set("n", "<leader>cw", function()
			local filename = vim.fn.expand("%")
			filename = filename:match("^.*/(.*/.*)$")
			filename = filename:gsub("[-./]", "_")
			filename = filename:upper()
			-- top of file
			vim.cmd.norm("ggO#ifndef " .. filename)
			vim.cmd.norm("o#define " .. filename)
			vim.cmd.norm("o#ifdef __cplusplus")
			vim.cmd.norm('oextern "C" {')
			vim.cmd.norm("o#endif")
			vim.cmd.norm("o")
			-- bottom of file
			vim.cmd.norm("Go")
			vim.cmd.norm("o#ifdef __cplusplus")
			vim.cmd.norm("o}")
			vim.cmd.norm("o#endif")
			vim.cmd.norm("o#endif")
		end, { buffer = buf, desc = "Wrap C headers" })
	end,
}
