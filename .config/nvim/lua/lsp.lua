local opts = require('config').opts
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    -- prevent default keymaps (https://neovim.io/doc/user/lsp.html#_global-defaults)
    pcall(vim.api.nvim_del_keymap, 'n', 'grn')
    pcall(vim.api.nvim_del_keymap, 'n', 'gra')
    pcall(vim.api.nvim_del_keymap, 'v', 'gra')
    pcall(vim.api.nvim_del_keymap, 'n', 'grr')
    pcall(vim.api.nvim_del_keymap, 'n', 'gri')
    pcall(vim.api.nvim_del_keymap, 'n', 'gO')
    pcall(vim.api.nvim_del_keymap, 'i', '<C-s>')
    -- remap keys
    vim.api.nvim_set_keymap('n', 'gd', ':lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_set_keymap('n', 'gr', ':lua vim.lsp.buf.references()<CR>', opts)
    vim.api.nvim_set_keymap('n', 'gy', ':lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.api.nvim_set_keymap('n', 'gi', ':lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_set_keymap('n', 'K', ':lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_set_keymap('i', '<C-s>', '<C-o>:lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.api.nvim_set_keymap('n', '<Leader>la', ':lua vim.lsp.buf.code_action()<CR>', opts)
    vim.api.nvim_set_keymap('n', '<Leader>lf', ':lua vim.lsp.buf.format()<CR>', opts)
    vim.api.nvim_set_keymap('n', '<Leader>lr', ':lua vim.lsp.buf.rename()<CR>', opts)
  end,
})

local lsp = {
  'clangd',
  'gopls',
  'gleam',
  'rust_analyzer',
  'zls',
  'ts_ls',
  'denols',
  'emmet_language_server',
  'cssls',
  'tailwindcss',
  'prismals',
  'pyright',
  'lua_ls',
  'sqls',
  'vimls',
  'terraformls',
  'jsonls',
  'yamlls',
}
vim.lsp.enable(lsp)
