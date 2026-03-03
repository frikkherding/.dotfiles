return { -- Oil file manager
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      ['H'] = { 'actions.parent', mode = 'n' },
      ['L'] = { 'actions.select', mode = 'n' },
      ['<ESC>'] = { 'actions.close', mode = 'n' },
    },
  },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  lazy = false,
  keys = {
    vim.keymap.set('n', '-', '<CMD>Oil --float<CR>', { desc = 'File Explorer' }),
  },
}
