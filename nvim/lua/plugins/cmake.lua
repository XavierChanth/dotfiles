return {
  "Civitasv/cmake-tools.nvim",
  lazy = false,
  config = function()
    local cmake_tools = require("cmake-tools")
    local pickers = require("telescope.pickers")
    local commands = {
      {
        id = "cmake-tools-generate",
        label = "Generate",
        command = function()
          cmake_tools.generate({}, nil)
        end,
      },
      {
        id = "cmake-tools-clean",
        label = "Clean",
        command = function()
          cmake_tools.clean({})
        end,
      },
      {
        id = "cmake-tools-build",
        label = "Build",
        command = function()
          cmake_tools.build({}, nil)
        end,
      },
      {
        id = "cmake-tools-quick-build",
        label = "Quick Build",
        command = function()
          cmake_tools.quick_build({}, nil)
        end,
      },
      {
        id = "cmake-tools-install",
        label = "Install",
        command = function()
          cmake_tools.install({})
        end,
      },
      {
        id = "cmake-tools-stop-executor",
        label = "Stop Executor",
        command = function()
          cmake_tools.stop_executor()
        end,
      },
      {
        id = "cmake-tools-stop-runner",
        label = "Stop Runner",
        command = function()
          cmake_tools.stop_runner()
        end,
      },
      {
        id = "cmake-tools-close-executor",
        label = "Close Executor",
        command = function()
          cmake_tools.close_executor()
        end,
      },
      {
        id = "cmake-tools-close-runner",
        label = "Close Runner",
        command = function()
          cmake_tools.close_runner()
        end,
      },
      {
        id = "cmake-tools-open-executor",
        label = "Open Executor",
        command = function()
          cmake_tools.open_executor()
        end,
      },
      {
        id = "cmake-tools-open-runner",
        label = "Open Runner",
        command = function()
          cmake_tools.open_runner()
        end,
      },
      {
        id = "cmake-tools-run",
        label = "Run",
        command = function()
          cmake_tools.run({})
        end,
      },
      {
        id = "cmake-tools-quick-run",
        label = "Quick Run",
        command = function()
          cmake_tools.quick_run({})
        end,
      },
      {
        id = "cmake-tools-launch-args",
        label = "Launch Args",
        command = function()
          cmake_tools.launch_args({})
        end,
      },
      {
        id = "cmake-tools-debug",
        label = "Debug",
        command = function()
          cmake_tools.debug({}, nil)
        end,
      },
      {
        id = "cmake-tools-quick-debug",
        label = "Quick Debug",
        command = function()
          cmake_tools.quick_debug({}, nil)
        end,
      },
      {
        id = "cmake-tools-select-build-type",
        label = "Select Build Type",
        command = function()
          cmake_tools.select_build_type({})
        end,
      },
      {
        id = "cmake-tools-select-kit",
        label = "Select Kit",
        command = function()
          cmake_tools.select_kit({})
        end,
      },
      {
        id = "cmake-tools-select-configure-preset",
        label = "Select Configure Preset",
        command = function()
          cmake_tools.select_configure_preset({})
        end,
      },
      {
        id = "cmake-tools-select-build-target",
        label = "Select Build Target",
        command = function()
          cmake_tools.select_build_target({}, nil)
        end,
      },
      {
        id = "cmake-tools-select-launch-target",
        label = "Select Launch Target",
        command = function()
          cmake_tools.select_launch_target({}, nil)
        end,
      },
      {
        id = "cmake-tools-target-settings",
        label = "Target Settings",
        command = function()
          cmake_tools.target_settings({})
        end,
      },
      {
        id = "cmake-tools-settings",
        label = "Settings",
        command = function()
          cmake_tools.settings()
        end,
      },
      {
        id = "cmake-tools-show-target-files",
        label = "Show Target Files",
        command = function()
          cmake_tools.show_target_files({})
        end,
      },
      {
        id = "cmake-tools-select-cwd",
        label = "Select CWD",
        command = function()
          cmake_tools.select_cwd({})
        end,
      },
      {
        id = "cmake-tools-select-build-dir",
        label = "Select Build Dir",
        command = function()
          cmake_tools.select_build_dir({})
        end,
      },
      {
        id = "cmake-tools-run-test",
        label = "Run Test",
        command = function()
          cmake_tools.run_test({})
        end,
      },
    }
    vim.keymap.set("n", "<leader>rc", function()
      local ft = require("flutter-tools.menu")
      pickers.new(ft.get_config(commands, {}, { title = "CMake commands" }), {}):find()
    end, { desc = "CMake Commands" })
    return {
      cwd = vim.loop.cwd,
      cmake_generate_options = {
        "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON",
      },
      cmake_build_directory = "build",
      cmake_soft_link_compile_commands = false,
    }
  end,
}
