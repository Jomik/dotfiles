if &shell =~# 'fish$'
    set shell=bash
endif

set nocompatible
call plug#begin('~/.vim/plugged')

" Appearance
Plug 'altercation/vim-colors-solarized'
Plug 'majutsushi/tagbar'
" Plug 'itchyny/lightline.vim'

" General niceness
Plug 'tpope/vim-surround'
Plug 'junegunn/limelight.vim'

" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" LaTeX
Plug 'lervag/vimtex'

" Syntax
Plug 'dag/vim-fish'

call plug#end()

filetype plugin indent on
syntax enable

" Backups {{{

set backup
set noswapfile

set undodir=~/.vim/tmp/undo//
set backupdir=~/.vim/tmp/backup//

if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
" }}}

" Line number and indicators
set relativenumber number
set cursorcolumn cursorline

" Text width
set textwidth=80
set formatoptions+=t
set wrap linebreak

" Search options
set showmatch
set hlsearch
set incsearch
set ignorecase
set gdefault

" Indent using 4 spaces instead of tab
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set autoindent

" Logic window splitting
set splitbelow
set splitright
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

let mapleader=","
let maplocalleader="//"

noremap <Leader>w :w<CR>
noremap <silent> <Leader><Leader> :nohlsearch<CR>

" Only go down to the next row, not next line, for wrapped lines.
noremap j gj
noremap k gk

" Persistent cursor when joining lines
nnoremap J mzJ`z
" Split line
nnoremap S i<cr><esc>^mwgk:silent! s/\v +$//<cr>:noh<cr>`w

" Avoid having to bullseye my esc button.
inoremap jk <esc>
vnoremap jk <esc>

" Get forced into the habits
inoremap <Esc> <nop>
nnoremap <Left> <nop>
nnoremap <Right> <nop>
nnoremap <Up> <nop>
nnoremap <Down> <nop>

" Uppercase word
inoremap <C-U> <Esc>mzgUiw`za

" Format document
nnoremap <F7> mzgg=G`z

" Panic button
nnoremap <F9> mzggg?G`z

" Zoom to head level
nnoremap zh mzzt10<C-U>`z

" Substitute
nnoremap <C-S> :%s/

" Quick .vimrc edit
nnoremap <Leader>ev :vsplit $MYVIMRC<CR>
nnoremap <Leader>sv :source $MYVIMRC<CR>

" Foldmethod
set foldenable
set foldmethod=marker
set foldlevel=0

" Statusline
set laststatus=2
set statusline=%.20F
set statusline+='\ -\ '
set statusline+='FileType:\ '
set statusline+=%y
set statusline+=%=
set statusline+=[%04l
set statusline+=/
set statusline+=%04L]

" Solarized
let g:solarized_termcolors=16
colorscheme solarized
set background=dark

" Limelight {{{
nnoremap <Leader>l :Limelight!!<CR>
let g:limelight_conceal_ctermfg = 'gray'
" }}}

" Highlight Word {{{
"
" This mini-plugin provides a few mappings for highlighting words temporarily.
"
" Sometimes you're looking at a hairy piece of code and would like a certain
" word or two to stand out temporarily.  You can search for it, but that only
" gives you one color of highlighting.  Now you can use <leader>N where N is
" a number from 1-6 to highlight the current word in a specific color.

function! HiInterestingWord(n) " {{{
    " Save our location.
    normal! mz

    " Yank the current word into the z register.
    normal! "zyiw

    " Calculate an arbitrary match ID.  Hopefully nothing else is using it.
    let mid = 86750 + a:n

    " Clear existing matches, but don't worry if they don't exist.
    silent! call matchdelete(mid)

    " Construct a literal pattern that has to match at boundaries.
    let pat = '\V\<' . escape(@z, '\') .  '\>'

    " Actually match the words.
    call matchadd("InterestingWord" .  a:n, pat, 1, mid)

    " Move back to our original location.
    normal! `z
endfunction " }}}

" Mappings {{{
nnoremap <silent> <leader>1 :call HiInterestingWord(1)<cr>
nnoremap <silent> <leader>2 :call HiInterestingWord(2)<cr>
nnoremap <silent> <leader>3 :call HiInterestingWord(3)<cr>
nnoremap <silent> <leader>4 :call HiInterestingWord(4)<cr>
nnoremap <silent> <leader>5 :call HiInterestingWord(5)<cr>
nnoremap <silent> <leader>6 :call HiInterestingWord(6)<cr>
" }}}

" Default Highlights {{{
hi def InterestingWord1 guifg=#000000 ctermfg=16 guibg=#ffa724 ctermbg=214
hi def InterestingWord2 guifg=#000000 ctermfg=16 guibg=#aeee00 ctermbg=154
hi def InterestingWord3 guifg=#000000 ctermfg=16 guibg=#8cffba ctermbg=121
hi def InterestingWord4 guifg=#000000 ctermfg=16 guibg=#b88853 ctermbg=137
hi def InterestingWord5 guifg=#000000 ctermfg=16 guibg=#ff9eb8 ctermbg=211
hi def InterestingWord6 guifg=#000000 ctermfg=16 guibg=#ff2c4b ctermbg=195
" }}}
" }}}
