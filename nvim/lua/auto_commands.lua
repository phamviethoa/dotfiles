-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Resolve Terraform file type detech issue
-- When create a new .tf files, the buffer file type was detached as tf rather than terraform
-- that cause fail to load terraform lsp and treesitter
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = { '*.tf', '*.tfvars' },
  callback = function()
    -- This forces the filetype to be 'terraform' immediately,
    -- even if the file is empty.
    vim.bo.filetype = 'terraform'
  end,
})
