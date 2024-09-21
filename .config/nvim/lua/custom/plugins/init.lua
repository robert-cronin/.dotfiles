-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'tpope/vim-fugitive',
    -- Lazy-load the plugin when running Git commands or when Git-related files are opened
    cmd = { 'Git', 'G', 'Gdiffsplit', 'Gread', 'Gwrite' },
    -- Optionally, you can load the plugin on specific events
    -- event = "BufReadPre",
    -- Setup key mappings
    keys = {
      -- Git Status
      {
        '<leader>gs',
        ':Git status<CR>',
        desc = 'Git Status',
        mode = 'n', -- Normal mode
      },
      -- Git Commit
      {
        '<leader>gc',
        ':Git commit<CR>',
        desc = 'Git Commit',
        mode = 'n',
      },
      -- Git Push
      {
        '<leader>gp',
        ':Git push<CR>',
        desc = 'Git Push',
        mode = 'n',
      },
      -- Git Pull
      {
        '<leader>gP',
        ':Git pull<CR>',
        desc = 'Git Pull',
        mode = 'n',
      },
      -- Git Log
      {
        '<leader>gl',
        ':Git log<CR>',
        desc = 'Git Log',
        mode = 'n',
      },
      -- Git Blame
      {
        '<leader>gb',
        ':Git blame<CR>',
        desc = 'Git Blame',
        mode = 'n',
      },
      -- Open Fugitive's Git window
      {
        '<leader>gg',
        ':Git<CR>',
        desc = 'Open Git',
        mode = 'n',
      },
      -- Toggle Git diff view
      {
        '<leader>gd',
        ':Gdiffsplit<CR>',
        desc = 'Git Diff Split',
        mode = 'n',
      },
    },
    -- Optional: Additional configuration for fugitive
    config = function()
      -- Example: Customize fugitive's Git commands or behaviors
      -- Here, you can set global variables or define custom commands

      -- Example: Enable persistent Git diff views
      vim.g.fugitive_diff = 1

      -- Example: Create a user command for Git add
      vim.api.nvim_create_user_command('GitAdd', 'Git add %', { desc = 'Git Add Current File' })

      -- Example: Key mapping within fugitive's buffer
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'fugitive',
        callback = function()
          -- Press <CR> to open the file in a new split
          vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', ':Gedit<CR>', { noremap = true, silent = true, desc = 'Open File in Split' })
        end,
      })
    end,
  },
  -- {
  --   'github/copilot.vim',
  --   branch = 'release'
  -- },
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
