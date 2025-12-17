-- [[Keymaps]]

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Toggle Terminal
vim.keymap.set('n', '<C-t>', ':lua TermToggle(20)<CR>', { noremap = true, silent = true })
vim.keymap.set('t', '<C-t>', '<C-\\><C-n>:lua TermToggle(20)<CR>', { noremap = true, silent = true })

-- Show shortcuts
vim.keymap.set('n', '<leader>?', "<cmd>lua require('which-key').show()<CR>", { desc = 'Show Shortcuts' })

-- Simplify saving and quitting
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>Q', '<cmd>q<CR>', { desc = 'Quit Neovim' })
vim.keymap.set('n', '<leader>x', '<cmd>wq<CR>', { desc = 'Save and Quit Neovim' })

-- Reload all buffers
vim.keymap.set('n', '<leader>r', '<cmd>bufdo e!<CR>', { desc = 'Reload all buffers' })
