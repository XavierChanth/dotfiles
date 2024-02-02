return {
  "Civitasv/cmake-tools.nvim",
  lazy = false,
  config = {
    cwd = vim.loop.cwd,
    cmake_generate_options = {
      "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON",
    },
    cmake_build_directory = "build",
    cmake_soft_link_compile_commands = false,
  },
}
