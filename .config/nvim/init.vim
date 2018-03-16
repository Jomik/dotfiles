" Changes to defaults
let mapleader=" "
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

tnoremap <Esc> <C-\><C-n>

" Install Vim Plug if not installed
if empty(glob('~/.config/nvim/autoload/plug.vim'))
silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
  \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin()

" Visuals
Plug 'morhetz/gruvbox'
Plug 'mhinz/vim-startify'

" Navigation
Plug '/usr/share/vim/vimfiles'
Plug 'junegunn/fzf.vim'

" Editing
Plug 'Shougo/deoplete.nvim', { 'do': 'UpdateRemotePlugins' }
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs'

" Information
Plug 'machakann/vim-highlightedyank'
Plug 'Shougo/echodoc.vim'

" Language
Plug 'w0rp/ale'
Plug 'ntpeters/vim-better-whitespace'
Plug 'janko-m/vim-test'

" Typescript
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript'

" Javascript
Plug 'othree/yajs.vim'
Plug 'pangloss/vim-javascript'

" JSON
Plug 'elzr/vim-json'

" Fish-Shell
Plug 'dag/vim-fish'

" The special ones
Plug 'ryanoasis/vim-devicons'

call plug#end()

" Change color theme
set termguicolors
let g:gruvbox_italic = 1
colorscheme gruvbox

" Deoplete settings
set completeopt-=preview
let g:deoplete#enable_at_startup = 1
call deoplete#custom#source('typescript', 'min_pattern_length', 1)
let g:deoplete#auto_complete_delay = 0
let g:echodoc_enable_at_startup = 1

let g:ale_fix_on_save = 1
let g:ale_fixers = {
\   'typescript': ['prettier'],
\   'python': ['yapf'],
\   'javascript': ['prettier']
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

let g:startify_bookmarks = [{'c': '~/.config/nvim/init.vim'}]

" Mappings
noremap <buffer> <silent> k gk
noremap <buffer> <silent> j gj
noremap <buffer> <silent> 0 g0
noremap <buffer> <silent> $ g$

" fzf
nnoremap <leader>p :GFiles<CR>
nnoremap <leader>P :Files<CR>
nnoremap <leader>L :BLines<CR>

" autocmds

augroup cfghooks
    au!
    autocmd bufwritepost $MYVIMRC source $MYVIMRC
augroup END

