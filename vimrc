"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""               
"               
"               ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
"               ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
"               ██║   ██║██║██╔████╔██║██████╔╝██║     
"               ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║     
"                ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
"                 ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝
"               
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

".----------------------------------------------------------------------------.
"|                                                                            |
"| ░█▀▀░█▀▄░█▀█░█▄█░░░▀█▀░█░█░█▀▀░░░█░█░▀█▀░█▄█░░░█▀█░█▀▄░█▀█░▀▀█░█▀▀░█▀▀░▀█▀ |
"| ░█▀▀░█▀▄░█░█░█░█░░░░█░░█▀█░█▀▀░░░▀▄▀░░█░░█░█░░░█▀▀░█▀▄░█░█░░░█░█▀▀░█░░░░█░ |
"| ░▀░░░▀░▀░▀▀▀░▀░▀░░░░▀░░▀░▀░▀▀▀░░░░▀░░▀▀▀░▀░▀░░░▀░░░▀░▀░▀▀▀░▀▀░░▀▀▀░▀▀▀░░▀░ |
"|                                                                            |
"'----------------------------------------------------------------------------'
" The configurations below are from the Vim Project <https://github.com/vim/vim>
" Some of the original commands have been deleted by me, Sean. I have also
" inserted additional comments for context.


" Get the defaults that most users want, like showing cursor position. If you 
" don't have a vimrc file, then defaults.vim is opened automatically, but if
" you do have a vimrc, you have to include this. 
source $VIMRUNTIME/defaults.vim

" HANDLING BACKUP, UNDO, AND SWAP FILES (DEPRECATED)
" --------------------------------------------------
" vms means an OpenVMS system which is from the 80s/90s, which has its own way
" of managing files. You'll almost certainly never be running this on vms in
" your life, but it's standard so don't worry about it. 
" set backup keeps the file.txt~ which is a snapshot of your file before your
" most recent save
" set undofile keeps the file.txt.un~ which is your entire undo history
" file.txt.un~  which is the complete undo history

" if has("vms")
"   set nobackup		" do not keep a backup file, use versions instead
" else
"   set backup		" keep a backup file (restore to previous version)
"   if has('persistent_undo')
"     set undofile	" keep an undo file (undo changes after closing)
"   endif
" endif


" This lets you clear highlighting with <C-l> (Ctrl + l) after a search
if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
  nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
endif

" This code ensures that whenever you open a plain text file, your lines are
" automatically capped at 78 characters. This is a common practice to keep
" files readable without horizontal scrolling.
augroup vimrcEx
  au!
  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
augroup END

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

".------------------------------------------------------------------------.
"|                                                                        |
"| ░█▀▀░█▀▄░█▀█░█▄█░░░█▀▀░█▀▄░█▀▀░█▀▀░░░█▀▀░█▀█░█▀▄░█▀▀░░░█▀▀░█▀█░█▄█░█▀█ |
"| ░█▀▀░█▀▄░█░█░█░█░░░█▀▀░█▀▄░█▀▀░█▀▀░░░█░░░█░█░█░█░█▀▀░░░█░░░█▀█░█░█░█▀▀ |
"| ░▀░░░▀░▀░▀▀▀░▀░▀░░░▀░░░▀░▀░▀▀▀░▀▀▀░░░▀▀▀░▀▀▀░▀▀░░▀▀▀░░░▀▀▀░▀░▀░▀░▀░▀░░ |
"|                                                                        |
"'------------------------------------------------------------------------'

" SEAN'S CUSTOMIZATIONS INSPIRED MOSTLY FROM - https://www.freecodecamp.org/news/vimrc-configuration-guide-customize-your-vim-editor/


" Turn syntax highlighting on.
syntax on

" Add numbers to each line on the left-hand side.
set number

" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Highlight cursor line underneath the cursor horizontally.
set cursorline

" Highlight cursor line underneath the cursor vertically.
" Sean found this too distracting and disabled it.
" set cursorcolumn

" Set shift width to 4 spaces.
set shiftwidth=4

" Set tab width to 4 columns.
set tabstop=4

" Use space characters instead of tabs.
set expandtab

" Do not save backup files.
" Sean found that there was already a configuration for this in the default
" set of commands he started with 
"set nobackup

" Do not let cursor scroll below or above N number of lines when scrolling.
set scrolloff=3

" Do not wrap lines. Allow long lines to extend as far as the line goes.
set nowrap

" Wrap lines and wrap them at the word boundaries - this is INSTEAD of what's
" written above
"set wrap
"set linebreak

" While searching though a file incrementally highlight matching characters as you type.
set incsearch

" Ignore capital letters during search.
set ignorecase

" Override the ignorecase option if searching for capital letters.
" This will allow you to search specifically for capital letters.
set smartcase

" Show partial command you type in the last line of the screen.
set showcmd

" Show the mode you are on the last line.
set showmode

" Show matching words during a search.
set showmatch

" Use highlighting when doing a search.
set hlsearch

" Set the commands to save in history default number is 20.
set history=1000

" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

" There are certain files that we would never want to edit with Vim.
" 
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

"***Edit number formatting so that when you add 007+1 it returns an integer and
"*not* something in octal eight notation: See page 21 of Practical Vim
"somehow this seems to already be enabled. 
"set nrformats=
"
"THE FOLLOWING SECTIONS (PLUGINS, MAPPINGS, VIMSCRIPT, and STATUS LINE) ARE 'FOLDED':
"zo - to open the fold under the cursor
"zc - to close the folder under the cursor
"zR - to open all folds
"zM - to close all folds

" PLUGINS ---------------------------------------------------------------- {{{

" Plugin code goes here.

" }}}


" MAPPINGS --------------------------------------------------------------- {{{

