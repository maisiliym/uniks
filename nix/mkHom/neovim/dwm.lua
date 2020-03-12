vim.g.dwm_map_keys = false
vim.g.dwm_master_pane_width = "55%"
nmap('<C-h>', '<Plug>DWMShrinkMaster')
nmap('<leader><CR>', '<Plug>DWMFocus')
nmap("<leader>q", ":bp<bar>sp<bar>bn<bar>bd<CR>")
nmap('<Leader>,', '<Plug>DWMRotateCounterclockwise')
nmap('<Leader>.', '<Plug>DWMRotateClockwise')
nmap('<C-C>', '<Plug>DWMClose')
nmap('<leader>H', ':bprevious<CR>')
nmap('<leader>L', ':bnext<CR>')
