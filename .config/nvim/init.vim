" Changes to defaults
let mapleader=' '
set mouse=a " the mouse can be used
set expandtab " the tab keys inserts spaces
set shiftwidth=2
set tabstop=2
set fillchars=vert:\│ " makes vertical lines a pretty unbroken line
set noshowmode
set wildmode=list:longest,full

set ignorecase " /, ? and friends are case insensitive
set smartcase " the above setting is toggled of if the search word contains upper-case caracters

set splitbelow " create new splits below and to the right
set splitright

" Install minpac if not installed
let s:do_update = 0
let s:rc_path = fnamemodify(expand('<sfile>'), ':h')
let s:minpac = expand(s:rc_path . '/pack/minpac/opt/minpac')
if !isdirectory(glob(s:minpac))
  silent execute '!git clone https://github.com/k-takata/minpac' s:minpac
  let s:do_update = 1
endif

if exists('*minpac#init')
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  " Visuals/information
  call minpac#add('morhetz/gruvbox')
  call minpac#add('machakann/vim-highlightedyank')
  call minpac#add('yggdroot/indentline')
  call minpac#add('mhinz/vim-startify')
  call minpac#add('itchyny/lightline.vim')
  call minpac#add('Shougo/echodoc.vim')
  call minpac#add('tpope/vim-fugitive')
  call minpac#add('ryanoasis/vim-devicons')

  " Navigation
  call minpac#add('junegunn/fzf.vim')
  call minpac#add('airblade/vim-rooter')
  call minpac#add('scrooloose/nerdtree')
  call minpac#add('Xuyuanp/nerdtree-git-plugin')
  call minpac#add('yuttie/comfortable-motion.vim')
  call minpac#add('t9md/vim-choosewin')

  " Editing
  call minpac#add('Shougo/deoplete.nvim', {'type': 'opt'})
  call minpac#add('machakann/vim-sandwich')
  call minpac#add('tpope/vim-commentary')
  call minpac#add('tommcdo/vim-exchange')
  call minpac#add('SirVer/ultisnips')
  call minpac#add('mbbill/undotree')
  call minpac#add('jiangmiao/auto-pairs')

  " Language
  call minpac#add('w0rp/ale')
  call minpac#add('ntpeters/vim-better-whitespace')
  call minpac#add('janko-m/vim-test')

  " Javascript
  call minpac#add('othree/yajs.vim')
  call minpac#add('pangloss/vim-javascript')

  " JSON
  call minpac#add('elzr/vim-json')

  " Fish-Shell
  call minpac#add('dag/vim-fish')

  " Markdown
  call minpac#add('godlygeek/tabular')
  call minpac#add('plasticboy/vim-markdown')
endif

" Colorscheme
set termguicolors
let g:gruvbox_italic = 1
colorscheme gruvbox

" IndentLine
let g:indentLine_char = '┆'

" LightLine
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'separator': {
      \   'left': '', 'right': ''
      \ },
      \ 'subseparator': {
      \   'left': '', 'right': ''
      \ },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ],
      \   'right': [['lineinfo'], ['percent'], ['fileformat', 'fileencoding', 'filetype']]
      \ },
      \ 'component': {
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}'
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightLineFugitive',
      \   'filetype': 'LightLineFileType',
      \   'fileformat': 'LightLineFileFormat',
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))'
      \ },
      \ }

function! LightLineFugitive()
  if &filetype ==# 'help'
    return ''
  endif

  if exists('*fugitive#head')
    let l:head = fugitive#head()
    if l:head isnot ''
      return ' ' . l:head
    endif
  endif
  return ''
endfunction

function! LightLineFileType()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! LightLineFileFormat()
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

" Startify
let g:startify_bookmarks = [{'c': $MYVIMRC}]
let g:startify_session_dir = expand('~/.local/share/nvim/sessions')

" ChooseWin
let g:choosewin_label = 'ARSTNEIOVMDHC,PLUFWY'

" NERDTree
noremap <C-n> :NERDTreeToggle<CR>

" Deoplete
let g:deoplete#enable_at_startup = 1
packadd deoplete.nvim
set completeopt-=preview
let g:deoplete#auto_complete_delay = 0

" fzf
set runtimepath^=/usr/share/vim/vimfiles

" EchoDoc
let g:echodoc_enable_at_startup = 1

" UltiSnips
let g:UltiSnipsSnippetsDir = expand(s:rc_path . '/UltiSnips')
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<M-n>"
let g:UltiSnipsJumpBackwardTrigger = "<M-p>"

" ALE
let g:ale_fix_on_save = 1
let g:ale_fixers = {
      \   'python': ['yapf']
      \}

" Mappings
tnoremap <Esc> <C-\><C-n>
noremap <silent> k gk
noremap <silent> j gj
noremap <silent> 0 g0
noremap <silent> $ g$

" ChooseWin
nmap <leader>o <Plug>(choosewin)

" UndoTree
nnoremap <F5> :UndotreeToggle<CR>

" fzf
nnoremap <leader>p :GFiles<CR>
nnoremap <leader>P :Files<CR>
nnoremap <leader>l :BTags<CR>
nnoremap <leader>L :BLines<CR>

" Commands
command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update()
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
