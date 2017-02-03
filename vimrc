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

call s:LetAndMkdir('&backupdir', $HOME.'/.vim/backup')
call s:LetAndMkdir('&directory', $HOME.'/.vim/swap')
call s:LetAndMkdir('&undodir', $HOME.'/.vim/undo')

" Set augroup.
augroup MyAutoCmd
    autocmd!
augroup END


"-----------------------------------------------------------------------------
" General
"-----------------------------------------------------------------------------
" Setting of the encoding to use for a save and reading.
" Make it normal in UTF-8 in Unix.
if &compatible
  set nocompatible
endif

set encoding=utf-8
scriptencoding utf-8

filetype plugin indent on   " Automatically detect file types.
syntax on                   " Syntax highlighting
set mouse=a                 " Automatically enable mouse usage
set mousehide               " Hide the mouse cursor while typing

set nowrap                      " Do not wrap long lines
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

if has('cmdline_info')
    set ruler                   " Show the ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
    set showcmd                 " Show partial commands in status line and
    " Selected characters/lines in visual mode
endif

if has('statusline')
    set laststatus=2

    " Broken down into easily includeable segments
    set statusline=%<%f\                     " Filename
    set statusline+=%w%h%m%r                 " Options
    set statusline+=\ [%{&ff}/%Y]            " Filetype
    set statusline+=\ [%{getcwd()}]          " Current dir
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif

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
let &showbreak = '+++ '
highlight ColorColumn ctermbg=darkred guibg=darkred

let g:rehash256 = 1


" Automaticaly changes with current file directory when new buffer is
" opened, limitaion for files
"autocmd BufEnter * if bufname('') !~ '^[A-Za-z0-9]*:\(//\|\\\\\)' | lcd %:p:h | endif

"set autowrite                       " Automatically write a file when leaving a modified buffer
set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
set virtualedit=onemore             " Allow for cursor beyond last character
set history=1000                    " Store a ton of history (default is 20)
set nospell                         " Spell checking off
set hidden                          " Allow buffer switching without saving
set iskeyword-=.                    " '.' is an end of word designator
set iskeyword-=#                    " '#' is an end of word designator
set iskeyword-=-                    " '-' is an end of word designator
set timeoutlen=1000 ttimeoutlen=10

" Instead of reverting the cursor to the last position in the buffer, we
" set it to the first line when editing a git commit message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

" http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
" Restore cursor to file position in previous editing session
function! ResCur()
    if line("'\"") <= line("$")
        normal! g`"
        return 1
    endif
endfunction

augroup resCur
    autocmd!
    autocmd BufWinEnter * call ResCur()
augroup END

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

" Add exclusions to mkview and loadview
" eg: *.*, svn-commit.tmp
let g:skipview_files = [
            \ '\[example pattern\]'
            \ ]

if v:version >= 703
    set rnu
else
    set nu
endif
set swapfile

"-----------------------------------------------------------------------------
" Language & OS
"-----------------------------------------------------------------------------
set background=dark

if has('multi_byte_ime')
    set iminsert=0 imsearch=0
    inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
endif

" Setting of terminal encoding."{{{
if has("multi_byte")
    setglobal fileencoding=utf-8
    set fileencoding=utf-8
    set fileencodings=ucs-bom,utf-8,cp949,euc-kr`
    set termencoding=utf-8
    let $LANG = "ko_KR.UTF-8"
endif

" GVIM- (here instead of .gvimrc)
if has('gui_running')
    set guioptions-=T           " Remove the toolbar
    set lines=40                " 40 lines of text instead of 24
    if !exists("g:spf13_no_big_font")
        if IsLinux() && has("gui_running")
            set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ Book\ 12
        elseif IsMac() && has("gui_running")
            set guifont=Consolas\ for\ Powerline:11,Andale\ Mono\ Regular:h12
        endif
    endif
else
    if &term == 'xterm' || &term == 'screen'
        set t_Co=256            " Enable 256 colors
    endif
    "set term=builtin_ansi       " Make arrow and other keys work
endif

"-----------------------------------------------------------------------------
" Key (re)Mappings
"-----------------------------------------------------------------------------

" The default leader is '\', but many people prefer ',' as it's in a standard
" location. To override this behavior and set it back to '\' (or any other
" character) add the following to your .vimrc.before.local file:
nnoremap \ ,
let mapleader = ','
let maplocalleader = '_'

