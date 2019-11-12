call plug#begin('~/.vim/plugged')
Plug 'nvie/vim-flake8', { 'for': 'python' }
Plug 'Vimjas/vim-python-pep8-indent', { 'for': 'python' }
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'kien/ctrlp.vim'
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'mxw/vim-jsx', { 'for': ['jsx', 'js'] }
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
Plug 'peitalin/vim-jsx-typescript', { 'for': 'typescript' }
" Plug 'jiangmiao/auto-pairs'
call plug#end()

set number "linenumbers
set noerrorbells visualbell t_vb=

" default to slate, but use wombad256 if it's available
silent! colors slate
silent! colors wombat256mod

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

autocmd FileType html setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd FileType scheme setlocal tabstop=2 softtabstop=2 shiftwidth=2
" autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2

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

"mouse support
"set mouse=a

"Disable accidentally scrolling on the touchpad when typing
"(tmux maps scrolling to arrow keys when mouse=off,
"and I can't find how to disable that)
inoremap <up> <Nop>
inoremap <down> <Nop>
noremap <up> <Nop>
noremap <down> <Nop>

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
"
" pdb mapping
nmap \b mxoimport pdb; pdb.set_trace()<esc>`x

" Convert an a/b fraction into \frac{a}/{b}
nmap ,f i\frac{jklxf/Pf/s{jklxhEa}jkww

" pprint mapping
nmap \\p :s/\vprint (.*)/pprint\(\1\)<CR>mxOfrom pprint import pprint<esc>`x
nmap \\P :s/\vpprint\((.*)\)/print \1/<CR>kdd

" turn line into markdown link
" nmap ,k 0y$i[jkA](jkpA)jk
nmap ,K 0y$i[jkA](jkpA)jkI  * <esc>lci[
nmap ,k O<esc>:.!link_extractor<CR>

" forgot sudo?
cmap W!! %!sudo tee > /dev/null %

" Emacs bindings in command line mode
cnoremap <c-a> <home>
cnoremap <c-e> <end>

" map _ :s/\\v^(\\s*)# /\\1/<cr>:nohlsearch<cr>
" map - :s/\\v^(\\s*)(.+)/\\1# \\2/<cr>:nohlsearch<cr>
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

" Use sane regexes.
" nnoremap / /\\v
" vnoremap / /\\v

" Create newlines and stay in Normal Mode
nnoremap <silent> <Space>j mxo<Esc>`x
nnoremap <silent> <Space>k mxO<Esc>`x

" keep at least 5 lines to the left/right, above/below
set scrolloff=5
set sidescrolloff=5

set undolevels=1000                 "1000 undos

"Don't want backup files
set nobackup
set nowritebackup
set noswapfile

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
"

let g:ctrlp_user_command = "ag %s -i --nocolor --nogroup --ignore ''.git'' --ignore ''genfiles'' --hidden -g '' | awk '{ print length, $0 }' | sort -n -s | cut -d' ' -f2-"
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:50'

map ,p :set paste!<CR>
map ,t :CtrlP<CR>
map ,b :CtrlPBuffer<CR>
map ,j :CtrlPLine<CR>
map ,g :CtrlPTag<CR>
nmap ,l :set list!<CR>
nnoremap ,w :w\|make unit-test<cr>
nnoremap ,ev :65vs $MYVIMRC<cr>
nnoremap ,so :w\|source %\|nohlsearch<cr>
nnoremap ,S :set spell!<CR>

set tags=tags,./tags,~/fun/tags

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

filetype plugin indent on
set nosmartindent

" Use the same symbols as TextMate for tabstops and EOLs
set list
set listchars=tab:▸\ ,trail:‽ ",eol:¬

" Ale is a linting plugin
" let g:ale_linters = {'python': 'all'}
" let g:ale_echo_msg_format = '[%linter%] %s'
" highlight clear SignColumn

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

if exists("+colorcolumn")
    set cc=80
    highlight ColorColumn ctermbg=235 guibg=#222222
endif

" Fix clipboard for tmux on mac
"set clipboard=unnamed "mac
set clipboard^=unnamed,unnamedplus "'nix

"Macvim remove toolbar
if has("gui_running")
    set guifont=Droid\ Sans\ Mono:h14
    set guioptions=egmt
endif

imap IFF if __name__ == '__main__':<CR>main()<ESC>kOdef main():<CR>

map ,q <esc>:python indent_and_wrap_paragraph()<CR>
map ,. <esc>:python indent_markdown_list_item(1)<CR>
map ,, <esc>:python indent_markdown_list_item(-1)<CR>

" Can use this Input function to pause macros by going into insert mode,
" ^r=Input()
" Useful for eg showing you a before/after, ensuring correctness
function! Input()
    call inputsave()
    let text = input('prompt> ')
    call inputrestore()
    return text
endfunction

" python << EOF
" def indent_and_wrap_paragraph():
"     import vim
"     buffer = vim.current.buffer
"     vim.command('normal vipJ')
"     (row, _) = vim.current.window.cursor
" 
"     print row
" 
"     if row < len(buffer) and buffer[row]:
"         # For one-line "paragraphs", append a blank line to undo the `vipJ`
"         buffer[row:row] = ['']
" 
"     while row <= len(buffer) and buffer[row - 1]:
"         buffer[row - 1] = '    ' + buffer[row - 1].strip()
"         vim.current.window.cursor = row, 0
"         vim.command('normal gqlgqj')
"         row += 1
" EOF
" 
" python << EOF
" def indent_markdown_list_item(direction=1):
"     import vim
"     buffer = vim.current.buffer
"     (row, _) = vim.current.window.cursor
"     row -= 1
"     if not buffer[row]:
"         return
" 
"     bullets = '-+*'
"     leading_spaces = 0
"     while buffer[row][leading_spaces] == ' ':
"         leading_spaces += 1
"     if buffer[row][leading_spaces] not in bullets:
"         return
"     level = (leading_spaces / 2) - 1
"     new_bullet = bullets[(level + direction) % len(bullets)]
"     spaces = ' ' * (leading_spaces + 2 * direction)
"     buffer[row] = spaces + new_bullet + buffer[row][leading_spaces + 1:]
" EOF
