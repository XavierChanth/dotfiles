return {
  {
    "epwalsh/obsidian.nvim",
    keys = {
      {
        "<leader>ro",
        function()
          return require("util.telescope").command_picker({
            theme = "dropdown",
            regex = "^Obsidian",
          })
        end,
        desc = "Obsidian Commands",
      },
    },
    ft = "markdown",
    opts = {
      workspaces = {
        {
          name = "notes",
          path = "~/src/xc/notes",
        },
      },
      -- TODO: configure this later
      -- https://github.com/epwalsh/obsidian.nvim
      -- see below for full list of options 👇
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
        note.tags[#note.tags + 1] = "#atom"
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
