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
set t_Co=256
" colorscheme koehler
" colorscheme desert
" colorscheme monokai

call plug#begin('~/.vim/plugged')

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

Plug 'preservim/nerdtree'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

" All of your Plugins must be added before the following line
call plug#end()

" 显示行号
set number

set cursorline
highlight CursorLine cterm=NONE ctermbg=235 ctermfg=NONE guibg=NONE guifg=NONE
set cursorcolumn
highlight CursorColumn cterm=NONE ctermbg=235 ctermfg=NONE guibg=NONE guifg=NONE

set tabstop=4		" tab缩进
set shiftwidth=4	
set backspace=2		" 启用Backspace键

set showmatch		" 显示括号匹配
set incsearch		" 搜索逐字符高亮
set foldenable		" 开启折叠
set ignorecase		" 搜索时忽略大小写

set laststatus=2  	" 永远显示状态栏

set pastetoggle=<F10>

" =============================================================================
" ================================ vim-go =====================================
" =============================================================================
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_methods = 1
let g:go_highlight_build_constarints = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1

let g:go_fold_enable = ['block', 'import', 'varconst', 'package_comment']
let g:go_fold_enable = ['import']
let g:go_highlight_build_constraints = 1

" =============================================================================
" ============================== nerdtree =====================================
" =============================================================================
map <F2> :NERDTreeToggle<CR>

let g:NERDTreeDirArrowExpandable='+'
let g:NERDTreeDirArrowCollapsible='-'
" 打开vim时，如果没有文件自动打开NERDTree
autocmd vimenter * if !argc()|NERDTree|
" 当NERDTree为剩下的唯一窗口时自动关闭
autocmd bufenter * if(winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" 打开vim自动打开NERDTree
autocmd vimenter * NERDTree

" =============================================================================
" ============================== airline ======================================
" =============================================================================
let g:airline#extensions#tabline#enabled = 1   		" 是否打开tabline
let g:airline_powerline_fonts = 1
let g:airline_theme='bubblegum' 					"选择主题
let g:airline#extensions#tabline#enabled=1    		"Smarter tab line:

let g:airline_left_sep = '▶'
let g:airline_left_alt_sep = '>'
let g:airline_right_sep = '◀'
let g:airline_right_alt_sep = '<'

" =============================================================================
" ================================ ctags ======================================
" =============================================================================

map <F5> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR> :TlistUpdate<CR>
imap <F5> <ESC>:!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR> :TlistUpdate<CR>
set tags=tags
set tags+=./tags


" =============================================================================
" ================================ coc.nvim ===================================
" =============================================================================
let g:coc_global_extensions = ['coc-go', 'coc-clangd', 'coc-python', 'coc-jedi', 'coc-cfn-lint', 'coc-sumneko-lua']

" Set internal encoding of vim, not needed on neovim, since coc.nvim using
" some
" unicode characters in the file autoload/float.vim
set encoding=utf-8

" textedit might fail if hidden is not set.
set hidden

" some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" give more space for displaying messages.
set cmdheight=2

" having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" don't pass messages to |ins-completion-menu|.
set shortmess+=c

" always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
	" recently vim can merge signcolumn and number column into one
	set signcolumn=number
else
	set signcolumn=yes
endif


" *********************************************************************
" ======================== 文件头模板 =================================
" *********************************************************************
" 对于指定的文件类型自动插入文件头模板
" autocmd BufNewFile *.go exec ":call WESTOS()"
" F9手动插入
map <F9> ms:call WESTOS() <cr>'s
function WESTOS()
	call append(0, "//################################################")
	call append(1, "// Author:		leolin49					     #")
	call append(2, "// CreateTime:	".strftime("%Y-%m-%d %H:%M:%S")."				 #")
	call append(3, "// Mail:    	leolin49@foxmail.com			 #")
	call append(4, "// Description:	                                 #")
	call append(5, "//                                               #")
	call append(6, "//                                               #")
	call append(7, "//################################################")
endfunction
