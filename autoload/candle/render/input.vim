let s:state = {
\   'item_count': -1
\ }

"
" candle#render#input#open
"
function! candle#render#input#open(candle) abort
  doautocmd User candle#input#start

  let s:state.item_count = len(a:candle.state.items)

  redrawstatus
  let s:timer_id = timer_start(60, { -> s:on_query_change() }, { 'repeat': -1 })
  call input('$ ', a:candle.state.query)
  call timer_stop(s:timer_id)
endfunction

"
" s:on_query_change
"
function! s:on_query_change() abort
  if empty(getbufvar('%', 'candle', {}))
    return
  endif

  if b:candle.state.query !=# getcmdline()
    call b:candle.top()
    call b:candle.query(getcmdline())
    redrawstatus
  elseif s:state.item_count != len(b:candle.state.items)
    redrawstatus
  endif

  let s:state.item_count = len(b:candle.state.items)
endfunction

