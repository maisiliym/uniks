vim.api.nvim_exec([[
augroup FormatAutogroup
  autocmd!
  autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
  autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
  autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
augroup END
  ]], true)

require('lspfuzzy').setup {}

require'colorizer'.setup {
  'css',
  'javascript',
  'lua',
  html = { mode = 'foreground' }
}

require('formatter').setup({
  logging = true,
  filetype = {
    lua = {
      function() return { exe = "lua-format", args = { "" }, stdin = true } end
    },
    rust = {
      function()
        return {
          exe = "rustfmt",
          args = { "--emit=stdout", "--edition 2018" },
          stdin = true
        }
      end
    },
    nix = {
      function()
        return { exe = "nixpkgs-fmt", args = { "" }, stdin = true }
      end
    }
  }
})

vim.api.nvim_exec([[
augroup FormatAutogroup
autocmd!
autocmd BufWritePost *.nix,*.rs,*.lua FormatWrite
augroup END
  ]], true)

vim.g.vista_echo_cursor_strategy = 'floating_win'
vim.g.vista_cursor_delay = 1500
vim.g.vista_keep_fzf_colors = 1
vim.g.vista_executive_for = { rust = 'nvim_lsp' }
