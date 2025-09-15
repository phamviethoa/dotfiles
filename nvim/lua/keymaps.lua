-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

vim.keymap.set('x', '<leader>p', '"_dP')

-- Improve page scrolling
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Improve movement between search occurrences
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Quickfix
-- See `:help quickfix`
vim.keymap.set('n', '<leader>j', '<cmd>cnext<CR>', { desc = 'Move to the next item in Quick Fix list' })
vim.keymap.set('n', '<leader>k', '<cmd>cprev<CR>', { desc = 'Move to the previous item in Quick Fix list' })

-- Open Notebook for working with .ipynb files
vim.keymap.set('n', '<leader>on', '<cmd>JupyterOpen<CR>', { desc = 'Open in JupyterLab' })
vim.api.nvim_create_user_command('JupyterOpen', function()
  local filepath = vim.fn.expand '%:p'
  if filepath:sub(-6) ~= '.ipynb' then
    print 'This is not a .ipynb file'
    return
  end
  local cmd = string.format("jupyter lab '%s' &", filepath)
  vim.fn.jobstart(cmd, { detach = true })
  print('Opening Jupyter Lab for file: ' .. filepath)
end, {})

-- tmux sessionizer
vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>')
