local builtin = require('telescope.builtin')
vim.keymap.set('n', "<leader>pf", builtin.find_files, {})
vim.keymap.set('n', "<leader>wf", builtin.git_files, {})
