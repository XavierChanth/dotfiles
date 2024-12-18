return {
  Util.packages.ensure_installed({
    treesitter = { "dockerfile" },
    mason = { "hadolint", "dockerls", "docker_compose_language_service" },
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
