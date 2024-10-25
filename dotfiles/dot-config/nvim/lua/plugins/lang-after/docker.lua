return {
  require("util.lazy").ensure_installed({
    treesitter = { "dockerfile" },
    lint = { "hadolint" },
    lsp = { "dockerls", "docker_compose_language_service" },
  }),
  {
    "nvim-lint",
    opts = {
      linters_by_ft = {
        dockerfile = { "hadolint" },
      },
    },
  },
  {
    "nvim-lspconfig",
    opts = {
      servers = {
        dockerls = {},
        docker_compose_language_service = {},
      },
    },
  },
}
