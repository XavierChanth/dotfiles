-- Oil-ssh doesn't work with Windows which is where I want it
-- I don't want to be forced into my editor being run over NTFS
-- Too slow and painful
return {
  -- { -- Doesn't even work with windows on the Remote sadly, pretty sure it's a Windows pain
  --   "amitds1997/remote-nvim.nvim",
  --   cmd = { "RemoteStart", "RemoteStop", "RemoteInfo", "RemoteCleanup", "RemoteConfigDel", "RemoteLog" },
  --   dependencies = {
  --     "nvim-lua/plenary.nvim", -- For standard functions
  --     "MunifTanjim/nui.nvim", -- To build the plugin UI
  --   },
  --   config = true,
  -- },
}