" [Space]: Other useful commands "{{{
" Smart space mapping.
" Notice: when starting other <Space> mappings in noremap, disappeared [Space].
nmap  <Space>   [Space]
xmap  <Space>   [Space]
nnoremap  [Space]   <Nop>
xnoremap  [Space]   <Nop>

" swap ; and :
nnoremap ; :
vnoremap ; :
nnoremap q; q:
vnoremap q; q:
nnoremap : ;
vnoremap : ;

" switch j,k and gj,gk
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap gj j
nnoremap gk k
vnoremap gj j
vnoremap gk k

" key map ^,$ to <Space>h,l. Because ^ and $ is difficult to type and damage little finger!!!
noremap <Space>h ^
noremap <Space>l $

" same as above. but don't use noremap because want to map to matchit plugin
map <Space>n %

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

" insert blank line
nnoremap <silent> <Space>o   :<C-u>for i in range(1, v:count1) \| call append(line('.'),   '') \| endfor \| silent! call repeat#set("<Space>o", v:count1)<CR>
nnoremap <silent> <Space>O   :<C-u>for i in range(1, v:count1) \| call append(line('.')-1, '') \| endfor \| silent! call repeat#set("<Space>O", v:count1)<CR>
nnoremap <silent> <S-Space>O :<C-u>for i in range(1, v:count1) \| call append(line('.')-1, '') \| endfor \| silent! call repeat#set("<S-Space>O"), v:count1<CR>

" Easier moving in tabs and windows
" The lines conflict with the default digraph mapping of <C-K>
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
map <C-L> <C-W>l<C-W>_
map <C-H> <C-W>h<C-W>_


"-----------------------------------------------------------------------------
" plugin
"-----------------------------------------------------------------------------

call plug#begin('~/.vim/plugged')
Plug 'junegunn/vim-easy-align'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tomasr/molokai'
Plug 'kien/ctrlp.vim'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/syntastic'
Plug 'majutsushi/tagbar'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'tpope/vim-surround'              "command : ys cs ds
Plug 'ReplaceWithRegister'             "command : gr
Plug 'christoomey/vim-titlecase'       "command : gt
Plug 'christoomey/vim-sort-motion'     "command : gs
Plug 'tpope/vim-commentary'            "command : gc
Plug 'christoomey/vim-system-copy'     "command : cp cv
Plug 'kana/vim-textobj-user'
Plug 'wellle/targets.vim'              "textobj : a, i, an( in(
Plug 'michaeljsmith/vim-indent-object' "textobj : ai ii
Plug 'kana/vim-textobj-line'           "textobj : al il
"This checks for vim 8.0 or above before installing plugins
if v:version >= 800
    Plug 'skywind3000/asyncrun.vim'
endif
call plug#end()

"-----------------------------------------------------------------------------
" plugin 'setting'
"-----------------------------------------------------------------------------
" moloaki
if isdirectory(expand("~/.vim/plugged/molokai"))
    color molokai
endif

" airline
if isdirectory(expand("~/.vim/plugged/vim-airline"))
    let g:airline_powerline_fonts = 1
    let g:airline_theme = 'powerlineish'
    "let g:airline_left_sep = ''
    "let g:airline_right_sep = ''
    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif
    " unicode symbols
    let g:airline_left_sep = '»'
    let g:airline_left_sep = '▶'
    let g:airline_right_sep = '«'
    let g:airline_right_sep = '◀'
    let g:airline_symbols.linenr = '␊'
    let g:airline_symbols.linenr = '␤'
    let g:airline_symbols.linenr = '¶'
    let g:airline_symbols.branch = '⎇'
    let g:airline_symbols.paste = 'ρ'
    let g:airline_symbols.paste = 'Þ'
    let g:airline_symbols.paste = '∥'
    let g:airline_symbols.whitespace = 'Ξ'

    " powerline symbols
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_symbols.branch = ''
    let g:airline_symbols.readonly = ''
    let g:airline_symbols.linenr = ''

endif

"asyncrun
if isdirectory(expand("~/.vim/plugged/asyncrun.vim"))
    :noremap <F9> :call asyncrun#quickfix_toggle(8)<CR>
    augroup vimrc
        autocmd QuickFixCmdPost * botright copen 8
    augroup END
    if isdirectory(expand("~/.vim/plugged/vim-airline"))
        let g:airline_section_error = airline#section#create_right(['%{g:asyncrun_status}'])
    endif
    if isdirectory(expand("~/.vim/plugged/vim-fugitive"))
        command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
    endif
endif

"nerdtree
if isdirectory(expand("~/.vim/plugged/nerdtree"))
    noremap <C-e> :NERDTreeToggle<CR>
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    let NERDTreeShowBookmarks=1
    let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
    let NERDTreeChDirMode=0
    let NERDTreeQuitOnOpen=1
    let NERDTreeMouseMode=2
    let NERDTreeShowHidden=1
    let NERDTreeKeepTreeInNewTab=1
endif

"ctrlp
if isdirectory(expand("~/.vim/plugged/ctrlp.vim/"))
    let g:ctrlp_working_path_mode = 'ra'
    let g:ctrlp_custom_ignore = {
                \ 'dir':  '\.git$\|\.hg$\|\.svn$',
                \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }
endif

"syntastic
if isdirectory(expand("~/.vim/plugged/syntastic"))
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
endif

" vim-Easy-align
if isdirectory(expand("~/.vim/plugged/vim-easy-align"))
  " Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
  xmap <Enter> <Plug>(EasyAlign)
  " Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
  nmap <Leader>a <Plug>(EasyAlign)
endif

" Tagbar
if isdirectory(expand("~/.vim/plugged/tagbar"))
    nnoremap <F8> :TagbarToggle<CR>
endif

" YouCompleteMe {
if isdirectory(expand("~/.vim/plugged/YouCompleteMe"))
    let g:acp_enableAtStartup = 0

    " enable completion from tags
    let g:ycm_collect_identifiers_from_tags_files = 1

    " remap Ultisnips for compatibility for YCM
    let g:UltiSnipsExpandTrigger = '<C-j>'
    let g:UltiSnipsJumpForwardTrigger = '<C-j>'
    let g:UltiSnipsJumpBackwardTrigger = '<C-k>'

    " Enable omni completion.
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
    autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

    " Haskell post write lint and check with ghcmod
    " $ `cabal install ghcmod` if missing and ensure
    " ~/.cabal/bin is in your $PATH.
    if !executable("ghcmod")
        autocmd BufWritePost *.hs GhcModCheckAndLintAsync
    endif

    if has('conceal')
        set conceallevel=2 concealcursor=i
    endif

    " Disable the neosnippet preview candidate window
    " When enabled, there can be too much visual noise
    " especially when splits are used.
    set completeopt-=preview
endif
