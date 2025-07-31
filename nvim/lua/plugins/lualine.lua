return {
  {
    -- Status Bar
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        theme = 'dracula',
        section_separators = '',
        component_separators = '',
        globalstatus = true, -- Optional: unified single statusline
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = {},
        lualine_y = { 'filetype' },
        lualine_z = { 'location' },
      },
    },
  },
}
