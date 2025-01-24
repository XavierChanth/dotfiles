return {
  Util.packages.ensure_installed({
    treesitter = { "c", "cpp" },
    mason = { "gersemi", "clangd", "neocmake" },
  }),
  {
    "conform.nvim",
    opts = {
      formatters_by_ft = {
        cmake = { "gersemi" },
      },
      formatters = {
        gersemi = { prepend_args = { "--indent", "2" } }, -- cmake formatter
      },
    },
  },
  {
    "nvim-lspconfig",
    opts = {
      servers = {
        neocmake = {},
        clangd = {
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern(
              "Makefile",
              "configure.ac",
              "configure.in",
              "config.h.in",
              "meson.build",
              "meson_options.txt",
              "build.ninja"
            )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
              fname
            ) or Snacks.git.get_root(fname)
          end,
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
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
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
      },
      attach_server = {
        clangd = function(_, event)
          vim.keymap.set(
            "n",
            "<leader>ch",
            "<cmd>ClangdSwitchSourceHeader<cr>",
            { buffer = event.buf, desc = "Switch Source/Header (C/C++)" }
          )
        end,
      },
    },
  },
}
