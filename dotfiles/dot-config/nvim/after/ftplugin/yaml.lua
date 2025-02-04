-- Do a pub get after writing pubspec files
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "pubspec.yaml",
  callback = vim.schedule_wrap(function(ev)
    local Job = require("plenary.job")
    local file = vim.api.nvim_buf_get_name(ev.buf)
    local dir = vim.fs.dirname(file)

    Job:new({
      command = "flutter",
      args = { "pub", "get" },
      cwd = dir,
      enabled_recording = false,
      on_exit = function(_, code)
        local level = vim.log.levels.WARN
        local message = "pub get failed"
        if code == 0 then
          level = vim.log.levels.INFO
          message = "pub get succeeded"
        end
        vim.notify(message, level)
      end,
    }):start()
  end),
})
