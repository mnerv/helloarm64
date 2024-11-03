-- jk to escape
vim.keymap.set('i', 'jk', '<Esc>', {
  noremap = true,
  silent = true,
  desc = "Escape insert mode"
})

-- Escape from insert mode in terminal
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', {
  noremap = true,
  silent = true,
  desc = "Escape terminal insert mode"
})

-- Window navigation prefix
vim.keymap.set('n', '<space>w', '<C-w>', {
  noremap = true,
  silent = true,
  desc = "Window navigation"
})

-- Move current line up and down with alt+j and alt+k
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', {
  noremap = true,
  silent = true,
  desc = "Move current line down"
})
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', {
  noremap = true,
  silent = true,
  desc = "Move current line up"
})

-- Move highlighted lines up and down with alt+j and alt+k
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", {
  noremap = true,
  silent = true,
  desc = "Move selected lines down"
})
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", {
  noremap = true,
  silent = true,
  desc = "Move selected lines up"
})

-- Make sure we don't exit visual mode when indenting
vim.keymap.set("v", ">", ">gv", { desc = "Indent and keep selection" })
vim.keymap.set("v", "<", "<gv", { desc = "Outdent and keep selection" })

-- Highlight the current word without moving
vim.keymap.set('n', '<C-s>', function()
  local word = vim.fn.expand('<cword>')
  if word ~= "" then
    vim.fn.setreg('/', '\\<' .. word .. '\\>')
    vim.cmd('set hlsearch')
  end
end, { desc = "Highlight word under cursor" })
