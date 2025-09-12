return {
  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set('n', 'gs', ':G<CR>', { desc = '[G]it [s]tatus' })
      vim.keymap.set('n', 'gb', ':G blame<CR>', { desc = '[G]it [b]lame' })

      -- Resolve conflict
      vim.keymap.set('n', 'gd', ':Gdiffsplit!<CR>', { desc = '[G]it [d]iff split' })
      vim.keymap.set('n', 'gf', ':diffget //2<CR>', { desc = 'Take ours' })
      vim.keymap.set('n', 'gj', ':diffget //3<CR>', { desc = 'Take theirs' })
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        local function go_to_next_change()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end

        local function go_to_prev_change()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end

        map('n', ']c', go_to_next_change, { desc = 'Jump to [n]ext git [c]hange' })
        map('n', '[c', go_to_prev_change, { desc = 'Jump to previous git [c]hange' })

        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })

        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
      end,
    },
  },
}
