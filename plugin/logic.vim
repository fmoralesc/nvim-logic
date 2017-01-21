" logic.vim: A plugin for writing logic

let s:default_conf = {
	    \'mode' : 'latex',
	    \'default_maps': 1,
	    \'default_cmd': 0
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

if g:logic#conf.default_cmd
    command! Logic call logic#toggle()
endif
nnoremap <Plug>(logic-toggle) :call logic#toggle()<cr>
inoremap <Plug>(logic-toggle) <C-O>:call logic#toggle()<cr>
nnoremap <Plug>(logic-mode-toggle) :call logic#toggle_mode()<cr>
inoremap <Plug>(logic-mode-toggle) <C-O>:call logic#toggle_mode()<cr>
if g:logic#conf.default_maps
    nnoremap <leader>lg <Plug>(logic-toggle)
    inoremap <leader>lg <Plug>(logic-toggle)
    nnoremap <leader>lm <Plug>(logic-mode-toggle)
    inoremap <leader>lm <Plug>(logic-mode-toggle)
endif
