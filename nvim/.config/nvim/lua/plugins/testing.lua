return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-go',
    'mrcjkb/rustaceanvim',
    'marilari88/neotest-vitest',
  },
  opts = {},
  config = function()
    require('neotest').setup {
      log_level = vim.log.levels.DEBUG,
      adapters = {
        require 'neotest-go',
        require 'rustaceanvim.neotest',
        require 'neotest-vitest',
      },
      output_panel = {
        enabled = true,
        open = 'botright split | resize 15',
      },
      quickfix = {
        enabled = true,
        open = false,
      },
    }

    vim.keymap.set('n', '<leader>tt', "<cmd>lua require('neotest').run.run()<CR>", { desc = 'Run [T]est' })
    vim.keymap.set('n', '<leader>tf', "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>", { desc = 'Run Test [F]ile' })
    vim.keymap.set('n', '<leader>tp', "<cmd>lua require('neotest').output_panel.toggle()<CR>", { desc = 'Toggle Test [P]anel' })
    vim.keymap.set('n', '<leader>tl', "<cmd>lua require('neotest').run.run_last()<CR>", { desc = 'Run [L]ast test' })
    vim.keymap.set('n', '<leader>ts', "<cmd>lua require('neotest').summary.toggle()<CR>", { desc = 'Toggle Test [S]ummary' })
  end,
}
