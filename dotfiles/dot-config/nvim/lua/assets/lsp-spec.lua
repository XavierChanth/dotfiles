-- Lsps that will be enabled
return {
  -- Dart
  "dartls",

  -- Markup
  "jsonls",
  "yamlls",
  "tinymist",

  -- Based languages
  "gopls",
  "lua_ls",
  "basedpyright",
  "ruff",

  -- C ABIs
  "clangd",
  "neocmake",
  -- "asm_lsp",
  "zls",
  "rust_analyzer",

  -- Docker
  "docker_compose_language_service",
  "docker_ls",

  -- Poisoned by their OS
  -- "csharp_ls",
  -- "omnisharp",
  --"sourcekit",  -- Swift

  -- Ruby
  -- "rubocop",
  -- "rubyls",

  -- Web
  "svelte",
  "tailwindcss",
  "vtsls",
}
