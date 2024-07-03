return {
  "akinsho/toggleterm.nvim",
  lazy = false,
  cmd = "ToggleTerm",
  opts = {
    size = 15,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    persist_size = true,
    persist_mode = true,
    direction = 'horizontal',
    close_on_exit = true,
    float_opts = {
      border = 'curved',
    },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

-- Vifm setup

local Terminal  = require('toggleterm.terminal').Terminal
local Path = require 'plenary.path'
local path = vim.fn.tempname()

local Vifm = Terminal:new {
  cmd = ('vifm --choose-files "%s"'):format(path),
  direction = "float",
  close_on_exit = true,
  on_close = function()
    data = Path:new(path):read()
    vim.schedule(function()
      vim.cmd('e ' .. data)
    end)
  end
}

function _vifm_toggle()
  Vifm:toggle()
end

vim.api.nvim_set_keymap("n", "<leader>vf", "<cmd>lua _vifm_toggle()<CR>", {noremap = true, silent = true})

-- Lazygit setup

local Lazygit = Terminal:new {
  cmd = "lazygit",
  direction = "float",
  close_on_exit = true,
}

function _lazygit_toggle()
  Lazygit:toggle()
end

vim.api.nvim_set_keymap("n", "<leader>lg", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})
--------------------------------------------------------

  end,
}
