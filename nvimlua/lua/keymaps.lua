-- Aliases

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Keymaps
--
-- exit insermode
map('i', 'jj', '<ESC>')
map('i', 'JJ', '<ESC>')
map('i', 'kk', '<ESC>')
map('i', 'KK', '<ESC>')
map('i', 'yy', '<ESC>')
-- exit and save
map('n', '<Leader>w', ':w<CR>')
map('n', '<Leader>q', ':q<CR>')
-- keep it centreded
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')
map('n', '<C-J>', 'mzJ`z')
-- faster scrolling
map("n", "K", "3<C-y>")
map("n", "J", "3<C-e>")
-- ident
map('v', '<', '<gv', {noremap=false})
map('v', '>', '>gv', {noremap=false})
-- ; fast
map('n', '<Leader>,', '$a;<ESC>')
map('n', '<Leader>-', '$a,<ESC>')
-- Clear search highlighting with <leader> and c
map('n', '<leader>c', ':nohl<CR>')

-- fzf
map('n', '<leader>p', ':Telescope find_files<CR>')
map('n', '<leader>t', ':Telescope live_grep<CR>')
map('n', '<leader>ob', ':Telescope buffers<CR>')

-- nvim tree
map('n', '<leader>nt', ':NvimTreeToggle<CR>')

