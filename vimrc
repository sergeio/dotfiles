call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-surround'
Plug 'kien/ctrlp.vim'
Plug 'Vimjas/vim-python-pep8-indent', { 'for': 'python' }
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'dense-analysis/ale'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
call plug#end()

set number "linenumbers
set noerrorbells visualbell t_vb=

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

" keep at least 5 lines to the left/right, above/below
set scrolloff=5
set sidescrolloff=5
set sidescroll=1

set undolevels=1000                 "1000 undos

"Don't want backup files
set nobackup
set nowritebackup
set noswapfile

set nosmartindent
set tags=tags,./tags,~/fun/tags
filetype plugin indent on

" Use the same symbols as TextMate for tabstops and EOLs
set list
set listchars=tab:▸\ ,trail:‽ ",eol:¬

" Fix clipboard for tmux on mac
set clipboard^=unnamed,unnamedplus "'nix

" Ale is a linting plugin
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'typescript': ['tslint', 'tsserver'],
\   'typescriptreact': ['tslint', 'tsserver'],
\}
nmap ,aa :ALEToggle<CR>
nmap ,aj :ALENext<CR>
nmap ,ak :ALEPrevious<CR>

let g:ale_echo_msg_format = '[%linter%] %code%: %s'
highlight clear SignColumn

" Automatically read buffer from disk if unchanged
" Poll for changes
set autoread
if ! exists('g:CheckUpdateStarted')
    let g:CheckUpdateStarted=1
    call timer_start(1,'CheckUpdate')
endif
function! CheckUpdate(timer)
    " checktime errors if the command-line history window is open
    if !bufexists("[Command Line]")
        checktime
    endif
    call timer_start(1000,'CheckUpdate')
endfunction

autocmd FileType html setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd FileType scheme setlocal tabstop=2 softtabstop=2 shiftwidth=2

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

imap jk <esc>
imap JK <esc>
imap Jk <esc>
imap <c-a> <c-o>I
imap <c-e> <c-o>A

"Disable accidentally scrolling on the touchpad when typing
"(tmux maps scrolling to arrow keys when mouse=off,
"and I can't find how to disable that)
inoremap <up> <Nop>
inoremap <down> <Nop>
noremap <up> <Nop>
noremap <down> <Nop>

noremap q: <Nop>

"tab completion of filenames fix (from allanc)
set wildmode=longest,list,full
set wildmenu
" Don't suggest pyc files
set wildignore+=*.pyc

"Completion
set complete=.,w,b,u,U,t
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
nnoremap <silent> <CR> i<CR><esc>l

" pprint mapping
nmap \\p :s/\vprint (.*)/pprint\(\1\)<CR>mxOfrom pprint import pprint<esc>`x
nmap \\P :s/\vpprint\((.*)\)/print \1/<CR>kdd

" forgot sudo?
cmap W!! %!sudo tee > /dev/null %

" Emacs bindings in command line mode
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <c-f> <right>
cnoremap <c-b> <left>

map - gc
map _ gc

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

" Create newlines and stay in Normal Mode
nnoremap <silent> <Space>j mxo<Esc>`x
nnoremap <silent> <Space>k mxO<Esc>`x

" if executable("ag")
"     let g:ctrlp_user_command = "ag %s -i --nocolor --nogroup --ignore ''.git'' --ignore ''genfiles'' --hidden -g '' | python -c 'import sys; print \\"\\".join(sorted(sys.stdin, key=lambda l: len(l)))'"
"
" else
"     let g:ctrlp_user_command = {
"         \\ 'types': {
"           \\ 1: ['.git', 'cd %s && git ls-files . -co --exclude-standard'],
"           \\ 2: ['.hg', 'hg --cwd %s locate -I .'],
"         \\ },
"         \\ 'fallback': 'find %s -type f'
"     \\ }
" endif


let g:ctrlp_user_command = "ag %s -i --nocolor --nogroup --ignore ''.git'' --ignore ''genfiles'' --hidden -g '' | awk '{ print length, $0 }' | sort -n -s | cut -d' ' -f2-"
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:50'

map ,p :set paste!<CR>
map ,t :CtrlP<CR>
map ,b :CtrlPBuffer<CR>
map ,j :CtrlPLine<CR>
map ,g :CtrlPTag<CR>
nmap ,l :set list!<CR>
nmap ,L yiwoconsole.log('!',);jkhPbi jkbllPk0wj
nnoremap ,w :w\|make unit-test<cr>
nnoremap ,ev :65vs $MYVIMRC<cr>
nnoremap ,so :w\|source %\|nohlsearch<cr>
nnoremap ,S :set spell!<CR>

" Remove all trailing whitespace in file
nmap ,ss :%s/ \+$//<CR>

" When 3 vertial windows open, make current one slightly bigger
nnoremap ,cc <c-w>h5<c-w><2<c-w>l5<c-w><<c-w>h
" When 3 vertial windows open, make the left two slightly bigger
nnoremap ,ch <c-w>h5<c-w>><c-w>l10<c-w>>

" Settings for VimClojure
let vimclojure#HighlightBuiltins=1      " Highlight Clojure's builtins
let vimclojure#ParenRainbow=1

au BufRead,BufNewFile *.clj set filetype=clojure
au BufRead,BufNewFile *.py set filetype=python

" Settings for vim-markdown
let g:vim_markdown_folding_disabled=1

" wrap markdown bullet points correctly
nmap ,= :norm ==gqj<CR>

nmap ,+ vip >gv:norm ,=<CR>>>

nmap ,d o<CR>                                  ...........<CR><esc>

nmap ,v :s/TODO/✓ DONE/<CR>:nohlsearch<Bar>:echo<CR>

"Macvim remove toolbar
if has("gui_running")
    set guifont=Droid\ Sans\ Mono:h14
    set guioptions=egmt
endif

imap IFF if __name__ == '__main__':<CR>main()<ESC>kOdef main():<CR>

" Can use this Input function to pause macros by going into insert mode,
" ^r=Input()
" Useful for eg showing you a before/after, ensuring correctness
function! Input()
    call inputsave()
    let text = input('prompt> ')
    call inputrestore()
    return text
endfunction

" Colors

silent! colors slate
silent! colors jellybeans
silent! colors jellybeansmod

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

if exists("+colorcolumn")
    set cc=80
    highlight ColorColumn ctermbg=235 guibg=#222222
endif
