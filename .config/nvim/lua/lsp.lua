local M = {}

local opts = require('config').opts
local lsp = require('lspconfig')

local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
M.on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  buf_set_keymap('n', 'gd', ':lua vim.lsp.buf.definition()<Cr>', opts)
  buf_set_keymap('n', 'gr', ':lua vim.lsp.buf.references()<Cr>', opts)
  buf_set_keymap('n', 'gy', ':lua vim.lsp.buf.type_definition()<Cr>', opts)
  buf_set_keymap('n', 'gi', ':lua vim.lsp.buf.implementation()<Cr>', opts)
  buf_set_keymap('n', 'K', ':lua vim.lsp.buf.hover()<Cr>', opts)
  buf_set_keymap('i', '<C-s>', '<C-o>:lua vim.lsp.buf.signature_help()<Cr>', opts)
  buf_set_keymap('n', '<Leader>la', '<Cmd>lua vim.lsp.buf.code_action()<Cr>', opts)
  buf_set_keymap('n', '<Leader>lf', '<Cmd>lua vim.lsp.buf.format()<Cr>', opts)

  -- document highlighting
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup('lsp_document_highlight', {
      clear = false,
    })
    vim.api.nvim_clear_autocmds({
      buffer = bufnr,
      group = 'lsp_document_highlight',
    })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = 'lsp_document_highlight',
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      group = 'lsp_document_highlight',
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  -- format on save
  if client.supports_method('textDocument/formatting') then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({
          filter = function()
            if client.name == 'clangd' then
              return false
            end
            return true
          end,
          bufnr = bufnr,
        })
      end,
    })
  end
end

M.setup = function()
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  -- lsp providers

  lsp.clangd.setup({
    on_attach = M.on_attach,
    capabilities = capabilities,
    cmd = { 'clangd', '--enable-config' },
  })
  lsp.gopls.setup({
    on_attach = M.on_attach,
    capabilities = capabilities,
  })
  lsp.gleam.setup({
    on_attach = M.on_attach,
    capabilities = capabilities,
  })
  lsp.rust_analyzer.setup({
    on_attach = M.on_attach,
    capabilities = capabilities,
    settings = {
      ['rust-analyzer'] = {
        completion = {
          callable = {
            snippets = 'none',
          },
        },
      },
    },
  })
  lsp.zls.setup({
    on_attach = M.on_attach,
    capabilities = capabilities,
    settings = {
      zls = {
        enable_argument_placeholders = false,
      },
    },
  })
  lsp.ts_ls.setup({
    on_attach = M.on_attach,
    capabilities = capabilities,
    root_dir = lsp.util.root_pattern('package.json'),
    single_file_support = false,
  })
  lsp.emmet_language_server.setup({
    on_attach = M.on_attach,
    capabilities = capabilities,
  })
  lsp.cssls.setup({
    on_attach = M.on_attach,
    capabilities = capabilities,
  })
  lsp.tailwindcss.setup({
    on_attach = M.on_attach,
    capabilities = capabilities,
  })
  lsp.prismals.setup({
    on_attach = M.on_attach,
    capabilities = capabilities,
  })
  lsp.denols.setup({
    on_attach = M.on_attach,
    capabilities = capabilities,
    root_dir = lsp.util.root_pattern('deno.json', 'deno.jsonc', 'deps.ts', 'import_map.json'),
    init_options = {
      enable = true,
      lint = true,
      unstable = true,
      suggest = {
        imports = {
          hosts = {
            ['https://deno.land'] = true,
            ['https://cdn.nest.land'] = true,
            ['https://crux.land'] = true,
          },
        },
      },
    },
  })
  lsp.pyright.setup({
    on_attach = M.on_attach,
    capabilities = capabilities,
    settings = {
      pyright = {
        disableOrganizeImports = true,
      },
    },
  })
  lsp.lua_ls.setup({
    on_attach = M.on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
        },
        diagnostics = {
          globals = { 'vim' },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file('', true),
          checkThirdParty = false,
        },
        telemetry = {
          enable = false,
        },
        completion = {
          callSnippet = 'Replace',
        },
      },
    },
  })
  lsp.sqls.setup({
    on_attach = M.on_attach,
    capabilities = capabilities,
  })
  lsp.vimls.setup({
    on_attach = M.on_attach,
    capabilities = capabilities,
  })
  lsp.terraformls.setup({
    on_attach = M.on_attach,
    capabilities = capabilities,
  })
  lsp.jsonls.setup({
    on_attach = M.on_attach,
    capabilities = capabilities,
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
        validate = { enable = true },
      },
    },
    init_options = {
      provideFormatter = false,
    },
  })
  lsp.yamlls.setup({
    on_attach = M.on_attach,
    capabilities = capabilities,
    settings = {
      yaml = {
        schemaStore = {
          enable = false,
          url = '',
        },
        schemas = require('schemastore').yaml.schemas(),
      },
    },
  })

  -- UI

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = nil,
  })
  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = nil,
  })
end

return M
