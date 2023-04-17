return {
  "cappyzawa/trim.nvim",
  opts = {
    ft_blocklist = {"markdown"},

    -- ignore space of top
    patterns = {
      [[%s/\s\+$//e]],
      [[%s/\($\n\s*\)\+\%$//]],
      [[%s/\(\n\n\)\n\+/\1/]],
    }
  }
}
