" Pathogen
call pathogen#infect()
call pathogen#helptags()

set number "linenumbers
set noerrorbells visualbell t_vb=
colors wombat256mod
syntax on
set antialias
set t_Co=256
set expandtab
set tabstop=4
set softtabstop=4
set backspace=2
set shiftwidth=4
set nowrap
set title
set nopaste

" searching:
set incsearch
set hlsearch
set ignorecase
set smartcase
highlight Search  term=Underline cterm=Underline ctermfg=none ctermbg=none gui=underline guifg=NONE guibg=NONE

"set iTerm tab names
if !has("gui_running")
    set t_ts=]1;
    set t_fs=
endif

"mouse support
"set mouse=a

"tab completion of filenames fix (from allanc)
set wildmode=longest,list,full
set wildmenu
" Don't suggest pyc files
set wildignore+=*.pyc

"when tab is closed, remove the buffer:
set hidden

" Change buffers easily
map <C-j> :bnext<CR>
map <C-k> :bprev<CR>

"Close a buffer without closing the window associated with it - plugin/Kwbd.vim
command! Bclose Kwbd

nnoremap K <Nop>
vnoremap K <Nop>
nnoremap <C-w>o <Nop>
nnoremap <C-w><C-o> <Nop>

vmap ]] o<esc>]]V''ok
vmap [[ o<esc>[[V''o

"Press Space to turn off highlighting and clear any message already displayed
"The 'Bar' should be the same as \| -- it allows us to execute 2 commands
nnoremap <silent> <Space><Space> :nohlsearch<Bar>:echo<CR>
"
" Easy normal-mode linen wrapping
nnoremap <silent> <CR> i<CR><esc>
"
" pdb mapping
nmap \b mxoimport pdb; pdb.set_trace()<esc>`x

" pprint mapping
nmap \p :s/\vprint (.*)/pprint\(\1\)<CR>mxOfrom pprint import pprint<esc>`x
nmap \P :s/\vpprint\((.*)\)/print \1/<CR>kdd

" forgot sudo?
cmap W!! %!sudo tee > /dev/null %

" Emacs bindings in command line mode
cnoremap <c-a> <home>
cnoremap <c-e> <end>

map _ :s/\v^(\s*)# /\1/<cr>:nohlsearch<cr>
map - :s/\v^(\s*)(.+)/\1# \2/<cr>:nohlsearch<cr>

imap jk <esc>
imap JK <esc>
imap Jk <esc>
imap <c-a> <c-o>I
imap <c-e> <c-o>A

" Remap the tab key to do autocompletion or indentation depending on the
" context (from http://www.vim.org/tips/tip.php?tip_id=102)
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

" Use sane regexes.
nnoremap / /\v
vnoremap / /\v

" Create newlines and stay in Normal Mode
nnoremap <silent> <Space>j mxo<Esc>`x
nnoremap <silent> <Space>k mxO<Esc>`x

" keep at least 5 lines to the left/right, above/below
set scrolloff=5
set sidescrolloff=5

set undolevels=1000                 "1000 undos
set updatecount=100                 "switch every 100 chars

"Don't want backup files
set nobackup
set nowritebackup
set noswapfile

map ,p :set paste!<CR>
map ,t :CommandT<CR>
map ,b :CommandTBuffer<CR>
nmap ,l :set list!<CR>
nnoremap ,w :w\|make unit-test<cr>
nnoremap ,ev :80vs $MYVIMRC<cr>
nnoremap ,so :w\|source %\|nohlsearch<cr>

nnoremap ,' ""yls<c-r>={'"': "'", "'": '"'}[@"]<cr><esc>
vnoremap ,' ""yls<c-r>={'"': "'", "'": '"'}[@"]<cr><esc>

" When 3 vertial windows open, make current one slightly bigger
nnoremap ,cc <c-w>h5<c-w><2<c-w>l5<c-w><<c-w>h
" When 3 vertial windows open, make the left two slightly bigger
nnoremap ,ch <c-w>h5<c-w>><c-w>l10<c-w>>

" Settings for VimClojure
let vimclojure#HighlightBuiltins=1      " Highlight Clojure's builtins
let vimclojure#ParenRainbow=1

"Completion
set complete=.,w,b,u,U,t,i,d

filetype plugin indent on
set nosmartindent

" Use the same symbols as TextMate for tabstops and EOLs
set list
set listchars=tab:▸\ ,trail:‽ ",eol:¬

"Invisible character colors
highlight NonText guifg=#555555 ctermfg=238
highlight SpecialKey guifg=#cd0000 

"Highlight matching paren
highlight MatchParen ctermbg=8

"Highlight visual selection background dark-grey
highlight Visual ctermbg=236 guibg=#444444

"highlight current line
set cul
highlight CursorLine term=none cterm=none ctermbg=235

" Untested diff highlighting
highlight DiffAdd ctermbg=green
highlight DiffDelete ctermbg=red
highlight DiffChange ctermbg=yellow

set cc=80
highlight ColorColumn ctermbg=235 guibg=#222222

" Fix clipboard for tmux on mac
set clipboard=unnamed

"Macvim remove toolbar
if has("gui_running")
    set guifont=Droid\ Sans\ Mono:h14
    set guioptions=egmt
    " STOP BLINKING, YOU PIECE OF ----
    set guicursor=a:blinkon0
endif
"colors peaksea
