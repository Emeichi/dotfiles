source $VIMRUNTIME/defaults.vim

" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2015 Mar 24
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

set fileencodings=utf-8,cp932
set laststatus=2

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
"
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

"if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
"else
"  set backup		" keep a backup file (restore to previous version)
"  set undofile		" keep an undo file (undo changes after closing)
"endif

set history=200		" keep 200 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

set cursorline

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 80 characters.
  "autocmd FileType text setlocal textwidth=80

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langnoremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If unset (default), this may break plugins (but it's backward
  " compatible).
  set langnoremap
endif

" Set Bottom Command Height
set cmdheight=1

" Show Line Number
set number

" Set Tab Width
set tabstop=4
set shiftwidth=4

" Set Window Size
set columns=140
set lines=40

" スワップファイル
set noswapfile

" バックアップファイルは使わない
"set nobackup

" アンドゥファイルは使わない
set noundofile

" コマンドラインモードで<Tab>キーによるファイル名補完を有効にする
set wildmenu

" 対応する括弧やブレースを表示する
set showmatch

" abc → 大文字小文字を無視して検索
" Abc → 大文字小文字を区別して検索
set ignorecase
set smartcase

" 長い行を折り返さない
set nowrap

" 開いているファイルのディレクトリに移動する
set autochdir

"--------------------------------------------------------------------------
" 挿入モード時、ステータスラインの色を変更する
let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'

if has('syntax')
	augroup InsertHook
		autocmd!
		autocmd InsertEnter * call s:StatusLine('Enter')
		autocmd InsertLeave * call s:StatusLine('Leave')
	augroup END
endif

let s:slhlcmd = ''
function! s:StatusLine(mode)
	if a:mode == 'Enter'
		silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
		silent exec g:hi_insert
	else
		highlight clear StatusLine
		silent exec s:slhlcmd
	endif
endfunction

function! s:GetHighlight(hi)
	redir => hl
	exec 'highlight '.a:hi
	redir END
	let hl = substitute(hl, '[\r\n]', '', 'g')
	let hl = substitute(hl, 'xxx', '', '')
	return hl
endfunction

"--------------------------------------------------------------------------
" 全角半角を可視化する
function! ZenkakuSpace()
	highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
endfunction

if has('syntax')
	augroup ZenkakuSpace
		autocmd!
		autocmd ColorScheme * call ZenkakuSpace()
		autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('ZenkakuSpace', '　')
	augroup END
	call ZenkakuSpace()
endif

"-------------------------------------------------------------------------
" grep
"set grepprg=grep\ -n
"let $PATH .= ';C:\Program Files\Git\usr\bin'
if has("win32")
	let Grep_Path = ';C:\Program Files\Git\usr\bin\grep.exe'
	let Grep_Xargs_Path = ';C:\Program Files\Git\usr\bin\xargs.exe'
	let Grep_Find_Path = ';C:\Program Files\Git\usr\bin\find.exe'
	let Grep_Shell_Quote_Char = '"'
endif

"--------------------------------------------------------------------------
" 以下、キーマップ
"--------------------------------------------------------------------------

nmap ZZ <NOP>

"nnoremap [MyOperation] <NOP>
"nemap <SPACE>m [MyOperation]

inoremap <C-l> <ESC>
"inoremap fd <ESC>
"inoremap jk <C-o>

nnoremap <C-l> <ESC>
nnoremap <SPACE>h ^
nnoremap <SPACE>l $
"nnoremap <C-w> <C-w>w
nnoremap <C-TAB> gt
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
"nnoremap o A<CR><ESC>
"nnoremap c caw
nnoremap gp "*p
nnoremap gyy ^v$"*y
nnoremap gdd ^v$"*d

vnoremap <C-l> <ESC>
"vnoremap " xi""<ESC>hp<RIGHT>
"vnoremap ' xi''<ESC>hp<RIGHT>
vnoremap * "zy:let @/ = @z<CR>n
vnoremap gy "*y
vnoremap gp "*p

"--------------------------------------------------------------------------
" NERDTree
"--------------------------------------------------------------------------
nnoremap [NERDTree] <Nop>
nmap <SPACE>n [NERDTree]

execute 'set runtimepath^=' . '$VIM/.cache/github.com/scrooloose/nerdtree'
nnoremap [NERDTree]n :NERDTree<CR>

"--------------------------------------------------------------------------
" unite.vim
"--------------------------------------------------------------------------
nnoremap [unite] <Nop>
nmap <SPACE>u [unite]

execute 'set runtimepath^=' . '$VIM/.cache/github.com/Shougo/unite.vim'
"let g:unite_enable_start_insert = 1

nnoremap [unite]b :Unite buffer<CR>
"noremap <C-N> :Unite -buffer-name=file file<CR>
"noremap <C-Z> :Unite file_mru<CR>
noremap [unite]f :<C-u>UniteWithBufferDir file -buffer-name-file<CR>

au FileType unite nnoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
au FileType unite nnoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>