" Set the comma as the leader key.
 let mapleader = " "

" Press \\ to jump back to the last cursor position.
" SEAN COULDN'T FIGURE OUT HOW TO MAKE THIS USEFUL WHEN HE INSTALLED ALL OF
" THIS ON 8/28.
" nnoremap <leader>, ``

" turn off search hilighting by pressing the leader key twice
nnoremap <leader>, :nohlsearch<CR>

" }}}


" VIMSCRIPT -------------------------------------------------------------- {{{

" This will enable code folding.
" Use the marker method of folding.
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" More Vimscripts code goes here.

" }}}


" STATUS LINE ------------------------------------------------------------ {{{

" Clear status line when vimrc is reloaded.
set statusline=

" Status line left side.
set statusline+=\ %F\ %M\ %Y\ %R

" Use a divider to separate the left side from the right side.
set statusline+=%=

" Status line right side.
set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ percent:\ %p%%

" Show the status on the second to last line.
set laststatus=2

" }}}


" ░█▀▀░█▀▀░█▀█░█▀█░▀░█▀▀░░░█▀█░█▀▄░█▀▀░█▀▀░█▀▀░█▀▄░█▀▀░█▀█░█▀▀░█▀▀░█▀▀
" ░▀▀█░█▀▀░█▀█░█░█░░░▀▀█░░░█▀▀░█▀▄░█▀▀░█▀▀░█▀▀░█▀▄░█▀▀░█░█░█░░░█▀▀░▀▀█
" ░▀▀▀░▀▀▀░▀░▀░▀░▀░░░▀▀▀░░░▀░░░▀░▀░▀▀▀░▀░░░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀▀▀
"
" SECTIONS ARE DENOTED WITH LINES WITH ALL CAPS AND A LINE BREAK LIKE THIS
" ------------------------------------------------------------------------

" HIGHLIGHT THE NUMBER ROW AND CHANGE THE NUMBER ROW FONT TO VISUALLY
" DIFFERENTIATE IT FROM THE CODE
" -------------------------------------------------------------------
highlight LineNr ctermbg=darkgray guibg=darkgray ctermfg=green

" CHANGE CURSOR DEPENDING ON THE MODE:
" ------------------------------------
" 1 or 0 -> blinking block
" 2 -> solid block
" 3 -> blinking underscore
" 4 -> solid underscore
" 5 -> blinking vertical bar
" 6 -> solid vertical bar
let &t_SI = "\e[5 q" " Insert mode: vertical bar
let &t_SR = "\e[4 q" " Replace mode: underline
let &t_EI = "\e[1 q" " Normal Mode: solid block

" SYSTEM CLIPBOARD ACCESS - MAKE CTRL+V and CTRL+C WORK IN VIM
" ------------------------------------------------------------
" Apparently, clipboard access only works if you have something like gvim installed
" (I don't really know why), but once you do have it installed (which you can
" do with: 
" `sudo apt install vim-gtk3`
" then you can verify that you have clipboard support enabled if you see
" 'clipboard' anywhere when you type: 
"`vim --version | grep clipboard` 
" set clipboard=unnamedplus
set clipboard=unnamed,unnamedplus
" See video here (https://www.youtube.com/watch?v=E_rbfQqrm7g) for an
" alternative to the unnamedplus option above, which is 
"vnoremap <C-c> "+y
"map <C-v> "+P

"USE CTRL + BACKSPACE TO DELETE WHOLE PREVIOUS WORD IN INSERT MODE
" ----------------------------------------------------------------
"Note that Ctrl + w ("<C-w>" in vim notation syntax) deletes the whole
"previous word in insert_mode;more words-separated
inoremap <C-BS> <C-W>
"
" SET RELATIVE AND ABSOLUTE NUMBERS BASED ON THE MODE
" ---------------------------------------------------
" Relative numbers in normal mode, (and by default)
" Absolute numbers in insert mode
" Absolute numbers in command mode
" Absolute numbers when terminal loses focus
set relativenumber
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber
autocmd CmdlineEnter * set norelativenumber | redraw
autocmd CmdlineLeave * set relativenumber
autocmd FocusLost * set norelativenumber
autocmd FocusGained * set relativenumber

" HANDLING BACKUP, UNDO, AND SWAP FILES
" -------------------------------------
" instead of the code in 'HANDLING BACKUP, UNDO, AND SWAP FILES (DEPRECATED)'
" above, we will store the undo files (file.txt.un~), and the backup files
" (file.txt~) and the swap files (file.swp~) in separate directories in the
" .vim file itself:

" 1. Define paths
let vim_dir = $HOME . '/.vim'
let backup_dir = vim_dir . '/backup'
let undo_dir   = vim_dir . '/undo-history'
let swap_dir   = vim_dir . '/swap'

" 2. Create directories (silent failure if they exist)
for d in [backup_dir, undo_dir, swap_dir]
    if !isdirectory(d) | call mkdir(d, "p") | endif
endfor

" 3. Apply Settings
set backup
let &backupdir = backup_dir
let &directory = swap_dir 

if has('persistent_undo')
    set undofile
    let &undodir = undo_dir
endif

" Addendum: dealing with netrwhist
" netrwhist stands for Network Read/Write History - it's the place where you
" store the last 10 directories you've visited (and you can't manage it the
" same way you do with backup, swap, and undo files because it's a default
" plugin with its own weird logic).
let g:netrw_home = '$HOME/.vim'

" REMAP LEADER + D TO DELETE THE CURRENT LINE
" -------------------------------------------
nnoremap <leader>d dd

" DELETE A SINGLE CHARACTER WITHOUT COPYING IT
noremap <leader>x "_x
