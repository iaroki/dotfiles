return {
  "nvim-neo-tree/neo-tree.nvim",
    version = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    opts = {
      close_if_last_window = true,
      window = {
        width = 30,
      }
    }
}
