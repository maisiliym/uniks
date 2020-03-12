function! ContentRg(bang)
  let opts = {}
  let opts.options =  '--delimiter=: --nth=2..'
  let opts.name =  'rg-content'
  let rg_cmd = 'rg --line-number --color always ^ '
  let with_column = 0
  call fzf#vim#grep(rg_cmd, with_column, opts, a:bang)
endfunction

" Typed Rg
function! TypedRg(bang)
  let opts = {}
  let opts.options =  '--delimiter=: --nth=2..'
  let opts.name = 'typed-rg'
  let rg_cmd = 'rg --line-number --color always ^ --type ' . &filetype
  let with_column = 0
  call fzf#vim#grep(rg_cmd, with_column, opts, a:bang)
endfunction

" TODO - shorten displeid path
function! ParentRg(bang)
  let opts = {}
  let opts.options =  '--delimiter=: --nth=2..'
  let opts.name = 'parent-rg'
  let parent = expand('%:p:h')
  let rg_cmd = 'rg --line-number --color always ^ ' . parent
  let with_column = 0
  call fzf#vim#grep(rg_cmd, with_column, opts, a:bang)
endfunction

" - Commands
command! -bar -bang ContentRg call ContentRg(<bang>0)
command! -bar -bang TypedRg call TypedRg(<bang>0)
command! -bar -bang ParentRg call ParentRg(<bang>0)

vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>
