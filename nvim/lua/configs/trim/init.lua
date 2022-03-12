require('trim').setup({
    disable = {"markdown"},

    -- ignore space of top
    patterns = {
      [[%s/\s\+$//e]],
      [[%s/\($\n\s*\)\+\%$//]],
      [[%s/\(\n\n\)\n\+/\1/]],
    },
  })
