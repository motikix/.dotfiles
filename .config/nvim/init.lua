-- locals
local config = require('config')
local opts = config.opts
local opts_noremap = config.opts_noremap

-- Leader
vim.g.mapleader = ' '

-- Encoding
vim.o.enc = 'utf8'
vim.o.fenc = 'utf8'
vim.o.fencs = 'utf8,ms932,cp932,sjis,eucjp-ms,eucjp,latin1'
vim.o.ffs = 'unix,dos,mac'

-- Fixed width
vim.o.ambiwidth = 'single'

-- Don't use meta files
vim.o.backup = false
vim.o.swapfile = false

-- Enabled open other file when the file has not saved
vim.o.hidden = true

-- Reload when opened file has changed
vim.o.autoread = true

-- Show command
vim.o.showcmd = true

-- Don't show Splash
vim.o.shortmess = vim.o.shortmess .. 'I'

-- Show line number
vim.wo.number = true
vim.wo.relativenumber = true

-- One character ahead of the end of the line
vim.o.virtualedit = 'onemore'

-- Don't flash screen
vim.o.visualbell = false

-- Move to corresponding parenthesis
vim.o.showmatch = true
vim.o.matchtime = 1

-- Show to the end
vim.o.display = 'lastline'

-- Statuslinle
vim.o.laststatus = 3
vim.o.cmdheight = 0

-- Indent
vim.o.tabstop = 2
vim.o.softtabstop = -1
vim.o.shiftwidth = 0
vim.o.smarttab = true
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true

-- Conceal
vim.o.conceallevel = 0
vim.o.concealcursor = nil

-- Clipboard
vim.o.clipboard = 'unnamed,unnamedplus'
if vim.fn.has('wsl') == 1 then
  vim.g.clipboard = {
    name = 'clip',
    copy = {
      ['+'] = 'win32yank.exe -i --crlf',
      ['*'] = 'win32yank.exe -i --crlf',
    },
    paste = {
      ['+'] = 'win32yank.exe -o --lf',
      ['*'] = 'win32yank.exe -o --lf',
    },
    cache_enabled = 0,
  }
end

-- Transparency
vim.o.winblend = 10
vim.o.pumblend = 10

-- Always show signcolumn
vim.o.signcolumn = 'yes'

-- No wrap word
vim.o.wrap = false
vim.o.whichwrap = 'b,s,h,l,<,>,[,],~'

-- Split window direction
vim.o.splitbelow = true
vim.o.splitright = true

-- new empty window
vim.api.nvim_set_keymap('n', '<C-w>N', ':vnew<Cr>', opts)

-- Cursor move for insert / command mode
for _, mode in pairs({ 'i', 'c' }) do
  vim.api.nvim_set_keymap(mode, '<C-a>', '<Home>', opts_noremap)
  vim.api.nvim_set_keymap(mode, '<C-e>', '<End>', opts_noremap)
  vim.api.nvim_set_keymap(mode, '<C-b>', '<Left>', opts_noremap)
  vim.api.nvim_set_keymap(mode, '<C-f>', '<Right>', opts_noremap)
  vim.api.nvim_set_keymap(mode, '<C-k>', '<Del>', opts_noremap)
end

-- Buffer
vim.api.nvim_set_keymap('n', '<Leader>bd', ':bwipeout<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>bad', ':bufdo :bwipeout<CR>', opts)

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.wrapscan = true
vim.o.hlsearch = true

-- Diagnostic
vim.api.nvim_set_keymap('n', '[d', '<Cmd>lua vim.diagnostic.goto_prev({ float = false })<Cr>', opts)
vim.api.nvim_set_keymap('n', ']d', '<Cmd>lua vim.diagnostic.goto_next({ float = false })<Cr>', opts)

-- Diff
vim.o.diffopt = 'internal,vertical,filler,algorithm:histogram,indent-heuristic'

-- Grep
if vim.fn.executable('rg') == 1 then
  vim.o.grepprg = 'rg --vimgrep'
  vim.o.grepformat = '%f:%l:%c:%m'
end
vim.api.nvim_create_user_command('Grep', function(opts)
  vim.cmd('silent grep!' .. ' ' .. opts.args)
  vim.cmd('copen')
end, { nargs = '*', complete = 'file' })

-- Nvim clients
vim.g.python_host_prog = vim.fn.exepath('/usr/bin/python2')
vim.g.python3_host_prog = vim.fn.exepath('/usr/bin/python3')

-- Colors
vim.o.termguicolors = true
vim.o.winblend = 0
vim.o.pumblend = 0

-- Terminal
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', opts)

-- Yank current file path & line
vim.api.nvim_create_user_command('CopyPath', function()
  vim.cmd('let @+ = expand("%:p")')
end, {})
vim.api.nvim_create_user_command('CopyPath2', function()
  vim.cmd('let @+ = join([expand("%:p"), line(".")], ":")')
end, {})
vim.api.nvim_set_keymap('n', 'yp', ':CopyPath<CR>', opts)
vim.api.nvim_set_keymap('n', 'yP', ':CopyPath2<CR>', opts)

-- Formatter
vim.api.nvim_create_user_command('ToggleFormat', function(args)
  if args.bang then
    -- FormatDisable! と同等 (buffer local)
    vim.b.disable_autoformat = not vim.b.disable_autoformat
    print(vim.b.disable_autoformat and 'Buffer autoformat disabled' or 'Buffer autoformat enabled')
  else
    -- FormatDisable/FormatEnable と同等 (global)
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    print(vim.g.disable_autoformat and 'Global autoformat disabled' or 'Global autoformat enabled')
  end
end, {
  desc = 'Toggle autoformat-on-save (with bang for buffer local)',
  bang = true,
})
vim.api.nvim_set_keymap('n', '<Leader>tf', ':ToggleFormat<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>tF', ':ToggleFormat!<CR>', opts)

require('bootstrap')
