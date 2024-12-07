---@class util.jj
local M = {}

local lines_cache = nil

-- A float which puts JJ log on the left
-- and a terminal in vim cwd on the right
function M.float()
  -- Setup popups and layout
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

  -- Setup log timer
  local timer = vim.uv.new_timer()
  local close = function()
    lines_cache = nil
    timer:stop()
    layout:unmount()
  end

  -- Handle popup closure
  for _, popup in pairs(popups) do
    popup:on("BufLeave", function()
      vim.schedule(function()
        local curr_bufnr = vim.api.nvim_get_current_buf()
        for _, p in pairs(popups) do
          if p.bufnr == curr_bufnr then
            return
          end
        end
        close()
      end)
    end)
  end
  layout:mount()

  -- Setup log
  local refresh_log = function()
    require("plenary.job")
      :new({
        command = "jj",
        args = {
          "log",
          "--color=always",
          "--config-toml",
          "[template-aliases]\n'format_timestamp(timestamp)'='timestamp.format(\"%H:%M %D\")'",
          "--template",
          "narrow_log_comfortable", -- This template can be found in my jj config: dotfiles/dot-config/jj/config.toml
        },
        enabled_recording = true,
      })
      :after(function(job)
        vim.schedule(function()
          if popups.a.bufnr and vim.api.nvim_buf_is_valid(popups.a.bufnr) then
            ---@diagnostic disable-next-line: param-type-mismatch
            local lines = job:result() or job:error_result()
            for i, line in ipairs(lines) do
              if not lines_cache or lines_cache[i] ~= line then
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
  timer:start(0, 50, vim.schedule_wrap(refresh_log))

  -- Setup terminal
  local chan = vim.fn.termopen(vim.o.shell, vim.empty_dict())
  -- autocmds must be right after termopen or they won't work
  vim.api.nvim_create_autocmd("TermClose", {
    once = true,
    buffer = popups.b.bufnr,
    callback = close,
  })
  vim.api.nvim_create_autocmd("BufEnter", {
    buffer = popups.b.bufnr,
    callback = vim.cmd.startinsert,
  })
  -- Then start insert mode in the terminal
  vim.cmd.startinsert()

  -- Useful keybinds
  vim.keymap.set("t", "<CR>", function()
    refresh_log()
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
