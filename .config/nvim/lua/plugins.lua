local config = require('config')
local opts = config.opts

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
  vim.o.termguicolors = true
  add({ source = 'catppuccin/nvim', name = 'catppuccin' })
  require('catppuccin').setup({
    integrations = {
      lsp_trouble = true,
      mini = {
        enabled = true,
        indentscope_color = '',
      },
      native_lsp = {
        enabled = true,
      },
      telescope = {
        enabled = true,
      },
    },
  })
  vim.cmd.colorscheme('catppuccin')
end)

now(function()
  add('wsdjeg/vim-fetch')
end)

now(function()
  require('mini.notify').setup()
  vim.notify = require('mini.notify').make_notify()
end)
now(function()
  require('mini.icons').setup()
end)
now(function()
  require('mini.tabline').setup()
end)
now(function()
  require('mini.statusline').setup()
end)

later(function()
  require('mini.ai').setup()
end)
later(function()
  require('mini.align').setup()
end)
later(function()
  require('mini.bracketed').setup()
end)
later(function()
  require('mini.comment').setup()
end)
later(function()
  require('mini.cursorword').setup()
end)
later(function()
  require('mini.git').setup()
end)
later(function()
  require('mini.hipatterns').setup()
end)
later(function()
  require('mini.indentscope').setup()
end)
later(function()
  require('mini.move').setup()
end)
later(function()
  require('mini.pairs').setup()
  local map_bs = function(lhs, rhs)
    vim.keymap.set('i', lhs, rhs, { expr = true, replace_keycodes = false })
  end
  map_bs('<C-h>', 'v:lua.MiniPairs.bs()')
  map_bs('<C-w>', 'v:lua.MiniPairs.bs("\23")')
  map_bs('<C-u>', 'v:lua.MiniPairs.bs("\21")')
end)
later(function()
  require('mini.splitjoin').setup()
end)
later(function()
  require('mini.surround').setup()
end)
later(function()
  require('mini.trailspace').setup()
end)

now(function()
  add({
    source = 'neovim/nvim-lspconfig',
    depends = { 'williamboman/mason.nvim', 'b0o/schemastore.nvim' },
  })
  require('mason').setup()
  require('lsp')
end)

now(function()
  add('folke/trouble.nvim')
  require('trouble').setup({
    auto_close = true,
    focus = true,
  })
end)

now(function()
  add('rafamadriz/friendly-snippets')
  local cmp = require('mini.completion')
  local snip = require('mini.snippets')
  cmp.setup()
  snip.setup({
    snippets = {
      snip.gen_loader.from_lang(),
    },
  })
  snip.start_lsp_server()
end)

later(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'master',
    monitor = 'main',
    hooks = {
      post_checkout = function()
        vim.cmd('TSUpdate')
      end,
    },
  })
  add('yioneko/nvim-yati')
  add('RRethy/nvim-treesitter-endwise')
  add('windwp/nvim-ts-autotag')
  require('nvim-treesitter.configs').setup({
    ensure_installed = 'all',
    sync_install = false,
    auto_install = true,
    highlight = { enable = true },
    indent = {
      enable = false,
    },
    yati = {
      enable = true,
      disable = { 'c', 'cpp' },
    },
    endwise = {
      enable = true,
    },
  })
  require('nvim-ts-autotag').setup({
    opts = {
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = true,
    },
  })
end)

later(function()
  add('stevearc/oil.nvim')
  require('oil').setup({
    watch_for_changes = true,
    view_options = {
      show_hidden = true,
    },
  })
  vim.api.nvim_set_keymap('n', '-', ':Oil<CR>', opts)
end)

