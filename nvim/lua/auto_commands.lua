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

-- Use 4-space indentation for SQL / dbt files.
-- Neovim's default is 8, and we disable Treesitter indent for `sql` (the Jinja
-- root parser has no SQL indent rules), so set the buffer indent options here.
-- Matches the dbt project's `.sqlfluff` (tab_space_size = 4, indent_unit = space).
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sql' },
  callback = function()
    vim.bo.expandtab = true -- use spaces, not tab characters
    vim.bo.shiftwidth = 4 -- size of an indent (>>, <<, autoindent)
    vim.bo.tabstop = 4 -- display width of a tab
    vim.bo.softtabstop = 4 -- <Tab>/<BS> insert/delete 4 spaces
  end,
})

-- Resolve Terraform file type detech issue
-- When create a new .tf files, the buffer file type was detached as tf rather than terraform
-- that cause fail to load terraform lsp and treesitter
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = { '*.tf' },
  callback = function()
    -- This forces the filetype to be 'terraform' immediately,
    -- even if the file is empty.
    vim.bo.filetype = 'terraform'
  end,
})
