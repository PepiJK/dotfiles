-- Leader key
vim.g.mapleader = " "

-- Clipboard (works on Windows + Linux)
vim.keymap.set("v", "<leader>y", '"+y',  { desc = "Copy to clipboard" })
vim.keymap.set("v", "<leader>x", '"+d',  { desc = "Cut to clipboard" })
vim.keymap.set("n", "<leader>p", '"+p',  { desc = "Paste after" })
vim.keymap.set("n", "<leader>P", '"+P',  { desc = "Paste before" })
vim.keymap.set("v", "<leader>p", '"+p',  { desc = "Paste (visual)" })

-- Save and quit
vim.keymap.set("n", "<leader>w", ":w<CR>",  { desc = "Save" })
vim.keymap.set("n", "<leader>q", ":q<CR>",  { desc = "Quit" })
vim.keymap.set("n", "<leader>!q", ":q!<CR>",  { desc = "Quit witout save" })
vim.keymap.set("n", "<leader>wq", ":wq<CR>", { desc = "Save and quit" })

-- Disable unused providers (removes checkhealth warnings)
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
