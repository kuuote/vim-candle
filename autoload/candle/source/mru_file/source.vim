let s:dirname = expand('<sfile>:p:h')

let g:candle#source#mru_file#filepath = expand('~/.candle_mru_file')

let s:state = {
      \   'recent': '',
      \ }

"
" candle#source#mru_file#source#definition
"
function! candle#source#mru_file#source#definition() abort
  return {
        \   'name': 'mru_file',
        \   'script': s:dirname . '/source.go',
        \   'get_options': { -> s:get_options() },
        \   'get_actions': { -> s:get_actions() },
        \ }
endfunction

"
" get_options
"
function! s:get_options() abort
  return [{
        \   'name': '--filepath',
        \   'description': '',
        \   'extra': {
        \     'default': g:candle#source#mru_file#filepath
        \   }
        \ }]
endfunction

"
" get_actions
"
function! s:get_actions() abort
  return {
        \   'default': function('s:action_open'),
        \   'open': function('s:action_open'),
        \   'split': function('s:action_split'),
        \   'vsplit': function('s:action_vsplit'),
        \ }
endfunction

"
" action_open
"
function! s:action_open(candle) abort
  let l:item = a:candle.get_cursor_item()
  if empty(l:item)
    return
  endif

  call win_gotoid(a:candle.state.prev_winid)
  execute printf('edit %s', l:item.path)
  if has_key(l:item, 'lnum')
    call cursor([l:item.lnum, get(l:item, 'col', 1)])
  endif
endfunction

"
" action_split
"
function! s:action_split(candle) abort
  let l:item = a:candle.get_cursor_item()
  if empty(l:item)
    return
  endif

  call win_gotoid(a:candle.state.prev_winid)
  execute printf('split %s', l:item.path)
  if has_key(l:item, 'lnum')
    call cursor([l:item.lnum, get(l:item, 'col', 1)])
  endif
endfunction

"
" action_vsplit
"
function! s:action_vsplit(candle) abort
  let l:item = a:candle.get_cursor_item()
  if empty(l:item)
    return
  endif

  call win_gotoid(a:candle.state.prev_winid)
  execute printf('vsplit %s', l:item.path)
  if has_key(l:item, 'lnum')
    call cursor([l:item.lnum, get(l:item, 'col', 1)])
  endif
endfunction


"
" events.
"
augroup candle#source#mru_file#source
  autocmd!
  autocmd BufWinEnter,BufRead,BufNewFile * call <SID>on_touch()
augroup END

"
" on_touch
"
function! s:on_touch() abort
  if empty(g:candle#source#mru_file#filepath)
    return
  endif

  let l:filepath = fnamemodify(bufname('%'), ':p')

  " skip same to recently added
  if s:state.recent == l:filepath
    return
  endif

  " skip not file
  if !filereadable(l:filepath)
    return
  endif

  " add mru entry
  call writefile([l:filepath], g:candle#source#mru_file#filepath, 'a')
  let s:state.recent = l:filepath
endfunction

