"  ================================================================
" |                                                                |
" |  \ \    / (_)          / ____|           / _|    / ____|       |       
" |   \ \  / / _ _ __ ___ | |     ___  _ __ | |_    | |  __  ___   |
" |    \ \/ / | | '_ ` _ \| |    / _ \| '_ \|  _|   | | |_ |/ _ \  |
" |     \  /  | | | | | | | |___| (_) | | | | |     | |__| | (_) | |
" |      \/   |_|_| |_| |_|\_____\___/|_| |_|_|      \_____|\___/  |
" |                                                                |
"  ================================================================
syntax on
syntax enable
filetype plugin on
filetype indent on

set number
set relativenumber
set autoindent
set showmatch
set ruler
set nowrap
set nocompatible
" Only lower case, ignore case.
set ignorecase 
" Switch to case-sensitive if there are both upper and lower.
set smartcase 

" highlight search
set hlsearch
nmap <silent>,,    :nohl<CR>

" tab config
set tabstop=4
set shiftwidth=4

" Cursor
set cursorline
set cursorcolumn

" Share clipboard between macOS and vim.
set clipboard^=unnamed,unnamedplus

" ---------------------------- Algo competition ----------------------- "
" Template Files
autocmd BufNewFile *.cc 0r ~/algo_competition/Template/template_algo.cc
autocmd BufNewFile *.py 0r ~/algo_competition/Template/template_algo_simple.py

" Run Cmd 'py file.py < input' by '<F5>'
autocmd FileType python nnoremap <F5> :w <bar> exec '!pypy3 '.shellescape('%').' < input'<CR>
" Copy the entire file contents to system clipboard by '<F4>'
nnoremap <silent> <F4> :execute "normal! ggVGy"<CR>
" --------------------------------------------------------------------- "


" vim-plug
call plug#begin()
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'morhetz/gruvbox'
	" Installed: coc-json, coc-clangd, coc-go
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'preservim/nerdtree'
	Plug 'jistr/vim-nerdtree-tabs'
	Plug 'ryanoasis/vim-devicons'
	Plug 'tpope/vim-commentary'
	Plug 'skywind3000/vim-quickui'
	Plug 'dyng/ctrlsf.vim'
	" Plug 'godlygeek/tabular'
	" Plug 'preservim/vim-markdown'
	
	" Need to compile vim by source code to support python or python3.
	" Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
	
	Plug 'preservim/tagbar'
call plug#end()

nmap <F8> :TagbarToggle<CR>

" ---------------------------- theme begin ----------------------- "
" colorscheme gruvbox
set background=dark
let g:airline_theme='violet'
"let g:airline_theme='light'
" ---------------------------- theme end ----------------------- "

" ---------------------------- vim-commentary begin ----------------------- "
let filetype_comment = {
  \ 'vim': '\"\ %s',
  \ 'cpp': '//\ %s',
  \ 'hpp': '//\ %s',
  \ 'cc': '//\ %s',
  \ 'go': '//\ %s',
  \ 'py': '#\ %s',
  \ 'c': '//\ %s',
  \ 'h': '//\ %s',
  \ }

for [file_type, commet_string] in items(filetype_comment)
	exec 'autocmd FileType ' . file_type . ' set commentstring=' . commet_string
endfor
" ---------------------------- vim-commentary end ----------------------- "

" ---------------------------- airline begin ---------------------------- "
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

nnoremap <silent><C-L>    :bn!<CR>
nnoremap <silent><C-H>    :bp!<CR>
" ---------------------------- airline end ---------------------------- "

" ---------------------------- nerdtree begin ---------------------------- "
" https://github.com/preservim/nerdtree
nnoremap ; :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Start NERDTree when Vim is started without file arguments.
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" Start NERDTree. If a file is specified, move the cursor to its window.
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" ---------------------------- nerdtree end ---------------------------- "

" ---------------------------- quickui begin ---------------------------- "
" let g:quickui_color_scheme = 'gruvbox'
" let g:quickui_color_scheme = 'solarized'
" let g:quickui_color_scheme = 'papercol light'
let g:quickui_color_scheme = 'papercol dark'
let g:quickui_border_style = 5

function! TermExit(code) 
    echom "terminal exit code: ". a:code
endfunc

function! s:open_python() abort
	let opts = {'w':100, 'h':40, 'callback':'TermExit'}
	let opts.title = 'Terminal Popup'
	call quickui#terminal#open('python3', opts)
endfunc

function! s:open_term(cmd) abort
	let opts = {'w':100, 'h':40, 'callback':'TermExit'}
	let opts.title = a:cmd
	call quickui#terminal#open(a:cmd, opts)
endfunc

function! s:display_help(filename) abort
	if !filereadable(a:filename)
		call quickui#utils#errmsg('E484: Sorry, cannot open file ' . a:filename)
		return -3
	endif
	let content = readfile(a:filename)
	let opts = {'syntax':'help', 'color':'QuickPreview', 'close':'button'}
	let opts.title = 'Help: ' . fnamemodify(a:filename, ':t')
	let opts.command = ["exec 'nohl'"]
	let opts.command += ["normal zz"]
	let opts.w = 90
	let opts.h = 43
	" echom opts
	let winid = quickui#textbox#open(content, opts)
	return 0
endfunc


nnoremap <silent><leader>py :call <SID>open_term('python3')<CR>
nnoremap <silent><F2>   :call <SID>open_term('zsh')<CR>
nnoremap <silent><F1>	:call <SID>display_help($HOME . '/.vim/HELP.md')<CR>
" ---------------------------- quickui end ---------------------------- "

" ---------------------------- Coc-nvim begin ---------------------------- "

" https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.vim

" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
set encoding=utf-8
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=no

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <C-K>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "<C-K>" :
      \ coc#refresh()
inoremap <expr><C-J> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

hi CocMenuSel ctermbg=Blue
"hi CocMenuSel ctermbg=Blue guibg=Black
hi CocFloating ctermbg=DarkGrey
"hi CocFloating ctermbg=13
hi CocSearch ctermfg=Cyan
"hi CocSearch ctermfg=Black guifg=#FF0000

" ---------------------------- Coc-nvim end ---------------------------- "

" ---------------------------- CtrlSF begin ---------------------------- "
let g:ctrlsf_auto_focus = {
			\ "at" : "done",
			\ "duration_less_than": 1000
			\ }

let g:ctrlsf_mapping = {
			\ "next": "n",
			\ "prev": "N",
			\ "tab": "",
			\ "tabb": "",
			\ "popen": "",
			\ "popenf": "",
			\ }

let g:ctrlsf_ignore_dir = ['bin', 'lib', '.svn', '.git', '.hg', '.obj', 
			\ '*.bak', '*.xml', '*.pb.*', 'xmlconfig_*', '*.tbx', 
			\ '*.mps', '*.dat', '*.pid', '*.log.*', '*.log', '*.pyc' ]

function! s:ctrlsf_find_by_filetype()
	exec 'CtrlSF -filetype ' . &filetype . ' ' . expand("<cword>")
endfunction

function! s:ctrlsf_find()
	exec 'CtrlSF -W -S ' . expand("<cword>")
endfunction

nnoremap <silent>f :CtrlSFToggle<CR>
nnoremap <silent>F	:call <SID>ctrlsf_find()<CR>
nnoremap <silent><F3> :call <SID>ctrlsf_find()<CR>
" ---------------------------- CtrlSF end ---------------------------- "

