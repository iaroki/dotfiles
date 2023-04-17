return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    "HiPhish/nvim-ts-rainbow2",
  },
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
      rainbow = {
        enable = true,
        -- list of languages you want to disable the plugin for
        disable = { 'jsx', },
        -- Which query to use for finding delimiters
        query = 'rainbow-parens',
        -- Highlight the entire buffer all at once
        strategy = require('ts-rainbow').strategy.global,
      },
    }
  end
}
