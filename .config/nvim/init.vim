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

packadd minpac
call minpac#init()
call minpac#add('k-takata/minpac', {'type': 'opt'})

" Visuals
call minpac#add('morhetz/gruvbox')
call minpac#add('mhinz/vim-startify')

" Navigation
set runtimepath^=/usr/share/vim/vimfiles
call minpac#add('junegunn/fzf.vim')
call minpac#add('easymotion/vim-easymotion')

" Editing
call minpac#add('Shougo/deoplete.nvim', {'type': 'opt'})
call minpac#add('tpope/vim-surround')
call minpac#add('tpope/vim-commentary')
call minpac#add('tommcdo/vim-exchange')
call minpac#add('SirVer/ultisnips')

" Information
call minpac#add('machakann/vim-highlightedyank')
call minpac#add('Shougo/echodoc.vim')

" Language
call minpac#add('w0rp/ale')
call minpac#add('ntpeters/vim-better-whitespace')
call minpac#add('janko-m/vim-test')

" Typescript
call minpac#add('HerringtonDarkholme/yats.vim')
call minpac#add('mhartington/nvim-typescript', {'branch': 'fix-121'})

" Javascript
call minpac#add('othree/yajs.vim')
call minpac#add('pangloss/vim-javascript')

" JSON
call minpac#add('elzr/vim-json')

" Fish-Shell
call minpac#add('dag/vim-fish')

" The special ones
call minpac#add('ryanoasis/vim-devicons')

if (s:do_update)
  call minpac#update()
endif

" Colorscheme
set termguicolors
let g:gruvbox_italic = 1
colorscheme gruvbox

" Startify
let g:startify_bookmarks = [{'c': $MYVIMRC}]

" EasyMotion
let g:EasyMotion_smartcase = 1
let g:EasyMotion_do_mapping = 0

" Deoplete
let g:deoplete#enable_at_startup = 1
packadd deoplete.nvim
set completeopt-=preview
let g:deoplete#auto_complete_delay = 0
call deoplete#custom#source('typescript', 'min_pattern_length', 1)
call deoplete#custom#set('ultisnips', 'matchers', ['matcher_fuzzy'])

" EchoDoc
let g:echodoc_enable_at_startup = 1

" UltiSnips
let g:UltiSnipsSnippetsDir=expand(s:rc_path . '/UltiSnips')
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<M-n>"
let g:UltiSnipsJumpBackwardTrigger="<M-p>"

" ALE
let g:ale_fix_on_save = 1
let g:ale_fixers = {
\   'typescript': ['prettier'],
\   'javascript': ['prettier'],
\   'python': ['yapf']
\}

" Typescript
let g:nvim_typescript#type_info_on_hold = 1
let g:nvim_typescript#default_mappings = 1
let g:nvim_typescript#max_completion_detail = 100
let g:nvim_typescript#completion_mark = ''
let g:nvim_typescript#kind_symbols = {
      \ 'keyword': 'keyword',
      \ 'class': '',
      \ 'interface': '',
      \ 'script': 'script',
      \ 'module': '',
      \ 'local class': 'local class',
      \ 'type': '',
      \ 'enum': '',
      \ 'enum member': '',
      \ 'alias': '',
      \ 'type parameter': 'type param',
      \ 'primitive type': 'primitive type',
      \ 'var': '',
      \ 'local var': '',
      \ 'property': '',
      \ 'let': '',
      \ 'const': '',
      \ 'label': 'label',
      \ 'parameter': 'param',
      \ 'index': 'index',
      \ 'function': 'λ',
      \ 'local function': 'local function',
      \ 'method': '',
      \ 'getter': '',
      \ 'setter': '',
      \ 'call': 'call',
      \ 'constructor': '',
\}

" Mappings
tnoremap <Esc> <C-\><C-n>
noremap <buffer> <silent> k gk
noremap <buffer> <silent> j gj
noremap <buffer> <silent> 0 g0
noremap <buffer> <silent> $ g$

" EasyMotion
nmap s <Plug>(easymotion-overwin-f2)
map <leader>j <Plug>(easymotion-j)
map <leader>k <Plug>(easymotion-k)

" fzf
nnoremap <leader>p :GFiles<CR>
nnoremap <leader>P :Files<CR>
nnoremap <leader>l :BTags<CR>
nnoremap <leader>L :BLines<CR>

" autocmds
augroup cfghooks
    au!
    autocmd bufwritepost $MYVIMRC source $MYVIMRC
augroup END
