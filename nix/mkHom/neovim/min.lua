local o = vim.o
local g = vim.g

o.clipboard = "unnamedplus"
o.expandtab = true
o.ignorecase = true
o.smartcase = true
o.termguicolors = true
o.autoread = true
o.linebreak = true
o.breakindent = true
o.showbreak = '  '
o.mouse = "a"
o.title = true
o.wrap = true
o.cursorline = false

-- Disabling slow/incorrect features
g.loaded_matchparen = 1
g.did_load_ftplugin = 1
g.lspconfig = 1 -- avoid incorrect build system
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.did_indent_on = 1
command([[let did_indent_on = 1]])
-- command([[syntax off]]) -- missing some treesitter parsers

g.cursorhold_updatetime = 500

-- zoxide
nmap('<leader>cf', [[:Zi <CR>]])
vim.api.nvim_exec([[
augroup Zoxide
autocmd!
autocmd DirChanged * call zoxide#exec(["add", v:event['cwd'] ])
augroup END
  ]], true)

command([[au BufRead,BufNewFile *.aski set filetype=ron]])
command([[au BufRead,BufNewFile flake.lock set filetype=json]])
command([[au BufRead,BufNewFile *.nix set filetype=nix]])
command([[autocmd VimEnter * :silent exec "!kill -s SIGWINCH $PPID"]])

command('augroup explorer')
command([[au BufReadCmd file://* :lua niovi.fileUrlEdit(fn.expand("<amatch>"))]])
command('augroup end')

require('nvim-autopairs').setup()
require('gitsigns').setup()
require'bufferline'.setup()

niovi.fozi = require('fzf-commands')

local configure_comments = require('kommentary.config').configure_language

configure_comments("nix", {
  single_line_comment_string = "#",
  multi_line_comment_strings = { "/*", "*/" }
})

g.nvim_tree_quit_on_open = 1
g.nvim_tree_hide_dotfiles = 1
g.nvim_tree_width_allow_resize = 1
g.nvim_tree_show_icons = { git = 0, folders = 1, files = 1 }
niovi.tri = require('nvim-tree')
niovi.tri.lib = require('nvim-tree.lib')

local actions = require 'lir.actions'
require'lir'.setup {
  show_hidden_files = false,
  devicons_enable = true,
  mappings = {
    ['l'] = actions.edit,
    ['<C-s>'] = actions.split,
    ['<C-v>'] = actions.vsplit,
    ['<C-t>'] = actions.tabedit,
    ['h'] = actions.up,
    ['q'] = actions.quit,
    ['K'] = actions.mkdir,
    ['N'] = actions.newfile,
    ['R'] = actions.rename,
    ['@'] = actions.cd,
    ['Y'] = actions.yank_path,
    ['.'] = actions.toggle_show_hidden
  }
}

local previewers = require 'telescope.previewers'

require('telescope').setup {
  extensions = {},
  defaults = {
    file_previewer = previewers.vim_buffer_cat.new,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    qflist_previewer = previewers.vim_buffer_qflist.new,
    width = 0.95,
    preview_cutoff = 120,
    results_height = 1,
    results_width = 1
  }
};

niovi.telescope = require('telescope.builtin')

-- start('completion')
command('set shortmess+=c')
o.completeopt = [[noinsert,menuone,noselect]]
command([[autocmd BufEnter * lua require'completion'.on_attach()]])
g.completion_confirm_key = [[\<C-J>]]
g.completion_enable_auto_popup = 1
g.completion_timer_cycle = 120
g.completion_enable_auto_paren = 1
g.completion_enable_snippet = 'UltiSnips'
g.completion_auto_change_source = 1
g.completion_chain_complete_list = {
  default = {
    default = {
      { complete_items = { "lsp" } }, { complete_items = { "snippet" } },
      { complete_items = { 'buffers' } },
      { complete_items = { "path" }, triggered_only = { '/' } }

    },
    comment = { { complete_items = { 'buffers' } } },
    string = {
      { complete_items = { 'buffers' } },
      { complete_items = { "path" }, triggered_only = { '/' } }
    }
  }
}
-- end('completion')
-- start('legacy')
g.rooter_silent_chdir = true

g.vim_markdown_folding_disabled = true
g.vim_markdown_follow_anchor = true
g.vim_markdown_fenced_languages = {
  'c++=cpp', 'rust', 'viml=vim', 'bash=sh', 'ini=dosini', 'c'
}

g.indent_guides_guide_size = true
g.indent_guides_enable_on_vim_startup = true
g.indent_guides_exclude_filetypes = {
  'help', 'w3m', 'man', 'markdown', 'skim', 'neoterm', 'vista', 'netrw', 'defx',
  'toggleterm'
}

g.fzf_buffers_jump = true
g.fzf_action = {
  ['ctrl-t'] = 'tab split',
  ['ctrl-x'] = 'split',
  ['ctrl-v'] = 'vsplit'
}
g.fzf_layout = { down = '~61%' }
g.fzf_colors = {
  fg = { 'fg', 'Normal' },
  bg = { 'bg', 'Normal' },
  hl = { 'fg', 'Comment' },
  ['fg+'] = { 'fg', 'CursorLine', 'CursorColumn', 'Normal' },
  ['bg+'] = { 'bg', 'CursorLine', 'CursorColumn' },
  ['hl+'] = { 'fg', 'Statement' },
  info = { 'fg', 'PreProc' },
  border = { 'fg', 'Ignore' },
  prompt = { 'fg', 'Conditional' },
  pointer = { 'fg', 'Exception' },
  marker = { 'fg', 'Keyword' },
  spinner = { 'fg', 'Label' },
  header = { 'fg', 'Comment' }
}
-- end('legacy')
