return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require'nvim-treesitter.configs'.setup {
      ensure_installed = { "bash", "c", "cmake", "comment",
      "cpp", "css", "diff", "dockerfile", "go", "gomod", "gosum",
      "git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore",
      "hcl", "html", "http", "ini", "javascript", "json", "lua", "make",
      "markdown", "markdown_inline", "nix", "python", "regex", "ruby", "rust",
      "sql", "sxhkdrc", "toml", "tsx", "terraform", "typescript", "vim", "yaml"},
      highlight = {
        enable = true,
        -- disable = { "c", "rust" },
      },
    }
  end
}
