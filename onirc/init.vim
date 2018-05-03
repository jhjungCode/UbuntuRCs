"-----------------------------------------------------------------------------
" Help function
"-----------------------------------------------------------------------------
" Identify platform
silent function! IsMac()
    return has('macunix')
endfunction
silent function! IsLinux()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction

" Initialized backup, swap, undo directory
function! s:LetAndMkdir(variable, path) "{{{
    try
        if !isdirectory(a:path)
            call mkdir(a:path, 'p')
        endif
    catch
        echohl WarningMsg
        echom '[error]' . a:path . 'is exist and is not directory, but is file or something.'
        echohl None
    endtry
    execute printf("let %s = a:path", a:variable)
endfunction "}}}

call s:LetAndMkdir('&backupdir', $HOME.'/.config/nvim/backup')
call s:LetAndMkdir('&directory', $HOME.'/.config/nvim/swap')
call s:LetAndMkdir('&undodir', $HOME.'/.config/nvim/undo')

" Set augroup.
augroup MyAutoCmd
    autocmd!
augroup END

"-----------------------------------------------------------------------------
" General
"-----------------------------------------------------------------------------
" Setting of the encoding to use for a save and reading.
" Make it normal in UTF-8 in Unix.
" Setting up the directories
set backup                  " Backups are nice ...
if has('persistent_undo')
    set undofile                " So is persistent undo ...
    set undolevels=1000         " Maximum number of changes that can be undone
    set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
endif
if has('unix')
    set backupskip=/tmp/*,/private/tmp/*
endif

set rnu
set swapfile

if &compatible
  set nocompatible
endif

set encoding=utf-8
scriptencoding utf-8

filetype plugin indent on   " Automatically detect file types.
syntax on                   " Syntax highlighting
set mouse=a                 " Automatically enable mouse usage
set mousehide               " Hide the mouse cursor while typing

set autoindent                  " Indent at the same level of the previous line
set shiftwidth=4                " Use indents of 4 spaces
set expandtab                   " Tabs are spaces, not tabs
set tabstop=4                   " An indentation every four columns
set softtabstop=4               " Let backspace delete indent
set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current
set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)

set tabpagemax=15               " Only show 15 tabs
set showmode                    " Display the current mode
set cursorline                  " Highlight current line

highlight clear SignColumn      " SignColumn should match background
highlight clear LineNr          " Current line number row will have same background color in relative mode
"highlight clear CursorLineNr    " Remove highlight color from current line number

set backspace=indent,eol,start  " Backspace for dummies
set linespace=0                 " No extra spaces between rows
set nu                          " Line numbers on
set showmatch                   " Show matching brackets/parenthesis
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms
set winminheight=0              " Windows can be 0 line high
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set wildignore=.git,.hg,.svn
set wildignore+=*.jpg,*.jpeg,*.bmp,*.gif,*.png
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest,*.so,*.out,*.class
set wildignore+=*.swp,*.swo,*.swn
set wildignore+=*.DS_Store
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor
set foldenable                  " Auto fold code
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
set colorcolumn=79
set ttyfast
"let &showbreak = '+++ '
let &showbreak = ''
highlight ColorColumn ctermbg=darkred guibg=darkred

let g:rehash256 = 1

"-----------------------------------------------------------------------------
" Key (re)Mappings
"-----------------------------------------------------------------------------

" " The default leader is '\', but many people prefer ',' as it's in a standard
" " location. To override this behavior and set it back to '\' (or any other
" " character) add the following to your .vimrc.before.local file:
nnoremap \ ,
let mapleader = "\<Space>"
" let mapleader = ','
" let maplocalleader = '_'

" " swap ; and :
" nnoremap ; :
" vnoremap ; :
" nnoremap q; q:
" vnoremap q; q:
" nnoremap : ;
" vnoremap : ;

" prevent popping up stupid window 
map q: :q

" switch j,k and gj,gk
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap gj j
nnoremap gk k
vnoremap gj j
vnoremap gk k

" key map ^,$ to <leader>h,l. Because ^ and $ is difficult to type and damage little finger!!!
noremap <leader>h ^
noremap <leader>l $

" insert mode
" undoable C-w,C-u
inoremap <C-w> <C-g>u<C-w>
inoremap <C-u> <C-g>u<C-u>

" stop the highlighting
"nnoremap <silent> <Esc><Esc> :<C-u>nohlsearch<CR>
nnoremap <silent> <C-c><C-c> :<C-u>nohlsearch<CR>
nnoremap <silent> <C-[><C-[> :<C-u>nohlsearch<CR>
nnoremap <silent> <C-@><C-@> :<C-u>nohlsearch<CR>

" n is always search forwward and N is always search backward
nnoremap <expr> n <SID>search_forward_p() ? 'nzv' : 'Nzv'
nnoremap <expr> N <SID>search_forward_p() ? 'Nzv' : 'nzv'
vnoremap <expr> n <SID>search_forward_p() ? 'nzv' : 'Nzv'
vnoremap <expr> N <SID>search_forward_p() ? 'Nzv' : 'nzv'
onoremap <expr> n <SID>search_forward_p() ? 'n' : 'N'
onoremap <expr> N <SID>search_forward_p() ? 'N' : 'n'

function! s:search_forward_p()
    return exists('v:searchforward') ? v:searchforward : 1
endfunction

" disable because this is dangerous key
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>

" Don't use Ex mode, use Q for formatting
nnoremap Q gq

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Use more logical mapping (see :h Y)
nnoremap Y y$

"-----------------------------------------------------------------------------
" plugin
"-----------------------------------------------------------------------------
call plug#begin()
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" Plug 'majutsushi/tagbar'
Plug 'junegunn/vim-easy-align'
Plug 'skywind3000/asyncrun.vim'
Plug 'tpope/vim-repeat'            "expand . to plugins(vim-surround)
Plug 'christoomey/vim-titlecase'   "command : gt
Plug 'christoomey/vim-sort-motion' "command : gs
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'     "textobj : ai ii
Plug 'wellle/targets.vim'          "textobj : a, i, an( in(
call plug#end()

"-----------------------------------------------------------------------------
" plugin 'setting'
"-----------------------------------------------------------------------------
"nerdtree
if isdirectory(expand("~/.config/nvim/plugged/nerdtree"))
    noremap <Space>e :NERDTreeToggle<CR>
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    let NERDTreeShowBookmarks=1
    let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
    let NERDTreeChDirMode=0
    let NERDTreeQuitOnOpen=1
    let NERDTreeMouseMode=2
    let NERDTreeShowHidden=0
    let NERDTreeKeepTreeInNewTab=1
endif

" vim-Easy-align
if isdirectory(expand("~/.config/nvim/plugged/vim-easy-align"))
  " Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
  xmap <Enter> <Plug>(EasyAlign)
  " Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
  nmap <Leader>a <Plug>(EasyAlign)
endif

" Tagbar
if isdirectory(expand("~/.config/nvim/plugged/tagbar"))
    nnoremap <F8> :TagbarToggle<CR>
endif
