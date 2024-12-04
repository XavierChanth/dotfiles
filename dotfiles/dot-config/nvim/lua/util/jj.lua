---@class util.jj
local M = {}

local lines_cache = {}

function M.float()
  local Popup = require("nui.popup")
  local Layout = require("nui.layout")
  local popups = {
    a = Popup({ border = "rounded", win_options = { wrap = false } }),
    b = Popup({ border = "rounded", enter = true }),
  }

  local layout = Layout(
    {
      relative = "editor",
      position = "50%",
      size = "90%",
    },
    Layout.Box({
      Layout.Box(popups.a, { size = 45 }),
      Layout.Box(popups.b, { grow = 1 }),
    }, { dir = "row" })
  )

  for _, popup in pairs(popups) do
    popup:on("BufLeave", function()
      vim.schedule(function()
        local curr_bufnr = vim.api.nvim_get_current_buf()
        for _, p in pairs(popups) do
          if p.bufnr == curr_bufnr then
            return
          end
        end
        layout:unmount()
      end)
    end)
  end

  layout:mount()

  -- Setup popup a
  -- vim.api.nvim_set_option_value("wrap", false, { buf = popups.a.bufnr })
  local refresh_log = function()
    require("plenary.job")
      :new({
        command = "jj",
        -- args = { "config", "p", "--user" },
        args = {
          "log",
          "--color=always",
          "--config-toml",
          "'template-aliases.format_timestamp(timestamp)' = 'timestamp'",
          "--template",
          "narrow_log_comfortable",
        },
        enabled_recording = true,
      })
      :after(function(job)
        vim.schedule(function()
          if popups.a.bufnr and vim.api.nvim_buf_is_valid(popups.a.bufnr) then
            ---@diagnostic disable-next-line: param-type-mismatch
            local lines = job:result() or job:error_result()
            for i, line in ipairs(lines) do
              if lines_cache[i] ~= line then
                lines_cache = lines
                Util.ansi_colors.baleia().buf_set_lines(popups.a.bufnr, 0, -1, false, lines)
                return
              end
            end
          end
        end)
      end)
      :start()
  end
  refresh_log()

  local chan = vim.fn.termopen(vim.o.shell, vim.empty_dict())
  vim.api.nvim_create_autocmd("TermClose", {
    once = true,
    buffer = popups.b.bufnr,
    callback = function()
      layout:unmount()
      vim.cmd.checktime()
    end,
  })
  vim.api.nvim_create_autocmd("BufEnter", {
    buffer = popups.b.bufnr,
    callback = function()
      vim.cmd.startinsert()
    end,
  })
  vim.cmd.startinsert()

  vim.keymap.set("t", "<CR>", function()
    vim.fn.timer_start(50, vim.schedule(refresh_log), vim.empty_dict())
    vim.api.nvim_chan_send(chan, "\x0D")
  end, { buffer = popups.b.bufnr })

  vim.keymap.set("t", "<C-h>", function()
    vim.api.nvim_set_current_win(popups.a.winid)
  end, { buffer = popups.b.bufnr })

  vim.keymap.set("n", "<C-l>", function()
    vim.api.nvim_set_current_win(popups.b.winid)
  end, { buffer = popups.a.bufnr })
end

return M
