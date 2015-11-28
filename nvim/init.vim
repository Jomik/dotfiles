if &shell =~# 'fish$'
    set shell=bash
endif
set nocompatible

" Plugin installation {{{
function! UpdateRPlugin(info) " {{{
    if has('nvim')
        silent UpdateRemotePlugins
        echomsg 'rplugin updated: ' . a:info['name'] . ', restart vim for changes.'
    endif
endfunction
" }}}

call plug#begin('~/.config/nvim/plugged')

Plug 'altercation/vim-colors-solarized'
Plug 'itchyny/lightline.vim'

Plug 'majutsushi/tagbar'

" Text objects
Plug 'kana/vim-textobj-user'
Plug 'glts/vim-textobj-comment'

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

Plug 'junegunn/limelight.vim'

Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'floobits/floobits-neovim', { 'do': function('UpdateRPlugin') }

Plug 'dag/vim-fish'
Plug 'lervag/vimtex', { 'for': 'tex' }

call plug#end()
filetype plugin indent on
syntax enable
" }}}

" Backups {{{
set backup
set noswapfile

set undodir=~/.cache/nvim/undo/
set backupdir=~/.cache/nvim/backup/

if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
" }}}

" Settings {{{
set title
set mouse=""

" Line number and indicators {{{
set relativenumber number
set cursorcolumn cursorline
" }}}

" Text width {{{
set textwidth=80
set formatoptions+=t
set wrap linebreak
" }}}

" Search options {{{
set showmatch
set hlsearch incsearch
set ignorecase
" }}}

" Indentation {{{
" Use 4 spaces instead of tab
set tabstop=4 shiftwidth=4
set expandtab
set autoindent
" }}}

" Window splitting {{{
" Make it more logic by splitting below and to the right
set splitbelow splitright
" Let us simply use CTRL+movement to move between windows.
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h
" }}}

" Folding {{{
set foldenable foldmethod=marker
set foldlevel=0
" }}}
" }}}

" Mappings {{{
let mapleader=","
let maplocalleader="/"

" Quick init.vim edit {{{
nnoremap <Leader>ev :vsplit $MYVIMRC<CR>
nnoremap <Leader>sv :source $MYVIMRC<CR>
" }}}

" Disable useless keys {{{
inoremap <Esc> <nop>
nnoremap <Left> <nop>
nnoremap <Right> <nop>
nnoremap <Up> <nop>
nnoremap <Down> <nop>
" }}}

" Temporarily disable search highlight
noremap <silent> <Leader><Leader> :nohlsearch<CR>

" Sane movement on wrapped lines
noremap j gj
noremap k gk

" Avoid having to bullseye my esc button
inoremap jk <esc>

" [J]oin and [S]plit {{{
" Persistent cursor when joining lines
nnoremap J mzJ`z
" Split line
nnoremap S i<cr><esc>^mwgk:silent! s/\v +$//<cr>:noh<cr>`w
" }}}

" Uppercase word
inoremap <C-U> <Esc>mzgUiw`za

" Format document
nnoremap <F7> mzgg=G`z

" Panic button
nnoremap <F9> mzggg?G`z
" }}}

" Plugin setup {{{

" Solarized {{{
let g:solarized_termcolors=16
colorscheme solarized
set background=dark
" }}}

" LightLine {{{
set laststatus=2
set noshowmode
let g:lightline = { 'colorscheme': 'solarized',
            \ 'separator': { 'left': '', 'right': '' },
            \ 'subseparator': { 'left': '', 'right': '' },
            \
            \ 'active': {
            \   'left': [
            \       [ 'mode', 'paste'],
            \       [ 'fugitive', 'readonly', 'filename', 'modified' ]]
            \ },
            \ 'component_function': {
            \   'modified': 'LightLineModified',
            \   'readonly': 'LightLineReadOnly',
            \   'fugitive': 'LightLineFugitive'
            \ }
            \ }

" LightLine functions {{{
function! LightLineModified() " {{{
    if &filetype == "help"
        return ""
    elseif &modified
        return "+"
    elseif &modifiable
        return ""
    else
        return "-"
    endif
endfunction
" }}}

function! LightLineReadOnly() " {{{
    if &filetype == "help"
        return ""
    elseif &readonly
        return ""
    else
        return ""
    endif
endfunction
" }}}

function! LightLineFugitive() " {{{
    if exists('*fugitive#head')
        let h = fugitive#head()
        return strlen(h) ? " " . fugitive#head() : ""
    else
        return ""
    endif
endfunction
" }}}
" }}}
" }}}

" Limelight {{{
nnoremap <Leader>f :Limelight!!<CR>
let g:limelight_conceal_ctermfg = 'gray'
" }}}

" LaTeX {{{
let g:tex_flavor = "tex"
" }}}

" Commentary {{{
let g:commentary_map_backslash=0
" }}}
" }}}
