return {
  { import = "lazyvim.plugins.extras.lang.docker" },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        dockerls = { mason = not require("util.platform").is_linux_arm64() },
        docker_compose_language_service = { mason = not require("util.platform").is_linux_arm64() },
      },
    },
  },
}
