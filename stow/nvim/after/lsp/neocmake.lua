return {
  cmd = { "neocmakelsp", "--stdio" },
  filetypes = { "cmake" },
  root_markers = {
    "cmake",
    "build",
    ".git",
  },
  single_file_support = true,
}
