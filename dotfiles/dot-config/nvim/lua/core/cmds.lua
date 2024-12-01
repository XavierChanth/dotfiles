-- Autocmds from LazyVim
-- As well as my autocmds and execcmds
local function setup()
  -- Check if we need to reload the file when it changed
  vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    callback = function()
      if vim.o.buftype ~= "nofile" then
        vim.cmd("checktime")
      end
    end,
  })

  -- Highlight on yank
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      vim.highlight.on_yank()
    end,
  })

  -- resize splits if window got resized
  vim.api.nvim_create_autocmd({ "VimResized" }, {
    callback = function()
      local current_tab = vim.fn.tabpagenr()
      vim.cmd("tabdo wincmd =")
      vim.cmd("tabnext " .. current_tab)
    end,
  })

  -- go to last loc when opening a buffer
  vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function(event)
      local exclude = { "gitcommit" }
      local buf = event.buf
      if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
        return
      end
      vim.b[buf].lazyvim_last_loc = true
      local mark = vim.api.nvim_buf_get_mark(buf, '"')
      local lcount = vim.api.nvim_buf_line_count(buf)
      if mark[1] > 0 and mark[1] <= lcount then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end,
  })

  -- close some filetypes with <q>
  vim.api.nvim_create_autocmd("FileType", {
    pattern = {
      "PlenaryTestPopup",
      "grug-far",
      "help",
      "lspinfo",
      "notify",
      "qf",
      "spectre_panel",
      "startuptime",
      "tsplayground",
      "neotest-output",
      "checkhealth",
      "neotest-summary",
      "neotest-output-panel",
      "dbout",
      "gitsigns-blame",
    },
    callback = function(event)
      vim.bo[event.buf].buflisted = false
      vim.keymap.set("n", "q", "<cmd>close<cr>", {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end,
  })

  -- make it easier to close man-files when opened inline
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "man" },
    callback = function(event)
      vim.bo[event.buf].buflisted = false
    end,
  })

  -- wrap and check for spell in text filetypes
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "text", "plaintex", "typst", "gitcommit", "markdown", "quarto" },
    callback = function()
      vim.opt_local.wrap = true
      vim.opt_local.spell = true
    end,
  })

  -- Fix conceallevel for json files
  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "json", "jsonc", "json5" },
    callback = function()
      vim.opt_local.conceallevel = 0
    end,
  })

  -- Auto create dir when saving a file, in case some intermediate directory does not exist
  vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    callback = function(event)
      if event.match:match("^%w%w+:[\\/][\\/]") then
        return
      end
      local file = vim.uv.fs_realpath(event.match) or event.match
      vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
  })

  vim.filetype.add({
    pattern = {
      [".*"] = {
        function(path, buf)
          return vim.bo[buf]
              and vim.bo[buf].filetype ~= "bigfile"
              and path
              and vim.fn.getfsize(path) > vim.g.bigfile_size
              and "bigfile"
            or nil
        end,
      },
    },
  })

  -- Handle large files
  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "bigfile",
    callback = function(ev)
      vim.b.minianimate_disable = true
      vim.schedule(function()
        vim.bo[ev.buf].syntax = vim.filetype.match({ buf = ev.buf }) or ""
      end)
    end,
  })

  -- Recognize .xaml as xml
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.xaml" },
    command = "setf xml",
  })

  vim.api.nvim_create_user_command("NewNotebook", function(opts)
    Util.ipynb.new_notebook(opts.args)
  end, {
    nargs = 1,
    complete = "file",
  })

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
end

-- Setup immediately if we are entering a file
-- or lazy load it if we are going to the dashboard
if vim.fn.argc(-1) ~= 0 then
  setup()
else
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = setup,
  })
end

return {}
