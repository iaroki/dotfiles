require'nvim-treesitter.configs'.setup {
  -- ensure_installed = "maintained",
  ensure_installed = { "bash", "c", "cmake", "comment",
  "cpp", "css", "dockerfile", "go", "gomod", "hcl", "html",
  "http", "java", "javascript", "json", "kotlin", "lua",
  "make", "markdown", "nix", "python", "ruby", "rust",
  "toml", "tsx", "typescript", "vim", "yaml"},
  sync_install = false,
  -- ignore_install = { "javascript" },

  highlight = {
    enable = true,
    -- disable = { "c", "rust" },

    additional_vim_regex_highlighting = false,
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  }
}
