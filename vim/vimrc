" =======
" PLUGINS
" =======
" Plugins will be downloaded under the specified directory.
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

function! Cond(Cond, ...)
  let opts = get(a:000, 0, {})
  return a:Cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-sensible', Cond(!exists('g:vscode'))
Plug 'tpope/vim-fugitive', Cond(!exists('g:vscode'))
Plug 'tpope/vim-sleuth', Cond(!exists('g:vscode'))
Plug 'preservim/nerdtree', Cond(!exists('g:vscode'))
if !exists('g:vscode')
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'iamcco/coc-tailwindcss',  {'do': 'yarn install --frozen-lockfile && yarn run build'}
endif
Plug 'junegunn/fzf.vim', Cond(!exists('g:vscode'))
Plug 'airblade/vim-gitgutter', Cond(!exists('g:vscode'))
if !has('win32')
  Plug 'thaerkh/vim-workspace', Cond(!exists('g:vscode'))
endif
Plug 'vim-airline/vim-airline', Cond(!exists('g:vscode'))
Plug 'vim-airline/vim-airline-themes', Cond(!exists('g:vscode'))
Plug 'morhetz/gruvbox', Cond(!exists('g:vscode'))
Plug 'easymotion/vim-easymotion', Cond(!exists('g:vscode'))
Plug 'ryanoasis/vim-devicons', Cond(!exists('g:vscode'))
if !exists('g:vscode')
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
end
Plug 'bkad/CamelCaseMotion', Cond(!exists('g:vscode'))
if has('nvim')
  Plug 'github/copilot.vim', Cond(!exists('g:vscode'))
endif
Plug 'mattn/emmet-vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" ========
" SETTINGS
" ========

" vim
" set termguicolors
set encoding=UTF-8
set background=dark
let g:gruvbox_italic=1
color gruvbox
set cul
set guifont=Dank\ Mono,DejaVu\ Sans\ Mono,Hack\ Nerd\ Font\ Mono,Iosevka,PowerlineSymbols:h18

" https://stackoverflow.com/a/1878984/2057996
set tabstop=2       " The width of a TAB is set to 2.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 2.

set shiftwidth=2    " Indents will have a width of 2

set softtabstop=2   " Sets the number of columns for a TAB

set expandtab       " Expand TABs to spaces

" Give more space for displaying messages.
set cmdheight=2

set number
let mapleader = ","

" cursor change for insert mode
" https://stackoverflow.com/a/42118416/2057996
let &t_SI = "\e[3 q"
let &t_EI = "\e[2 q"

" reset the cursor on start (for older versions of vim, usually not required)
augroup myCmds
au!
autocmd VimEnter * silent !echo -ne "\e[2 q"
augroup END

" Show tab line when there is only one file open
set showtabline=2

" Update sign column every quarter second
set updatetime=250

" Some language servers have issues with backup files, see https://github.com/neoclide/coc.nvim/issues/349.
set nobackup
set nowritebackup

" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" airline
let g:airline_powerline_fonts = 1

" CoC
let g:coc_global_extensions = [
  \ 'coc-html',
  \ 'coc-json',
  \ 'coc-phpls',
  \ 'coc-prettier',
  \ 'coc-python',
  \ 'coc-rust-analyzer',
  \ 'coc-sh',
  \ 'coc-sql',
  \ 'coc-stylelintplus',
  \ 'coc-svg',
  \ 'coc-toml',
  \ 'coc-tsserver',
  \ 'coc-vimlsp',
  \ 'coc-xml',
  \ 'coc-yaml', 
  \ 'coc-pairs'
  \ ]

" coc formatting
command! -nargs=0 Prettier :CocCommand prettier.formatFile
command! -nargs=0 Format :call CocAction('format')
autocmd FileType php nnoremap <C-I> :Format<CR>
autocmd FileType php nnoremap <C-S-i> :Format<CR>
autocmd FileType rust nnoremap <C-I> :!cargo fmt<CR>
autocmd FileType rust nnoremap <C-S-i> :!cargo fmt<CR>
nnoremap <C-I> :Prettier<CR>
nnoremap <C-S-i> :Prettier<CR>

" neovide
let g:neovide_transparency = 0.97
let g:neovide_cursor_vfx_mode = "pixiedust"

" NERDTree
" Quit NERDTree after opening a file https://stackoverflow.com/a/14761218
let NERDTreeQuitOnOpen=1

" Map open in new tab to <C-t>
let NERDTreeMapOpenInTab='<C-t>'

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

" Open the existing NERDTree on each new tab.
" autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif

" NERDcommenter
" Create default mappings
let g:NERDCreateDefaultMappings = 1

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" vim-gitgutter
" Use fontawesome icons as signs
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '>'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = '<'
let g:gitgutter_diff_args = '-w'

