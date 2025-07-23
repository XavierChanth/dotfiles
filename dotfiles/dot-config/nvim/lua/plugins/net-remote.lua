-- Oil-ssh doesn't work with Windows which is where I want it
-- I don't want to be forced into my editor being run over NTFS
-- Too slow and painful
return {
  "amitds1997/remote-nvim.nvim",
  version = "*", -- Pin to GitHub releases
  cmd = { "RemoteStart", "RemoteStop", "RemoteInfo", "RemoteCleanup", "RemoteConfigDel", "RemoteLog" },
  dependencies = {
    "nvim-lua/plenary.nvim", -- For standard functions
    "MunifTanjim/nui.nvim", -- To build the plugin UI
  },
  config = true,
}
