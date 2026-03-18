local pick_cmp = nil
-- Pick user command with completion!
vim.api.nvim_create_user_command("Pick", function(conf)
  if conf.args ~= "" then
    Snacks.picker[conf.args]()
  else
    Snacks.picker()
  end
end, {
  nargs = "?",
  complete = function()
    if pick_cmp == nil then
      pick_cmp = {}
      for k, _ in pairs(require("snacks.picker.config.sources")) do
        pick_cmp[#pick_cmp + 1] = k
      end
    end
    return pick_cmp
  end,
})
if not require("utils.platform").is_windows() then
  vim.env.SNACKS_GHOSTTY = true
  vim.g.snacks_image = {
    doc = { inline = false },
  }
end

require("snacks").setup({
  dashboard = {
    sections = {
      { section = "header" },
      function()
        local root = Snacks.git.get_root()
        if root then
          return {
            {
              title = "repo: ",
              desc = vim.fs.basename(root),
              icon = " ",
              key = "b",
              action = Snacks.gitbrowse,
            },
            {
              desc = "pull requests",
              icon = " ",
              key = "p",
              action = function()
                vim.fn.jobstart("gh pr list --web", { detach = true })
              end,
            },
            {
              desc = "issues",
              icon = " ",
              key = "i",
              action = function()
                vim.fn.jobstart("gh issues list --web", { detach = true })
              end,
              padding = 1,
            },
          }
        end
      end,
      { title = "session" },
      {
        desc = "restore",
        icon = " ",
        key = "s",
        action = function()
          require("persistence").load()
        end,
      },
      {
        desc = "quit",
        icon = " ",
        key = "q",
        action = ":qa",
        padding = 1,
      },
      -- {
      --   align = "center",
      --   text = function()
      --     local ms =
      --     return {
      --       { "⚡ Neovim loaded in ", hl = "footer" },
      --       { ms .. "ms", hl = "special" },
      --     }
      --   end,
      -- },
    },
    preset = {
      header = require("assets.logo"),
      keys = {},
    },
  },
  matcher = { sort_empty = false },
  picker = {
    main_file = false,
    ui_select = true,
    layout = {
      preset = function()
        return vim.o.columns >= 120 and "default_full" or "vertical_full"
      end,
    },
    layouts = {
      default_full = {
        preset = "default",
        layout = { width = 0.99, height = 0.99 },
      },
      vertical_full = {
        preset = "vertical",
        layout = { width = 0.99, height = 0.99 },
      },
    },
  },
  image = vim.g.snacks_image,
  indent = {
    enabled = true,
    scope = { animate = { easing = "inOutQuad" } },
    chunk = { enabled = true, char = { arrow = "" } },
  },
  quickfile = { enabled = true },
  statuscolumn = { enabled = true },
  zen = {
    toggles = { dim = false, mini_diff_signs = true },
    show = { statusline = true },
  },
})
