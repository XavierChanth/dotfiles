-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

require("which-key").register({
  ["<leader>r"] = { name = "run" },
})

-- Shift + Space = Space in Terminal Mode
map("t", "<S-Space>", "<Space>", { noremap = true })

map("n", "<leader>rf", function()
  require("telescope").extensions.flutter.commands()
end, { desc = "Flutter Commands" })

local cmake_tools = require("cmake-tools")
local pickers = require("telescope.pickers")
local commands = {
  {
    id = "cmake-tools-generate",
    label = "Generate",
    command = cmake_tools.generate,
  },
  {
    id = "cmake-tools-clean",
    label = "Clean",
    command = cmake_tools.clean,
  },
  {
    id = "cmake-tools-build",
    label = "Build",
    command = cmake_tools.build,
  },
  {
    id = "cmake-tools-quick-build",
    label = "Quick Build",
    command = cmake_tools.quick_build,
  },
  {
    id = "cmake-tools-install",
    label = "Install",
    command = cmake_tools.install,
  },
  {
    id = "cmake-tools-stop-executor",
    label = "Stop Executor",
    command = cmake_tools.stop_executor,
  },
  {
    id = "cmake-tools-stop-runner",
    label = "Stop Runner",
    command = cmake_tools.stop_runner,
  },
  {
    id = "cmake-tools-close-executor",
    label = "Close Executor",
    command = cmake_tools.close_executor,
  },
  {
    id = "cmake-tools-close-runner",
    label = "Close Runner",
    command = cmake_tools.close_runner,
  },
  {
    id = "cmake-tools-open-executor",
    label = "Open Executor",
    command = cmake_tools.open_executor,
  },
  {
    id = "cmake-tools-open-runner",
    label = "Open Runner",
    command = cmake_tools.open_runner,
  },
  {
    id = "cmake-tools-run",
    label = "Run",
    command = cmake_tools.run,
  },
  {
    id = "cmake-tools-quick-run",
    label = "Quick Run",
    command = cmake_tools.quick_run,
  },
  {
    id = "cmake-tools-launch-args",
    label = "Launch Args",
    command = cmake_tools.launch_args,
  },
  {
    id = "cmake-tools-debug",
    label = "Debug",
    command = cmake_tools.debug,
  },
  {
    id = "cmake-tools-quick-debug",
    label = "Quick Debug",
    command = cmake_tools.quick_debug,
  },
  {
    id = "cmake-tools-select-build-type",
    label = "Select Build Type",
    command = cmake_tools.select_build_type,
  },
  {
    id = "cmake-tools-select-kit",
    label = "Select Kit",
    command = cmake_tools.select_kit,
  },
  {
    id = "cmake-tools-select-configure-preset",
    label = "Select Configure Preset",
    command = cmake_tools.select_configure_preset,
  },
  {
    id = "cmake-tools-select-build-target",
    label = "Select Build Target",
    command = cmake_tools.select_build_target,
  },
  {
    id = "cmake-tools-select-launch-target",
    label = "Select Launch Target",
    command = cmake_tools.select_launch_target,
  },
  {
    id = "cmake-tools-target-settings",
    label = "Target Settings",
    command = cmake_tools.target_settings,
  },
  {
    id = "cmake-tools-settings",
    label = "Settings",
    command = cmake_tools.settings,
  },
  {
    id = "cmake-tools-show-target-files",
    label = "Show Target Files",
    command = cmake_tools.show_target_files,
  },
  {
    id = "cmake-tools-select-cwd",
    label = "Select CWD",
    command = cmake_tools.select_cwd,
  },
  {
    id = "cmake-tools-select-build-dir",
    label = "Select Build Dir",
    command = cmake_tools.select_build_dir,
  },
  {
    id = "cmake-tools-run-test",
    label = "Run Test",
    command = cmake_tools.run_test,
  },
}
map("n", "<leader>rc", function()
  local ft = require("flutter-tools.menu")
  pickers.new(ft.get_config(commands, {}, { title = "CMake commands" }), {}):find()
end, { desc = "CMake Commands" })
