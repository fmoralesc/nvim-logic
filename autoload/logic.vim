let s:abbrevs = []

function! s:abbrev_by_mode(abbr, latex, unicode)
    call add(s:abbrevs, a:abbr)
    exe 'inoreabbrev <expr> <buffer> '.a:abbr.
		\" g:logic#conf.mode == 'latex'? '".a:latex."' : '".
		\a:unicode."'"
endfunction

function! logic#ssabbr(line, col)
    let rev_cline_tpos = split(a:line[:a:col], '', '')
    if len(rev_cline_tpos) > 0
	echom string(rev_cline_tpos)
	for abbr in s:abbrevs
	    if rev_cline_tpos[-1] == abbr
		return 1
	    endif
	endfor
    endif
    return 0
endfunction

function! logic#enable()
    inoremap <expr> <buffer> <space> logic#ssabbr(getline('.'), col('.'))? "<C-]>" : "<space>"
    call s:abbrev_by_mode('E', '\exists ', '∃')
    call s:abbrev_by_mode('A', '\forall ', '∀')
    call s:abbrev_by_mode('in', '\in ', '∈ ')
    call s:abbrev_by_mode('>', '\rightarrow ', '→ ')
    call s:abbrev_by_mode('-', '\neg ', '¬')
    call s:abbrev_by_mode('\|', '\vee ', '∨ ')
    call s:abbrev_by_mode('.', '\wedge ', '∧ ')
    call s:abbrev_by_mode('Nec', '\Box ', '◻')
    call s:abbrev_by_mode('Pos', '\Diamond ', '◇')
    call s:abbrev_by_mode('Ss', '\vdash ', '⊦')
    call s:abbrev_by_mode('Cont', '\bot ', '⊥')
    inoreabbrev <buffer> ( ()<Left>
    inoreabbrev <buffer> [ []<Left>
    inoreabbrev <buffer> \{ \{\}<Left><Left>
    let b:logic_enabled = 1
endfunction

function! logic#disable()
    silent! iunmap <buffer> <space>
    silent! iunabbrev <buffer> E
    silent! iunabbrev <buffer> A
    silent! iunabbrev <buffer> in
    silent! iunabbrev <buffer> >
    silent! iunabbrev <buffer> -
    silent! iunabbrev <buffer> .
    silent! iunabbrev <buffer> \|
    silent! iunabbrev <buffer> Nec
    silent! iunabbrev <buffer> Pos
    exe "silent! iunabbrev <buffer> ("
    silent! iunabbrev <buffer> [
    exe "silent! iunabbrev <buffer> \\{"
    silent! iunabbrev <buffer> As
    silent! iunabbrev <buffer> Cont
    let b:logic_enabled = 0
endfunction

function! logic#toggle()
    if !exists('b:logic_enabled')
	let b:logic_enabled = 0
    endif
    if b:logic_enabled
	call logic#disable()
    else
	call logic#enable()
    endif
endfunction

function! logic#toggle_mode()
    if g:logic#conf.mode == 'latex'
	let g:logic#conf.mode = 'unicode'
    else
	let g:logic#conf.mode = 'latex'
    endif
endfunction
