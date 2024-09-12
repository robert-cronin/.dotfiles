-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'neoclide/coc.nvim',
    branch = 'release',
    build = 'yarn install --frozen-lockfile',
    config = function()
      -- Basic coc.nvim configuration
      vim.g.coc_global_extensions = {
        'coc-json',
        'coc-go',
      }

      -- Some example keymappings
      local keyset = vim.keymap.set
      -- GoTo code navigation
      keyset('n', 'gd', '<Plug>(coc-definition)', { silent = true })
      keyset('n', 'gy', '<Plug>(coc-type-definition)', { silent = true })
      keyset('n', 'gi', '<Plug>(coc-implementation)', { silent = true })
      keyset('n', 'gr', '<Plug>(coc-references)', { silent = true })

      -- Use K to show documentation in preview window
      function _G.show_docs()
        local cw = vim.fn.expand '<cword>'
        if vim.fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0 then
          vim.api.nvim_command('h ' .. cw)
        elseif vim.api.nvim_eval 'coc#rpc#ready()' then
          vim.fn.CocActionAsync 'doHover'
        else
          vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
        end
      end

      keyset('n', 'K', '<CMD>lua _G.show_docs()<CR>', { silent = true })

      -- Highlight the symbol and its references when holding the cursor
      vim.api.nvim_create_augroup('CocGroup', {})
      vim.api.nvim_create_autocmd('CursorHold', {
        group = 'CocGroup',
        command = "silent call CocActionAsync('highlight')",
        desc = 'Highlight symbol under cursor on CursorHold',
      })

      -- Symbol renaming
      keyset('n', '<leader>rn', '<Plug>(coc-rename)', { silent = true })
    end,
  },

  {
    'sindrets/diffview.nvim',
  },
}
