-- ~/.config/nvim/lua/keymaps.lua

-- Define common options for key mappings
local opts = { noremap = true, silent = true }

-- Helper function to merge common options with a description
local function opts_desc(description)
  return vim.tbl_extend("force", opts, { desc = description })
end

-- Shorten function name for convenience
local keymap = vim.keymap.set

-- Window Management Keybindings using <Leader>w prefix

-- Split window vertically
keymap('n', '<Leader>ws', ':split<CR>', opts_desc("Split window vertically"))

-- Split window horizontally
keymap('n', '<Leader>wv', ':vsplit<CR>', opts_desc("Split window horizontally"))

-- Close current window safely (prevents closing if buffer is modified or it's the last window)
keymap('n', '<Leader>wc', function()
  local current_buf = vim.api.nvim_get_current_buf()
  
  -- Check if the current buffer has unsaved changes
  if vim.api.nvim_buf_get_option(current_buf, 'modified') then
    vim.notify("Buffer has unsaved changes! Please save before closing.", vim.log.levels.WARN)
    return
  end
  
  -- Get the list of open windows in the current tabpage
  local windows = vim.api.nvim_tabpage_list_wins(0)
  
  -- Check if there's more than one window open
  if #windows > 1 then
    vim.cmd('close')
  else
    vim.notify("Cannot close the last window.", vim.log.levels.ERROR)
  end
end, opts_desc("Close current window safely"))

-- Move to the window to the left
keymap('n', '<Leader>wh', '<C-w>h', opts_desc("Move to the window to the left"))

-- Move to the window to the right
keymap('n', '<Leader>wl', '<C-w>l', opts_desc("Move to the window to the right"))

-- Move to the window above
keymap('n', '<Leader>wk', '<C-w>k', opts_desc("Move to the window above"))

-- Move to the window below
keymap('n', '<Leader>wj', '<C-w>j', opts_desc("Move to the window below"))

-- Resize window vertically (increase height)
keymap('n', '<Leader>w+', ':resize +<CR>', opts_desc("Increase window height"))

-- Resize window vertically (decrease height)
keymap('n', '<Leader>w-', ':resize -<CR>', opts_desc("Decrease window height"))

-- Resize window horizontally (increase width)
keymap('n', '<Leader>w>', ':vertical resize +<CR>', opts_desc("Increase window width"))

-- Resize window horizontally (decrease width)
keymap('n', '<Leader>w<', ':vertical resize -<CR>', opts_desc("Decrease window width"))

-- Optional Enhancements

-- Toggle horizontal split
keymap('n', '<Leader>wS', function()
  local windows = vim.api.nvim_tabpage_list_wins(0)
  if #windows > 1 then
    vim.cmd('close')
  else
    vim.cmd('split')
  end
end, opts_desc("Toggle horizontal split"))

-- Toggle vertical split
keymap('n', '<Leader>wV', function()
  local windows = vim.api.nvim_tabpage_list_wins(0)
  if #windows > 1 then
    vim.cmd('close')
  else
    vim.cmd('vsplit')
  end
end, opts_desc("Toggle vertical split"))

