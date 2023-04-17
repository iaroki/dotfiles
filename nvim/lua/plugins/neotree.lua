return {
  "nvim-neo-tree/neo-tree.nvim",
    version = "v2.x",
    dependencies = { 
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = "NeoTreeFocusToggle",
    opts = {
      close_if_last_window = true,
      window = {
        width = 30,
      }
    }
}
