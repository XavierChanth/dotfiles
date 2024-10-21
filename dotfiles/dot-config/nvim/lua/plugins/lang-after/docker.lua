return {
  {
    "nvim-treesitter",
    opts = { ensure_installed = { "dockerfile" } },
  },
  {
    "mason.nvim",
    opts = { ensure_installed = { "hadolint" } },
  },
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
        dockerls = { mason = not require("util.platform").is_linux_arm64() },
        docker_compose_language_service = { mason = not require("util.platform").is_linux_arm64() },
      },
    },
  },
}
