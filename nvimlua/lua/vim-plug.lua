local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

Plug ('neoclide/coc.nvim', {branch= 'release'})

vim.call('plug#end')
