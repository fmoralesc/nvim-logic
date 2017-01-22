" logic.vim:
" A plugin for writing logic

let s:default_conf = {
	    \'mode' : 'latex',
	    \'cmd' : 1,
	    \'default_maps': 1,
	    \}

function! s:ensure_default(key)
    if !has_key(g:logic#conf, a:key)
	let g:logic#conf[a:key] = s:default_conf[a:key]
    endif
endfunction

if !exists('g:logic#conf')
    let g:logic#conf = s:default_conf
else
    for k in keys(s:default_conf)
        call s:ensure_default(k)
    endfor
endif

if g:logic#conf.cmd
    command! Logic call logic#toggle()
endif

if g:logic#conf.default_maps
    nnoremap <silent> <leader>lg :call logic#toggle()<cr>
    inoremap <silent> <leader>lg <C-O>:call logic#toggle()<cr>
    nnoremap <silent> <leader>lm :call logic#toggle_mode()<cr>
    inoremap <silent> <leader>lm <C-O>:call logic#toggle_mode()<cr>
endif
