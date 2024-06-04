local path = vim.env.HOME .. "/src/xc/notes"
return {
  {
    "epwalsh/obsidian.nvim",
    keys = {
      {
        "<leader>ro",
        function()
          return require("util.telescope").command.picker({
            theme = "dropdown",
            regex = "^Obsidian",
          })
        end,
        desc = "Obsidian Commands",
      },
    },
    ft = "markdown",
    cond = function()
      return vim.fn.isdirectory(path)
    end,
    opts = {
      workspaces = {
        {
          name = "notes",
          path = path,
        },
      },
      notes_subdir = "01_notes",
      attachments = {
        img_folder = "03_files",
      },
      templates = {
        folder = "04_templates",
      },
      note_id_func = function(title)
        return title
      end,
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
  },
}
