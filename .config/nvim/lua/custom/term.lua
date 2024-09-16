-- Function to toggle the terminal window
local function toggle_terminal()
  local term_bufnr = nil
  -- Check if the terminal buffer exists
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local ok, is_my_term = pcall(vim.api.nvim_buf_get_var, bufnr, 'my_terminal')
    if ok and is_my_term then
      term_bufnr = bufnr
      break
    end
  end

  if term_bufnr == nil then
    -- Terminal doesn't exist, create it
    vim.cmd('botright 15split | terminal')
    term_bufnr = vim.api.nvim_get_current_buf()
    -- Mark the buffer as our terminal
    vim.api.nvim_buf_set_var(term_bufnr, 'my_terminal', true)
  else
    -- Terminal exists
    local term_win = nil
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == term_bufnr then
        term_win = win
        break
      end
    end
    if term_win then
      -- Terminal is visible, close it
      vim.api.nvim_win_close(term_win, true)
    else
      -- Terminal is hidden, show it
      vim.cmd('botright 15split')
      vim.api.nvim_set_current_buf(term_bufnr)
    end
  end
end

-- Map the function to <leader>t
vim.keymap.set('n', '<leader>`', toggle_terminal, { noremap = true, silent = true })

