-- Diagnostic utilities for checking LSP, formatters, and linters
local M = {}

-- Check active LSP servers for current buffer
function M.check_lsp()
  local clients = vim.lsp.get_active_clients { bufnr = 0 }
  if vim.tbl_isempty(clients) then
    print 'No LSP attached to this buffer'
    return
  end

  local names = {}
  for _, client in ipairs(clients) do
    table.insert(names, client.name)
  end

  print('Active LSPs: ' .. table.concat(names, ', '))
end

-- Check available formatters for current buffer
function M.check_formatter()
  local conform = require 'conform'
  local formatters = conform.list_formatters(0) -- 0 = current buffer

  if not formatters or #formatters == 0 then
    print('No formatters available for filetype: ' .. vim.bo.filetype)
    return
  end

  print('Formatters for filetype: ' .. vim.bo.filetype)
  for _, f in ipairs(formatters) do
    local status = f.available and '[OK]' or '[MISSING]'
    print('  ' .. f.name .. ' ' .. status .. ' -> ' .. (f.command or ''))
  end
end

-- Check configured linters for current buffer
function M.check_linter()
  local lint = require 'lint'
  local ft = vim.bo.filetype
  local linters = lint.linters_by_ft[ft]

  if not linters or #linters == 0 then
    print('No linters configured for filetype: ' .. ft)
    return
  end

  print('Linters for filetype: ' .. ft)
  for _, name in ipairs(linters) do
    local linter = lint.linters[name]
    if linter then
      print('  ' .. name .. ' -> ' .. (linter.cmd or ''))
    else
      print('  ' .. name .. ' [NOT FOUND in config]')
    end
  end
end

return M