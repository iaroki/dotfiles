require'nvim-treesitter.configs'.setup {
  -- ensure_installed = "maintained",
  ensure_installed = { "bash", "c", "cmake", "comment",
  "cpp", "css", "diff", "dockerfile", "go", "gomod", "gosum",
  "git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore",
  "hcl", "html", "http", "ini", "javascript", "json", "lua", "make",
  "markdown", "markdown_inline", "nix", "python", "regex", "ruby", "rust",
  "sql", "sxhkdrc", "toml", "tsx", "terraform", "typescript", "vim", "yaml"},
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
