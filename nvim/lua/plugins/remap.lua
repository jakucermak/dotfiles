vim.g.mapleader = " "
vim.keymap.set("n", "<leader>wv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>nt", vim.cmd.NvimTreeToggle)
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]]) 
vim.keymap.set("n", ";", vim.cmd.Telescope)

-- Debugging

vim.keymap.set("n", "<F9>", vim.cmd.DapStepOver) 
vim.keymap.set("n", "<F5>", vim.cmd.DapStepInto)
vim.keymap.set("n", "<F6>", vim.cmd.DapStepOut)
vim.keymap.set("n", "<leader>do", vim.cmd.DapContinue)
vim.keymap.set("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>")
vim.keymap.set("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim. fn. input('Breakpoint condition: '))<CR>") 
vim.keymap.set("n", "<leader>b", vim.cmd.DapToggleBreakpoint)
