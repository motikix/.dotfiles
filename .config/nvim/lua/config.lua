local M = {}

-- Sign
M.sign = {
  hint = '',
  info = '',
  warn = '',
  error = '',
}

-- Keymap Options
M.opts = { noremap = true, silent = true }
M.opts_noremap = { noremap = true }
M.opts_silent = { silent = true }

-- Cmp Kinds
M.cmp_kinds = {
  Text = ' ',
  String = ' ',
  Method = '󰆧 ',
  Function = '󰊕 ',
  FunctionBuiltin = '󰊕 ',
  Constructor = ' ',
  Field = '󰇽 ',
  Variable = '󰂡 ',
  Class = '󰠱 ',
  Interface = ' ',
  Module = ' ',
  Property = '󰜢 ',
  Unit = ' ',
  Value = '󰎠 ',
  Enum = ' ',
  Keyword = '󰌋 ',
  Snippet = ' ',
  Color = '󰏘 ',
  File = '󰈙 ',
  Reference = ' ',
  Folder = '󰉋 ',
  EnumMember = ' ',
  Constant = '󰏿 ',
  Struct = ' ',
  Event = ' ',
  Operator = '󰆕 ',
  TypeParameter = '󰅲 ',
  Codeium = ' ',
}

return M
