vim.cmd("colorscheme kanagawa")
--require("gruvbox").setup({
  --undercurl = true,
  --underline = true,
  --bold = true,
  --italic = true,
  --strikethrough = true,
  --invert_selection = false,
  --invert_signs = false,
  --invert_tabline = false,
  --invert_intend_guides = false,
  --inverse = true, -- invert background for search, diffs, statuslines and errors
  --contrast = "", -- can be "hard", "soft" or empty string
  --overrides = {},
--})
--vim.cmd("colorscheme gruvbox")
vim.cmd(string.format("hi %s ctermbg=NONE guibg=NONE", 'Normal'))
