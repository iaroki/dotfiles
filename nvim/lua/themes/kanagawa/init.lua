local default_colors = require("kanagawa.colors").setup()

local custom_colors = {
    sumiInk1 = "#16161D",
}

require('kanagawa').setup({
    undercurl = true,
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true},
    statementStyle = { bold = true },
    typeStyle = {},
    variablebuiltinStyle = { italic = true},
    specialReturn = true,
    specialException = true,
    transparent = false,
    dimInactive = false,
    globalStatus = false,
    terminalColors = true,
    colors = custom_colors,
    overrides = {},
})

vim.cmd("colorscheme kanagawa")
