require('nvim-treesitter.configs').setup {
   ensure_installed = {
      "lua",
      "javascript",
      "typescript",
      "html",
      "css",
      "vue",
      "svelte"
   },
   highlight = {
      enable = true,
      use_languagetree = true,
   },
}

