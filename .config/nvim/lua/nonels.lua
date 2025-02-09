local M = {}

M.setup = function()
  local nls = require('null-ls')
  nls.setup({
    sources = {
      -- go
      nls.builtins.diagnostics.staticcheck,
      nls.builtins.formatting.goimports,
      -- gleam
      nls.builtins.formatting.gleam_format,
      -- web
      nls.builtins.formatting.biome,
      -- dart
      nls.builtins.formatting.dart_format,
      -- lua
      nls.builtins.formatting.stylua,
      -- editorconfig
      nls.builtins.diagnostics.editorconfig_checker,
      -- dotenv
      nls.builtins.diagnostics.dotenv_linter,
      -- yaml
      nls.builtins.diagnostics.yamllint,
      -- markdown
      nls.builtins.diagnostics.markdownlint,
      -- terraform
      nls.builtins.formatting.terraform_fmt,
    },
    on_attach = require('lsp').on_attach,
  })
end

return M
