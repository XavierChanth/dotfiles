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
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
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
      Util.clangd.switch_source_header(buf)
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
