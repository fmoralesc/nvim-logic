let s:abbrevs = []

function! s:abbrev_by_mode(abbr, latex, unicode)
    call add(s:abbrevs, a:abbr)
    exe 'inoreabbrev <expr> <buffer> '.a:abbr.
		\" g:logic#conf.mode == 'latex'? '".a:latex."' : '".
		\a:unicode."'"
endfunction

" should space abbreviate?
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
    call s:abbrev_by_mode('N>', '\boxright', '')
    inoreabbrev <buffer> ( ()<Left>
    inoreabbrev <buffer> [ []<Left>
    inoreabbrev <buffer> \{ \{\}<Left><Left>
    let b:logic.enabled = 1
endfunction

function! logic#disable()
    silent! iunmap <buffer> <space>
    for abbr in s:abbrevs
	exe "silent! iunabbrev <buffer> ".abbr
    endfor
    exe "silent! iunabbrev <buffer> ("
    silent! iunabbrev <buffer> [
    exe "silent! iunabbrev <buffer> \\{"
    let s:abbrevs = []
    let b:logic.enabled = 0
endfunction

function! logic#togglewatcher(d,k,z)
    if a:z.new == 1
	if exists('g:worldslice#sigils')
	    let g:worldslice#sigils.logic = '%#SLBoolean#l'
	endif
    else
	if exists('g:worldslice#sigils')
	    call remove(g:worldslice#sigils, 'logic')
	endif
    endif
endfunction

function! logic#toggle()
    if !exists('b:logic')
	let b:logic = {'enabled': 0}
	call dictwatcheradd(b:logic, 'enabled', 'logic#togglewatcher')
    endif
    if b:logic.enabled
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
