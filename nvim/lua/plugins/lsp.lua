local lsp = require('lsp-zero')


lsp.preset('recommended')

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

lsp.set_sign_icons({
  error = '',
  warn = '',
  hint = '⚑',
  info = '»'
})



lsp.setup()
