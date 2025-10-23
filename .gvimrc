set guioptions-=T
set guifont=Moralerspace\ Radon\ HW:h16

set iminsert=2

nnoremap <A-=> :call AdjustFontSize(1)<CR>
nnoremap <A--> :call AdjustFontSize(-1)<CR>

function! AdjustFontSize(delta)
  let l:font = &guifont
  if l:font =~ '\v\d+$'
    let l:size = matchstr(l:font, '\v\d+$')
    let l:newsize = l:size + a:delta
    if l:newsize < 6
      let l:newsize = 6
    endif
    let &guifont = substitute(l:font, '\v\d+$', l:newsize, '')
    echo "Font size: " . l:newsize
  endif
endfunction
