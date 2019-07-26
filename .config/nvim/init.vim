let mapleader=" "

tnoremap <Esc> <C-\><C-n>
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
noremap <silent> k gk
noremap <silent> j gj
noremap <silent> 0 g0
noremap <silent> $ g$
map Y y$
map Q <Nop>

" Do not load netrw
let g:loaded_netrwPlugin=1
" Do not load matchit, use matchup plugin
let g:loaded_matchit=1

set noswapfile
set nobackup
set nowritebackup

set foldmethod=syntax
set foldlevelstart=99

" Enable the mouse
set mouse=a

" Hybrid line numbers
set number relativenumber

" Wait 100 ms, default is 4 s
set updatetime=100

" Indentation
set tabstop=2
set expandtab
set shiftwidth=2

" Searching ignores case
set ignorecase smartcase

" Show changes incrementally
set inccommand="nosplit"

" Show cursor line highlight
set cursorline

" Don't clear background, needed for Kitty.
let &t_ut=''

" Use conceal for pretty characters
set conceallevel=2

" Change color theme
set termguicolors
let g:gruvbox_italic=1
let g:gruvbox_sign_column='bg0'
colorscheme gruvbox
set background=light
let g:gruvbox_contrast_light="medium"
hi! Operator guifg=NONE guibg=NONE
hi link gitmessengerPopupNormal Pmenu
hi gitmessengerEndOfBuffer term=None guifg=None guibg=None ctermfg=None ctermbg=None

" Lightline
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ], [ 'cocstatus', 'percent' ] ]  
      \ },
      \ 'inactive': {
      \   'left': [ [ 'filename' ] ],
      \   'right': [ [ 'lineinfo' ], [ 'percent' ] ]
			\ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \   'filename': 'LightlineFilename',
      \ },
      \ }

function! LightlineFilename()
  let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
  let modified = &modified ? ' +' : ''
  return filename . modified
endfunction

" FZF
nnoremap <leader>p :GFiles<CR>
nnoremap <leader>P :Files<CR>
nnoremap <leader>m :History<CR>
nnoremap <leader>b :Buffers<CR>

" Comfortable motion
let g:comfortable_motion_scroll_down_key="j"
let g:comfortable_motion_scroll_up_key="k"
let g:comfortable_motion_no_default_key_mappings=1
let g:comfortable_motion_impulse_multiplier=1
nnoremap <silent> <C-d> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 2)<CR>
nnoremap <silent> <C-u> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -2)<CR>
nnoremap <silent> <C-f> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 4)<CR>
nnoremap <silent> <C-b> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -4)<CR>

" Startify
let g:startify_change_to_vcs_root=1
let g:startify_change_to_dir=1
let g:startify_fortune_use_unicode=1
let g:startify_custom_header='startify#fortune#boxed()'

function! s:list_projects() abort
  return map(finddir('.git', $HOME . '/projects/**2', -1),
        \ {_, dir -> {'line': fnamemodify(dir, ':h:s?.*projects/??'), 'cmd': 'cd ' . fnamemodify(dir, ':h') . ' | Defx .'}})
endfunction

let g:startify_lists=[
      \ {'header': ['   MRU'], 'type': 'files'},
      \ {'header': ['   Projects'], 'type': function('s:list_projects'), 'indices': map(range(1, 100), { _ -> 'p' . string(v:val)})},
      \ {'header': ['   Bookmarks'], 'type': 'bookmarks'}
      \ ]

let g:startify_bookmarks=[
      \ {'c': '~/.config/nvim/init.vim'},
      \ {'n': '~/.config/nixpkgs/home.nix'}
      \ ]

let g:startify_skiplist=[
      \ '/nix/store/*'
      \ ]

" ALE
let g:ale_linters_explicit=1
let g:ale_linters={ 
      \ 'idris': ['idris'],
      \ 'lsl' : ['lslint']
      \ }

" Defx
augroup defxrc
  autocmd!
  autocmd FileType defx call s:defx_mappings()   
  autocmd VimEnter * call s:setup_defx()
augroup END

nnoremap <silent><leader>n :call <sid>defx_open({ 'split': v:true })<CR>
nnoremap <silent><leader>hf :call <sid>defx_open({ 'split': v:true, 'find_current_file': v:true })<CR>

function! s:setup_defx() abort
  call defx#custom#column('filename', {
        \ 'min_width': 80,
        \ 'max_width': 80,
        \ })

  call defx#custom#column('mark', {
        \ 'directory_icon': '',
        \ 'root_icon': ''
        \ })

  call defx#custom#option('_', {
        \ 'columns': 'git:icons:filename:size:time',
        \ })

  call s:defx_open({ 'dir': expand('<afile>') })
endfunction

function! s:defx_open(...) abort
  let l:opts=get(a:, 1, {})
  let l:path=get(l:opts, 'dir', getcwd())

  if !isdirectory(l:path) || &filetype ==? 'defx'
    return
  endif

  let l:args='-winwidth=40 -direction=topleft'
  let l:is_opened=bufwinnr('defx') > 0

  if has_key(l:opts, 'split')
    let l:args .= ' -split=vertical'
  endif

  if has_key(l:opts, 'find_current_file')
    if &filetype ==? 'defx'
      return
    endif
    call execute(printf('Defx %s -search=%s %s', l:args, expand('%:p'), expand('%:p:h')))
  else
    call execute(printf('Defx -toggle %s %s', l:args, l:path))
    if l:is_opened
      call execute('wincmd p')
    endif
  endif

  return execute("norm!\<C-w>=")
endfunction

function! s:defx_context_menu() abort
  let l:actions=['new_multiple_files', 'rename', 'copy', 'move', 'paste', 'remove']
  let l:selection=confirm('Action?', "&New file/directory\n&Rename\n&Copy\n&Move\n&Paste\n&Delete")
  silent exe 'redraw'

  if l:selection > 0
    return feedkeys(defx#do_action(l:actions[l:selection - 1]))
  endif
endfunction

function! s:defx_mappings() abort
  nnoremap <silent><buffer>m :call <sid>defx_context_menu()<CR>
  nnoremap <silent><buffer><expr> o defx#do_action('drop')
  nnoremap <silent><buffer><expr> <CR> defx#do_action('drop')
  nnoremap <silent><buffer><expr> <2-LeftMouse> defx#do_action('drop')
  nnoremap <silent><buffer><expr> s defx#do_action('open', 'botright vsplit')
  nnoremap <silent><buffer><expr> S defx#do_action('open', 'botright split')
  nnoremap <silent><buffer><expr> R defx#do_action('redraw')
  nnoremap <silent><buffer><expr> u defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> cd defx#do_action('change_vim_cwd')
  nnoremap <silent><buffer><expr> H defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> <Space> defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> j line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> yy defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> q defx#do_action('quit')
  nnoremap <silent><buffer><expr> gh defx#do_action('cd', [getcwd()])
  hi link Defx_mark_root Directory
  hi link Defx_mark_directory Directory
endfunction

" CoC setup
set hidden
set updatetime=300
set shortmess+=c
" set cmdheight=2
" set signcolumn=yes

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col=col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` for navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

