print('change lua')

vim.scriptencding = "utf-8"
vim.wo.number = true
vim.o.clipboard = vim.o.clipboard .. 'unnamedplus'
vim.o.autoindent = true
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true })
vim.api.nvim_set_keymap('i', 'kj', '<Esc>', { noremap = true })