later(function()
  add({
    source = 'nvim-telescope/telescope.nvim',
    depends = { 'nvim-lua/plenary.nvim' },
  })
  require('telescope').setup({
    defaults = {
      vimgrep_arguments = {
        'rg',
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case',
        '--hidden',
        '--trim',
      },
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = 'smart_case',
      },
      termfinder = {
        mappings = {
          rename_term = '<C-r>',
          delete_term = '<C-x>',
          vertical_term = '<C-v>',
          horizontal_term = '<C-h>',
          float_term = '<C-f>',
        },
      },
    },
  })
  -- common finders
  vim.api.nvim_set_keymap('n', '<C-s>', ':Telescope current_buffer_fuzzy_find theme=get_dropdown<CR>', opts)
  vim.api.nvim_set_keymap(
    'n',
    '<Leader>ff',
    ':Telescope find_files find_command=rg,--ignore,--hidden,--no-ignore,--files theme=get_dropdown<CR>',
    opts
  )
  vim.api.nvim_set_keymap('n', '<Leader>fg', ':Telescope live_grep theme=get_dropdown<CR>', opts)
  vim.api.nvim_set_keymap('n', '<Leader>fb', ':Telescope buffers theme=get_dropdown<CR>', opts)
  vim.api.nvim_set_keymap('n', '<Leader>fd', ':Telescope diagnostics theme=get_dropdown<CR>', opts)
  vim.api.nvim_set_keymap('n', '<Leader>fc', ':Telescope command_history theme=get_dropdown<CR>', opts)
  vim.api.nvim_set_keymap('n', '<Leader>fs', ':Telescope search_history theme=get_dropdown<CR>', opts)
end)

later(function()
  add('stevearc/conform.nvim')
  require('conform').setup({
    formatters_by_ft = {
      lua = { 'stylua' },
      go = { 'goimports' },
      rust = { 'rustfmt' },
      gleam = { 'gleam' },
      python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
      javascript = { 'biome-check', 'biome', 'biome-organize-imports' },
      javascriptreact = { 'biome-check', 'biome', 'biome-organize-imports' },
      typescript = { 'biome-check', 'biome', 'biome-organize-imports' },
      typescriptreact = { 'biome-check', 'biome', 'biome-organize-imports' },
      html = { 'prettier' },
      css = { 'biome' },
      json = { 'biome' },
      jsonc = { 'biome' },
      terraform = { 'terraform_fmt' },
    },
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_format = 'fallback' }
    end,
  })
end)

later(function()
  add('mfussenegger/nvim-lint')
  require('lint').linters_by_ft = {
    python = { 'ruff' },
    javascript = { 'biomejs' },
    javascriptreact = { 'biomejs' },
    typescript = { 'biomejs' },
    typescriptreact = { 'biomejs' },
    css = { 'biomejs' },
    json = { 'biomejs' },
    jsonc = { 'biomejs' },
  }
  vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
    callback = function()
      require('lint').try_lint()
    end,
  })
end)

later(function()
  add('akinsho/toggleterm.nvim')
  require('toggleterm').setup({
    size = 20,
    open_mapping = [[<C-\>]],
    hide_numbers = true,
    shade_terminals = false,
    direction = 'float',
    float_opts = {
      border = 'curved',
    },
    winbar = {
      enabled = true,
      name_formatter = function(term)
        return term.name
      end,
    },
  })
end)

later(function()
  add({
    source = 'linux-cultist/venv-selector.nvim',
    checkout = 'regexp',
    depends = {
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-dap',
      'mfussenegger/nvim-dap-python',
      'nvim-telescope/telescope.nvim',
    },
  })
  require('venv-selector').setup()
  vim.api.nvim_set_keymap('n', ',v', ':VenvSelect<CR>', opts)
end)

later(function()
  add('olrtg/nvim-emmet')
  vim.keymap.set({ 'n', 'v' }, '<Leader>xe', require('nvim-emmet').wrap_with_abbreviation)
end)

later(function()
  add({
    source = 'jellydn/hurl.nvim',
    depends = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
  })
  require('hurl').setup({
    debug = false,
    show_notification = true,
    mode = 'split',
    auto_close = false,
    env_file = { '.env' },
  })
  vim.api.nvim_set_keymap('n', '<Leader>ha', ':HurlRunnerAt<CR>', opts)
  vim.api.nvim_set_keymap('n', '<Leader>hA', ':HurlRunner<CR>', opts)
  vim.api.nvim_set_keymap('v', '<Leader>hh', ':HurlRunner<CR>', opts)
end)
