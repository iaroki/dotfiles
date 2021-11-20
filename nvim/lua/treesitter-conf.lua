require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = false,
    disable = {},
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  },
  ensure_installed = {
    "bash",
    "c",
    "cpp",
    "css",
    "dockerfile",
    "go",
    "gomod",
    "hcl",
    "html",
    "java",
    "javascript",
    "json",
    "kotlin",
    "lua",
    "nix",
    "python",
    "rst",
    "ruby",
    "rust",
    "toml",
    "vim",
    "yaml"
  },
}

