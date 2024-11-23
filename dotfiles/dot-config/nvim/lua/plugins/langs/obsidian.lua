local path = Util.platform.home .. "/src/xc/notes"
local function is_notes_dir()
  local buf_dir = vim.fs.dirname(vim.fn.expand("%"))
  return Util.root.git({ cwd = buf_dir }) == path
end
return {
  "epwalsh/obsidian.nvim",
  keys = {
    {
      "<leader>nn",
      "<cmd>ObsidianNew<cr>",
      desc = "New Note",
    },
    {
      "<leader>sn",
      "<cmd>ObsidianQuickSwitch<cr>",
      desc = "Search Notes",
    },
  },
  ft = { "markdown" },
  opts = {
    strict = false,
    workspaces = {
      {
        name = "notes",
        path = path,
      },
    },
    mappings = {
      -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
      ["gf"] = {
        action = function()
          if is_notes_dir() then
            return require("obsidian").util.gf_passthrough()
          end
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Smart action depending on context, either follow link or toggle checkbox.
      ["<cr>"] = {
        action = function()
          if is_notes_dir() then
            return require("obsidian").util.smart_action()
          end
        end,
        opts = { buffer = true, expr = true },
      },
    },
    picker = { name = "fzf-lua" },
    templates = { folder = "templates" },
    attachments = { img_folder = "attachments" },
    note_id_func = function(title)
      return title
    end,
    ui = { enable = false },
    note_frontmatter_func = function(note)
      note.metadata = note.metadata or {}
      if note.metadata.atom == nil then
        note.metadata.atom = true
      end

      local atom_index = 0
      for i, tag in pairs(note.tags) do
        if tag == "#atom" then
          atom_index = i
        end
      end

      if atom_index == 0 and note.metadata.atom then
        note.tags[#note.tags + 1] = "#atom"
      end

      if atom_index ~= 0 and not note.metadata.atom then
        note.tags[atom_index] = nil
      end

      local out = { id = note.id, aliases = note.aliases, tags = note.tags }
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end
      return out
    end,
  },
}
