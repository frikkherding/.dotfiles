return { -- Database management plugins
  {
    'tpope/vim-dadbod',
    'kristijanhusak/vim-dadbod-ui',
    {
      'kristijanhusak/vim-dadbod-completion',
      lazy = true,
      opts = {
        keys = {
          vim.keymap.set('n', '<leader>D', '<CMD>DBUIToggle<CR>', { desc = 'Toggle DB Mgmt' }),
        },
      },
    },
  },
}
