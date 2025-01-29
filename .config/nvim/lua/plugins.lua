local opts = require('config').opts
local opts_silent = require('config').opts_silent
local sign = require('config').sign
local cmp_kinds = require('config').cmp_kinds

return {
  -- Color
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    init = function()
      vim.g.catppuccin_flavour = 'mocha'
    end,
    config = function()
      require('catppuccin').setup({
        transparent_background = true,
        show_end_of_buffer = false,
        term_colors = true,
        dim_inactive = {
          enabled = false,
        },
        styles = {
          comments = { 'italic' },
          conditionals = { 'italic' },
          functions = { 'italic' },
          keywords = { 'italic' },
          types = { 'italic' },
        },
        integrations = {
          blink_cmp = true,
          dropbar = {
            enabled = true,
          },
          lsp_trouble = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { 'italic' },
              hints = { 'italic' },
              warnings = { 'italic' },
              information = { 'italic' },
            },
            underlines = {
              errors = { 'undercurl' },
              hints = { 'undercurl' },
              warnings = { 'undercurl' },
              information = { 'undercurl' },
            },
            inlay_hints = {
              background = true,
            },
          },
          noice = true,
          nvim_surround = true,
          render_markdown = true,
          telescope = {
            enabled = true,
          },
        },
      })
      vim.cmd([[colorscheme catppuccin]])
      -- Show current line
      vim.api.nvim_set_hl(0, 'CursorLine', { underline = true })
      vim.wo.cursorline = true
    end,
  },

  -- UI
  {
    'stevearc/dressing.nvim',
    config = true,
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    init = function()
      vim.api.nvim_set_keymap('n', '<Leader>nn', ':NoiceAll<CR>', opts)
    end,
    config = true,
    opts = {
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
        signature = {
          enabled = false,
        },
      },
      presets = {
        bottom_search = false,
        command_palette = false,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
  },

  -- Explorer
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    init = function()
      vim.api.nvim_set_keymap('n', '\\', ':Oil<CR>', opts)
    end,
    config = function()
      function _G.get_oil_winbar()
        local dir = require('oil').get_current_dir()
        if dir then
          return vim.fn.fnamemodify(dir, ':~')
        else
          return vim.api.nvim_buf_get_name(0)
        end
      end

      require('oil').setup({
        win_options = {
          winbar = '%!v:lua.get_oil_winbar()',
        },
        watch_for_changes = true,
        view_options = {
          show_hidden = true,
        },
      })
    end,
  },

  -- Window
  {
    'yorickpeterse/nvim-window',
    init = function()
      vim.api.nvim_set_keymap('n', '<Leader>w', ':lua require("nvim-window").pick()<CR>', opts)
    end,
    opts = {
      chars = { 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l' },
    },
  },

  -- Buffer
  { 'tiagovla/scope.nvim' },
  {
    'famiu/bufdelete.nvim',
    cmd = { 'Bdelete', 'Bwipeout' },
    init = function()
      vim.api.nvim_set_keymap('n', '<Leader>bd', ':bw<CR>', opts)
      vim.api.nvim_set_keymap('n', '<Leader>bad', ':bufdo :bw<CR>', opts)
      vim.api.nvim_set_keymap('n', '<Leader>bD', ':Bwipeout<CR>', opts)
      vim.api.nvim_set_keymap('n', '<Leader>baD', ':bufdo :Bwipeout<CR>', opts)
    end,
  },

  -- Bufferline
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'catppuccin/nvim',
    },
    init = function()
      vim.api.nvim_set_keymap('n', '<Leader>bs', ':BufferLinePick<CR>', opts)
      vim.api.nvim_set_keymap('n', '<Leader>bp', ':BufferLineCyclePrev<CR>', opts)
      vim.api.nvim_set_keymap('n', '<Leader>bn', ':BufferLineCycleNext<CR>', opts)
      vim.api.nvim_set_keymap('n', '<M-,>', ':BufferLineCyclePrev<CR>', opts)
      vim.api.nvim_set_keymap('n', '<M-.>', ':BufferLineCycleNext<CR>', opts)
      vim.api.nvim_set_keymap('n', '<M-<>', ':BufferLineMovePrev<CR>', opts)
      vim.api.nvim_set_keymap('n', '<M->>', ':BufferLineMoveNext<CR>', opts)
    end,
    config = function()
      require('bufferline').setup({
        highlights = require('catppuccin.groups.integrations.bufferline').get(),
        options = {
          diagnostics = 'nvim_lsp',
          diagnostics_indicator = function(_, _, diagnostics_dict, _)
            local s = ' '
            local ws = ' '
            for e, n in pairs(diagnostics_dict) do
              local sym = e == 'error' and sign.error .. ws or (e == 'warning' and sign.warn .. ws or sign.info .. ws)
              s = s .. n .. sym
            end
            return s
          end,
          custom_filter = function(buf_number)
            if vim.bo[buf_number].filetype ~= 'qf' then
              return true
            end
          end,
        },
      })
    end,
  },

  -- Statusline
  {
    'feline-nvim/feline.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'catppuccin/nvim',
    },
    config = function()
      local ctp_feline = require('catppuccin.groups.integrations.feline')
      require('feline').setup({
        components = ctp_feline.get(),
      })
    end,
  },
  {
    'Bekaboo/dropbar.nvim',
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim',
    },
    init = function()
      vim.api.nvim_set_keymap('n', '<Leader>ds', '<Cmd>lua require("dropbar.api").pick()<CR>', opts)
    end,
    config = true,
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'yioneko/nvim-yati',
      'RRethy/nvim-treesitter-endwise',
    },
    config = function()
      require('treesitter')
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      enable = true,
    },
  },

  -- Fuzzy Finder
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',
      },
    },
    config = function()
      local telescope = require('telescope')
      telescope.setup({
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
      telescope.load_extension('fzf')

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
      vim.api.nvim_set_keymap('n', '<Leader>fh', ':Telescope help_tags theme=get_dropdown<CR>', opts)
      vim.api.nvim_set_keymap('n', '<Leader>fc', ':Telescope command_history theme=get_dropdown<CR>', opts)
      vim.api.nvim_set_keymap('n', '<Leader>fs', ':Telescope search_history theme=get_dropdown<CR>', opts)
      -- lsp
      vim.api.nvim_set_keymap('n', 'gd', ':Telescope lsp_definitions theme=get_dropdown<CR>', opts)
      vim.api.nvim_set_keymap('n', 'gr', ':Telescope lsp_references theme=get_dropdown<CR>', opts)
      vim.api.nvim_set_keymap('n', 'gy', ':Telescope lsp_type_definitions theme=get_dropdown<CR>', opts)
      vim.api.nvim_set_keymap('n', 'gi', ':Telescope lsp_implementations theme=get_dropdown<CR>', opts)
      -- tree sitter
      vim.api.nvim_set_keymap('n', '<Leader>ts', ':Telescope treesitter theme=get_dropdown<CR>', opts)
    end,
  },

  -- Git Support
  {
    'lewis6991/gitsigns.nvim',
    init = function()
      vim.api.nvim_set_keymap('n', '<Leader>gq', ':Gitsigns setqflist all<CR>', opts)
    end,
    opts = {
      trouble = true,
      current_line_blame = true,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, _opts)
          _opts = _opts or {}
          _opts.buffer = bufnr
          vim.keymap.set(mode, l, r, _opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true })

        map('n', '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true })

        -- Actions
        map('n', '<Leader>gp', gs.preview_hunk)
        map('n', '<Leader>gbp', function()
          gs.blame_line({ full = true })
        end)
      end,
    },
  },
  {
    'FabijanZulj/blame.nvim',
    init = function()
      vim.api.nvim_set_keymap('n', '<Leader>gbb', ':BlameToggle<CR>', opts)
    end,
    config = true,
  },
  {
    'akinsho/git-conflict.nvim',
    opts = {
      disable_diagnostics = true,
    },
  },

  -- Editor Support
  {
    'm-demare/hlargs.nvim',
    dependencies = {
      'catppuccin/nvim',
    },
    config = function()
      require('hlargs').setup({
        color = require('catppuccin.palettes').get_palette('mocha').red,
      })
    end,
  },
  {
    'shellRaining/hlchunk.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('hlchunk').setup({
        chunk = {
          enable = true,
          use_treesitter = true,
          delay = 0,
        },
        indent = {
          enable = true,
          use_treesitter = false,
        },
      })
    end,
  },
  {
    'yamatsum/nvim-cursorline',
    opts = {
      cursorline = {
        enable = false,
      },
      cursorword = {
        enable = true,
      },
    },
  },
  {
    'numToStr/Comment.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
      require('ts_context_commentstring').setup({
        enable_autocmd = false,
      })
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end,
  },
  {
    'folke/todo-comments.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    init = function()
      vim.api.nvim_set_keymap('n', '<Leader>tc', ':TodoTrouble<CR>', opts)
    end,
    config = true,
  },
  {
    'windwp/nvim-autopairs',
    opts = {
      disable_filetype = { 'TelescopePrompt', 'vim' },
      check_ts = true,
      map_cr = true,
      map_bs = true,
      map_c_h = true,
      map_c_w = true,
    },
  },
  {
    'windwp/nvim-ts-autotag',
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true,
      },
    },
  },
  { 'gpanders/editorconfig.nvim' },
  {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    config = true,
  },
  { 'andymass/vim-matchup' },
  {
    'norcalli/nvim-colorizer.lua',
    opts = { '*' },
  },
  {
    'petertriho/nvim-scrollbar',
    dependencies = { 'kevinhwang91/nvim-hlslens', 'lewis6991/gitsigns.nvim' },
    init = function()
      vim.api.nvim_set_keymap(
        'n',
        'n',
        [[:execute('normal! ' . v:count1 . 'n')<CR>:lua require('hlslens').start()<CR>]],
        opts
      )
      vim.api.nvim_set_keymap(
        'n',
        'N',
        [[:execute('normal! ' . v:count1 . 'N')<CR>:lua require('hlslens').start()<CR>]],
        opts
      )
    end,
    config = function()
      require('scrollbar').setup()
      require('scrollbar.handlers.search').setup()
      require('scrollbar.handlers.gitsigns').setup()
    end,
  },
  {
    'haya14busa/vim-asterisk',
    dependencies = { 'kevinhwang91/nvim-hlslens' },
    config = function()
      vim.api.nvim_set_keymap('n', '*', [[<Plug>(asterisk-z*):lua require('hlslens').start()<CR>]], opts_silent)
      vim.api.nvim_set_keymap('n', '#', [[<Plug>(asterisk-z#):lua require('hlslens').start()<CR>]], opts_silent)
      vim.api.nvim_set_keymap('n', 'g*', [[<Plug>(asterisk-gz*):lua require('hlslens').start()<CR>]], opts_silent)
      vim.api.nvim_set_keymap('n', 'g#', [[<Plug>(asterisk-gz#):lua require('hlslens').start()<CR>]], opts_silent)
      vim.api.nvim_set_keymap('x', '*', [[<Plug>(asterisk-z*):lua require('hlslens').start()<CR>]], opts_silent)
      vim.api.nvim_set_keymap('x', '#', [[<Plug>(asterisk-z#):lua require('hlslens').start()<CR>]], opts_silent)
      vim.api.nvim_set_keymap('x', 'g*', [[<Plug>(asterisk-gz*):lua require('hlslens').start()<CR>]], opts_silent)
      vim.api.nvim_set_keymap('x', 'g#', [[<Plug>(asterisk-gz#):lua require('hlslens').start()<CR>]], opts_silent)
    end,
  },
  {
    'danymat/neogen',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    init = function()
      vim.api.nvim_set_keymap('n', '<Leader>nf', ':lua require("neogen").generate()<CR>', opts)
    end,
    config = true,
  },
  {
    'yaocccc/nvim-foldsign',
    config = true,
  },
  {
    'chentoast/marks.nvim',
    opts = {
      default_mappings = true,
    },
  },
  { 'AndrewRadev/linediff.vim' },
  {
    'junegunn/vim-easy-align',
    init = function()
      vim.api.nvim_set_keymap('x', 'ga', '<Plug>(EasyAlign)', opts)
      vim.api.nvim_set_keymap('n', 'ga', '<Plug>(EasyAlign)', opts)
    end,
  },
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    keys = { '<Space>m', '<Space>j', '<Space>s' },
    init = function()
      vim.keymap.set('n', '<Space>M', function()
        require('treesj').toggle({ split = { recursive = true } })
      end)
      vim.keymap.set('n', '<Space>S', function()
        require('treesj').split({ split = { recursive = true } })
      end)
    end,
    config = true,
  },

  -- Terminal
  {
    'akinsho/nvim-toggleterm.lua',
    opts = {
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
    },
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'jay-babu/mason-null-ls.nvim',
      {
        'nvimtools/none-ls.nvim',
        dependencies = { 'nvim-lua/plenary.nvim', 'nvimtools/none-ls-extras.nvim' },
      },
      'folke/neodev.nvim',
      'b0o/schemastore.nvim',
    },
    config = function()
      -- prevent some default mappings by this plugin
      pcall(vim.api.nvim_del_keymap, 'n', 'grr')
      pcall(vim.api.nvim_del_keymap, 'n', 'gra')
      pcall(vim.api.nvim_del_keymap, 'x', 'gra')
      pcall(vim.api.nvim_del_keymap, 'n', 'grn')
      require('mason').setup({
        log_level = vim.log.levels.INFO,
      })
      require('mason-lspconfig').setup({
        automatic_installation = true,
      })
      require('nonels').setup()
      require('mason-null-ls').setup({
        automatic_installation = true,
      })
      require('neodev').setup()
      require('lsp').setup()
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = sign.error,
            [vim.diagnostic.severity.WARN] = sign.warn,
            [vim.diagnostic.severity.INFO] = sign.info,
            [vim.diagnostic.severity.HINT] = sign.hint,
          },
          numhl = {
            [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
            [vim.diagnostic.severity.WARN] = 'WarningMsg',
          },
        },
      })
      local signs = { Error = sign.error, Warn = sign.warn, Hint = sign.hint, Info = sign.info }
      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    keys = {
      { '<Leader>td', ':Trouble diagnostics toggle filter.buf=0 focus=1<CR>' },
      { '<Leader>tw', ':Trouble diagnostics toggle focus=1<CR>' },
      { '<Leader>tq', ':Trouble qflist toggle focus=1<CR>' },
      { '<Leader>tl', ':Trouble loclist toggle focus=1<CR>' },
    },
    opts = {
      auto_close = true,
      focus = true,
    },
  },
  {
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    init = function()
      vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = { only_current_line = true },
      })
    end,
    config = true,
  },
  {
    'smjonas/inc-rename.nvim',
    init = function()
      vim.keymap.set('n', '<Leader>lr', function()
        return ':IncRename ' .. vim.fn.expand('<cword>')
      end, { expr = true })
    end,
    config = true,
  },

  -- Completion
  {
    'saghen/blink.compat',
    version = '*',
    lazy = true,
  },
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets', 'fang2hou/blink-copilot' },
    version = '*',
    opts = {
      keymap = {
        preset = 'enter',
      },
      snippets = { preset = 'default' },
      signature = {
        enabled = true,
        window = {
          show_documentation = false,
        },
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 0 },
        ghost_text = { enabled = true },
        accept = { auto_brackets = { enabled = false } },
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
          cycle = {
            from_bottom = true,
            from_top = true,
          },
        },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
        kind_icons = {
          Copilot = '',
        },
      },
      sources = {
        default = {
          'copilot',
          'lsp',
          'path',
          'snippets',
          'buffer',
          'avante_commands',
          'avante_mentions',
          'avante_files',
        },
        per_filetype = {
          org = { 'orgmode' },
        },
        providers = {
          copilot = {
            name = 'copilot',
            module = 'blink-copilot',
            score_offset = 100,
            async = true,
            opts = {
              max_completions = 3,
              max_attempts = 4,
            },
          },
          orgmode = {
            name = 'Orgmode',
            module = 'orgmode.org.autocompletion.blink',
            fallbacks = { 'buffer' },
          },
          avante_commands = {
            name = 'avante_commands',
            module = 'blink.compat.source',
            score_offset = 90,
            opts = {},
          },
          avante_files = {
            name = 'avante_files',
            module = 'blink.compat.source',
            score_offset = 100,
            opts = {},
          },
          avante_mentions = {
            name = 'avante_mentions',
            module = 'blink.compat.source',
            score_offset = 1000,
            opts = {},
          },
        },
      },
    },
    opts_extend = { 'sources.default' },
  },

  -- Generative AI
  {
    'zbirenbaum/copilot.lua',
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },
  {
    'zbirenbaum/copilot-cmp',
    config = true,
  },
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    lazy = false,
    version = false,
    build = 'make',
    dependencies = {
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
      {
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true,
          },
        },
      },
    },
    opts = {
      provider = 'copilot',
      copilot = {
        model = 'claude-3.5-sonnet',
      },
      behaviour = {
        auto_suggestions = false,
      },
      windows = {
        edit = {
          start_insert = true,
        },
        ask = {
          start_insert = true,
        },
      },
      file_selector = {
        provider = 'native',
      },
    },
  },

  -- Syntax Highlight / Language Support
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {
      file_types = { 'markdown', 'Avante' },
    },
    ft = { 'markdown', 'Avante' },
  },
  {
    'nvim-orgmode/orgmode',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter' },
    },
    config = function()
      require('orgmode').setup({
        org_startup_indented = false,
        org_adapt_indentation = false,
        org_agenda_files = '~/.org/**/*',
        org_default_notes_file = '~/.org/refile.org',
      })
    end,
  },
  {
    'lukas-reineke/headlines.nvim',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('headlines').setup({
        markdown = {
          bullets = false,
          fat_headlines = false,
        },
        rmd = {
          bullets = false,
          fat_headlines = false,
        },
        norg = {
          bullets = false,
          fat_headlines = false,
        },
        org = {
          bullets = false,
          fat_headlines = false,
        },
      })
    end,
  },

  { 'dhruvasagar/vim-table-mode' },
  {
    'linux-cultist/venv-selector.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-dap',
      'mfussenegger/nvim-dap-python',
      { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
    },
    lazy = false,
    branch = 'regexp',
    config = function()
      require('venv-selector').setup()
    end,
    keys = {
      { ',v', '<cmd>VenvSelect<cr>' },
    },
  },
  {
    'https://github.com/apple/pkl-neovim',
    lazy = true,
    event = 'BufReadPre *.pkl',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    build = function()
      vim.cmd('TSInstall! pkl')
    end,
  },
  {
    'michaelb/sniprun',
    branch = 'master',
    build = 'sh install.sh',
    config = function()
      require('sniprun').setup()
    end,
  },
  {
    'olrtg/nvim-emmet',
    config = function()
      vim.keymap.set({ 'n', 'v' }, '<leader>xe', require('nvim-emmet').wrap_with_abbreviation)
    end,
  },

  -- Rest Client
  {
    'jellydn/hurl.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    ft = 'hurl',
    opts = {
      debug = false,
      show_notification = true,
      mode = 'split',
      auto_close = false,
      env_file = { '.env' },
    },
    keys = {
      { '<Leader>ha', ':HurlRunnerAt<CR>' },
      { '<Leader>hA', ':HurlRunner<CR>' },
      { '<Leader>hh', ':HurlRunner<CR>',  mode = 'v' },
    },
  },

  -- Misc
  { 'wsdjeg/vim-fetch' },
}