" Cycle through all hunks in the buffer
function! GitGutterNextHunkCycle()
  let line = line('.')
  silent! GitGutterNextHunk
  if line('.') == line
    1
    GitGutterNextHunk
  endif
endfunction

function! GitGutterPrevHunkCycle()
  let line = line('.')
  silent! GitGutterPrevHunk
  if line('.') == line
    normal! G
    GitGutterPrevHunk
  endif
endfunction

" Set background color of sign column to general bg color
let g:gitgutter_override_sign_column_highlight = 1
highlight SignColumn guibg=bg
highlight SignColumn ctermbg=bg

" vim-workspace
" save all session files to ~/.vim/sessions
let g:workspace_session_directory = $HOME . '/.vim/sessions/'

" =======
" KEYMAPS
" =======

" vim
nnoremap <C-t> :tabnew<CR>
nnoremap t :tabnext<CR>
nnoremap T :tabprev<CR>
nnoremap <Leader>t- :split term://zsh<CR>
nnoremap <Leader>t\| :vsplit term://zsh<CR>
nnoremap <Leader>T :e term://zsh<CR>
nnoremap <C-w>- :split<CR>
nnoremap <C-w>\| :vsplit<CR>
nnoremap <Leader>h <C-W>10<
nnoremap <Leader>j <C-W>10+
nnoremap <Leader>k <C-W>10-
nnoremap <Leader>l <C-W>10>
" tnoremap <Esc> <C-\><C-n> " this breaks <Esc> from silver searcher

" good concept, not good for me in practice...
" inoremap " ""<left>
" inoremap ' ''<left>
" inoremap ( ()<left>
" inoremap [ []<left>
" inoremap { {}<left>
" inoremap {<CR> {<CR>}<ESC>O
" inoremap {;<CR> {<CR>};<ESC>O

" coc
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
if exists('g:vscode')
  nmap <silent> <Leader>e :call VSCodeCall('editor.action.marker.next')<CR>
  nmap <silent> <Leader>E :call VSCodeCall('editor.action.marker.prev')<CR>
else
  nmap <silent> <Leader>e <Plug>(coc-diagnostic-next)
  nmap <silent> <Leader>E <Plug>(coc-diagnostic-prev)
endif

" GoTo code navigation.
if exists('g:vscode')
  nmap <silent> gd :call VSCodeCall('editor.action.revealDefinition')<CR>
else
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gD <Plug>(coc-references)
endif

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
nmap <F2> <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)

" NERDTree keymaps
" alt+b
" first binding is a terminal hack...
nnoremap <Esc>b :NERDTreeToggle<CR>
nnoremap <M-b> :NERDTreeToggle<CR>
nnoremap <Esc>B :NERDTreeFind<CR>
nnoremap <M-B> :NERDTreeFind<CR>
" nnoremap <expr> <Esc>b g:NERDTree.IsOpen() ? ":NERDTreeClose<CR>" : bufname('%') ? ":NERDTreeFind<CR>" : ":NERDTree<CR>"
" nnoremap <expr> <M-b> g:NERDTree.IsOpen() ? ":NERDTreeClose<CR>" : bufname('%') ? ":NERDTreeFind<CR>" : ":NERDTree<CR>"

" NERDcommenter keymaps
" ctrl+/
" first binding is a terminal hack...
map <C-_> <plug>NERDCommenterToggle
map <C-/> <plug>NERDCommenterToggle

" FZF
" ctrl+p
nnoremap <C-p> :NERDTreeClose<CR>:FZF<CR>
nnoremap <C-F> :NERDTreeClose<CR>:Ag<CR>
nnoremap <C-S-f> :NERDTreeClose<CR>:Ag<CR>

" vim-gitgutter
" Cycle through hunks
if exists('g:vscode')
  nmap <silent> <Leader>n :call VSCodeCall('workbench.action.editor.nextChange')<CR>
  nmap <silent> <Leader>N :call VSCodeCall('workbench.action.editor.previousChange')<CR>
else
  nmap <Leader>n :call GitGutterNextHunkCycle()<CR>
  nmap <Leader>N :call GitGutterPrevHunkCycle()<CR>
endif

" Hunk-add and hunk-revert for chunk staging
nmap <Leader>ga <Plug>(GitGutterStageHunk)
nmap <Leader>gu <Plug>(GitGutterUndoHunk)

" Hunk preview
nmap <silent> <Leader><space> :GitGutterPreviewHunk<CR>

" vim-workspace
nnoremap <leader>s :ToggleWorkspace<CR>

" CamelCaseMotion
let g:camelcasemotion_key = ';'

" Github Copilot
imap <silent><script><expr> <C-L> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

" Emmet
let g:user_emmet_settings = {
\  'typescript.tsx' : {
\      'extends' : 'jsx',
\  },
\  'javascript.jsx' : {
\      'extends' : 'jsx',
\  },
\}
