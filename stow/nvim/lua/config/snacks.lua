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
