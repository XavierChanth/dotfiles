if executable('fd') && executable('fzf')
    set findfunc=FuzzyFindFunc
endif

"nnoremap <leader><space> :find<space>
"nnoremap <leader>sf :find<space>
"nnoremap <leader>sF :vert find<space>
"nnoremap <leader>j :b<space>
command! -nargs=+ -complete=file_in_path Findqf call FdSetQuickfix(<f-args>)

function! FuzzyFindFunc(cmdarg, cmdcomplete)
    return systemlist("fd . \| fzf --filter='" 
        \.. a:cmdarg .. "'")
endfunction


function! FdSetQuickfix(...) abort
    let fdresults = systemlist("fd -t f" .. join(a:000, " "))
    if v:shell_error
        echoerr "Fd error: " .. fdresults[0]
        return
    endif
    call setqflist(map(fdresults, {_, val -> 
        \{'filename': val, 'lnum': 1, 'text': val}}))
    copen
endfunction

