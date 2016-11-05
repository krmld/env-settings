syntax enable
set background=dark
colorscheme nss                 " Custom colorscheme

set mouse=a                     " Automatically enable mouse usage
set mousehide                   " Hide the mouse cursor while typing
set nu                          " Sets numberlines
set nowrap                      " Do not wrap long lines
set autoindent                  " Indent at the same level of the previous line
set sidescroll=1

set hlsearch                    " Sets highlighting of matches
set incsearch                   " Find as you type search
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set scrolljump=1                " Lines to scroll when cursor leaves screen
set scrolloff=2                 " Minimum lines to keep above and below cursor
set foldenable                  " Auto fold code
set list
set listchars=tab:›\ ,trail:•,extends:▶,nbsp:. " Highlight problematic whitespace

set hidden                          " Allow buffer switching without saving
set diffopt=vertical

set tabstop=4       " The width of a TAB is set to 4.
set shiftwidth=4    " Indents will have a width of 4
set softtabstop=4   " Sets the number of columns for a TAB
"set textwidth=8o

" Folding
set foldmethod=indent
set foldcolumn=1
set foldlevel=2


" Remap to open file under cursor in new tab
nnoremap gf <C-W>gf

" Pasting with in insert mode
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
	set pastetoggle=<Esc>[201~
	set paste
	return ""
endfunction

" Instead of reverting the cursor to the last position in the buffer, we
" set it to the first line when editing a git commit message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

" http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
		function! ResCur()
				if line("'\"") <= line("$")
						silent! normal! g`"
						return 1
				endif
		endfunction

		augroup resCur
				autocmd!
				autocmd BufWinEnter * call ResCur()
		augroup END

runtime macros/matchit.vim
filetyp plugin on

" Show syntax highlighting groups for word under cursor
nmap <C-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

	if has("user_commands")
			command! -bang -nargs=* -complete=file E e<bang> <args>
			command! -bang -nargs=* -complete=file W w<bang> <args>
			command! -bang -nargs=* -complete=file Wq wq<bang> <args>
			command! -bang -nargs=* -complete=file WQ wq<bang> <args>
			command! -bang Wa wa<bang>
			command! -bang WA wa<bang>
			command! -bang Q q<bang>
			command! -bang QA qa<bang>
			command! -bang Qa qa<bang>
	endif

" Use of the filetype plugins, auto completion and indentation support
filetype plugin indent on

" file type specific settings
if has("autocmd")

	" if bash is sh.
	let bash_is_sh=1

	" change to directory of current file automatically
	autocmd BufEnter * lcd %:p:h


	" Put these in an autocmd group, so that we can delete them easily.
	augroup mysettings
	au FileType xslt,xml,css,html,xhtml,sh,config,c,cpp,docbook,javascript set smartindent shiftwidth=2 softtabstop=2 expandtab
	au FileType css set omnifunc=csscomplete#CompleteCSS
	au FileType tex set wrap shiftwidth=2 softtabstop=2 expandtab

	autocmd FileType html hi Identifier ctermfg=NONE
	autocmd FileType html hi Function   ctermfg=NONE

	" PHP settings
	autocmd FileType php set omnifunc=phpcomplete#CompletePHP
	autocmd FileType php set keywordprg=pman

	" JS
	autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS

	" Remove trailing whitespaces
	autocmd FileType bash,javascript,c,cpp,java,php,python autocmd BufWritePre <buffer> %s/\s\+$//e

	" Confirm to PEP8
	au FileType python set tabstop=4 softtabstop=4 expandtab shiftwidth=4 cinwords=if,elif,else,for,while,try,except,finally,def,class
	augroup END

	" Always jump to the last known cursor position.
	" Don't do it when the position is invalid or when inside
	" an event handler (happens when dropping a file on gvim).
	autocmd BufReadPost *
	\ if line("'\"") > 0 && line("'\"") <= line("$") |
	\   exe "normal g`\"" |
	\ endif

endif " has("autocmd")

" Grep word under the cursor
map <F4> :execute " grep -srnw --binary-files=without-match --exclude-dir=.git  . -e " . expand("<cword>") . " " <bar> cwindow<CR>