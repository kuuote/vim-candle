# vim-candle

Any candidates listing engine for vim/nvim built on [yaegi](https://github.com/containous/yaegi).

You can create a custom source with golang.


# Status

- Works well
- Not documented
- APIs aren't stable
- Should build binary by yourself

# Requirements

- latest vim or latest nvim



# Setting

```viml

augroup vimrc
 autocmd!
augroup END

nnoremap <silent>mru_file :<C-u>call candle#start({
\   'source': 'mru_file',
\   'layout': 'split',
\   'params': {
\     'filepath': g:candle#source#mru_file#filepath,
\     'ignore_patterns': ['.git/', 'node_modules'],
\   }
\ })<CR>
nnoremap <silent>file :<C-u>call candle#start({
\   'source': 'file',
\   'layout': 'split',
\   'params': {
\     'root_path': 'path to root dir',
\     'ignore_patterns': ['.git/', 'node_modules'],
\   }
\ })<CR>
nnoremap <silent>grep :<C-u>call candle#start({
\   'source': 'grep',
\   'layout': 'split',
\   'params': {
\     'root_path': 'path to root dir',
\     'pattern': input('PATTERN: '),
\   }
\ })<CR>
nnoremap <silent>menu :<C-u>call candle#start({
\   'source': 'item',
\   'layout': 'split',
\   'actions': {
\     'default': { candle -> execute(candle.get_cursor_item().execute) }
\   },
\   'params': {
\     'items': [{
\       'id': 1,
\       'title': 'PlugUpdate',
\       'execute': 'PlugUpdate'
\     }, {
\       'id': 2,
\       'title': 'Open .vimrc',
\       'execute': 'vsplit $MYVIMRC'
\     }],
\   }
\ })<CR>

autocmd vimrc User candle#initialize call s:on_candle_initialize()
function! s:on_candle_initialize()
  let g:candle.debug = '/tmp/candle.log'
endfunction

autocmd vimrc User candle#start call s:on_candle_start()
function! s:on_candle_start()
  nnoremap <silent><buffer> k     :<C-u>call candle#mapping#cursor_move(-1)<CR>
  nnoremap <silent><buffer> j     :<C-u>call candle#mapping#cursor_move(1)<CR>
  nnoremap <silent><buffer> K     :<C-u>call candle#mapping#cursor_move(-10)<CR>
  nnoremap <silent><buffer> J     :<C-u>call candle#mapping#cursor_move(10)<CR>
  nnoremap <silent><buffer> gg    :<C-u>call candle#mapping#cursor_top()<CR>
  nnoremap <silent><buffer> G     :<C-u>call candle#mapping#cursor_bottom()<CR>
  nnoremap <silent><buffer> -     :<C-u>call candle#mapping#toggle_select()<CR>
  nnoremap <silent><buffer> *     :<C-u>call candle#mapping#toggle_select_all()<CR>
  nnoremap <silent><buffer> i     :<C-u>call candle#mapping#input_open()<CR>
  nnoremap <silent><buffer> a     :<C-u>call candle#mapping#input_open()<CR>
  nnoremap <silent><buffer> <Tab> :<C-u>call candle#mapping#choose_action()<CR>

  nnoremap <silent><buffer> <CR>  :<C-u>call candle#mapping#action('default')<CR>
  nnoremap <silent><buffer> s     :<C-u>call candle#mapping#action('split')<CR>
  nnoremap <silent><buffer> v     :<C-u>call candle#mapping#action('vsplit')<CR>
  nnoremap <silent><buffer> d     :<C-u>call candle#mapping#action('delete')<CR>
endfunction

autocmd vimrc User candle#input#start call s:on_candle_input_start()
function! s:on_candle_input_start()
  let b:lexima_disabled = v:true
  inoremap <silent><buffer> <Tab> <Esc>:<C-u>quit \| call candle#mapping#choose_action()<CR>
  inoremap <silent><buffer> <CR>  <Esc>:<C-u>quit \| call candle#mapping#action('default')<CR>
  inoremap <silent><buffer> <Esc> <Esc>:<C-u>call candle#mapping#input_close()<CR>
  inoremap <silent><buffer> <C-k> <Esc>:<C-u>call candle#mapping#cursor_move(-1)<CR>a
  inoremap <silent><buffer> <C-j> <Esc>:<C-u>call candle#mapping#cursor_move(1)<CR>a
endfunction
```

If you want to another mapping and couldn't it, feel free to create issue.

# Concept

### High performance
fuzzy/substring/regex filter written in golang.


### Extensible
Can create a source with golang.


### Works on vim/neovim both
Use `job` API only.


### Works any platforms
Automatic download suitable binary.


