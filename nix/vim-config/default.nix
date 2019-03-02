{ pkgs }:

let my_plugins = import ./plugins.nix { inherit (pkgs) vimUtils fetchFromGitHub; };

in with pkgs; vim_configurable.customize {
  name = "vim";
  vimrcConfig = {
    customRC = ''
      """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      " => General
      """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      " Sets how many lines of history VIM has to remember
      set history=500

      " Set mouse mode
      set mouse=a

      set encoding=utf-8

      " Enable filetype plugins
      filetype plugin on
      filetype indent on


      " Set backspace to regular backspace
      set backspace=indent,eol,start

      " Set to auto read when a file is changed from the outside
      set autoread

      " With a map leader it's possible to do extra key combinations
      " like <leader>w saves the current file
      let mapleader = ","
      let g:mapleader = ","

      " Fast saving
      nmap <leader>w :w!<cr>

      " :W sudo saves the file 
      " (useful for handling the permission-denied error)
      command W w !sudo tee % > /dev/null

      " Turn on the WiLd menu
      set wildmenu

      " Ignore case when searching
      set ignorecase

      " When searching try to be smart about cases 
      set smartcase

      " Highlight search results
      set hlsearch

      " Makes search act like search in modern browsers
      set incsearch 

      " Don't redraw while executing macros (good performance config)
      set lazyredraw 

      " For regular expressions turn magic on
      set magic

      " Show matching brackets when text indicator is over them
      set showmatch 
      " How many tenths of a second to blink when matching brackets
      set mat=2

      " No annoying sound on errors
      set noerrorbells
      set novisualbell
      set t_vb=
      set tm=500

      " Ignore compiled files
      set wildignore=*.o,*~,*.pyc
      if has("win16") || has("win32")
          set wildignore+=.git\*,.hg\*,.svn\*
      else
          set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
      endif

      "Always show current position
      set ruler

      " Height of the command bar
      set cmdheight=2

      " A buffer becomes hidden when it is abandoned
      set hid


      """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      " => Text, tab and indent related
      """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      " Use spaces instead of tabs
      set expandtab

      " Be smart when using tabs ;)
      set smarttab

      " 1 tab == 4 spaces
      set shiftwidth=4
      set tabstop=4

      " Linebreak on 500 characters
      set lbr
      set tw=500

      set ai "Auto indent
      set si "Smart indent
      set wrap "Wrap lines

      syntax on

      """"""""""""""""""""""""""""""
      " => Visual mode related
      """"""""""""""""""""""""""""""
      " Visual mode pressing * or # searches for the current selection
      " Super useful! From an idea by Michael Naumann
      vnoremap <silent> * :<C-u>call VisualSelection(\'\', \'\')<CR>/<C-R>=@/<CR><CR>
      vnoremap <silent> # :<C-u>call VisualSelection(\'\', \'\')<CR>?<C-R>=@/<CR><CR>


      """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      " => Moving around, tabs, windows and buffers
      """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      " Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
      map <space> /
      map <c-space> ?

      " Disable highlight when <leader><cr> is pressed
      map <silent> <leader><cr> :noh<cr>

      " Smart way to move between windows
      map <C-j> <C-W>j
      map <C-k> <C-W>k
      map <C-h> <C-W>h
      map <C-l> <C-W>l

      " Close the current buffer
      map <leader>bd :Bclose<cr>:tabclose<cr>gT

      " Close all the buffers
      map <leader>ba :bufdo bd<cr>

      map <leader>l :bnext<cr>
      map <leader>h :bprevious<cr>

      " Useful mappings for managing tabs
      map <leader>tn :tabnew<cr>
      map <leader>to :tabonly<cr>
      map <leader>tc :tabclose<cr>
      map <leader>tm :tabmove 
      map <leader>t<leader> :tabnext 

      " Let 'tl' toggle between this and the last accessed tab
      let g:lasttab = 1
      nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
      au TabLeave * let g:lasttab = tabpagenr()


      " Opens a new tab with the current buffer's path
      " Super useful when editing files in the same directory
      map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

      " Switch CWD to the directory of the open buffer
      map <leader>cd :cd %:p:h<cr>:pwd<cr>

      " Specify the behavior when switching between buffers 
      try
        set switchbuf=useopen,usetab,newtab
        set stal=2
      catch
      endtry

      " Return to last edit position when opening files (You want this!)
      au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

      """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      " => Editing mappings
      """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      " Remap VIM 0 to first non-blank character
      map 0 ^

      " Move a line of text using ALT+[jk] or Command+[jk] on mac
      nmap <M-j> mz:m+<cr>`z
      nmap <M-k> mz:m-2<cr>`z
      vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
      vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

      if has("mac") || has("macunix")
        nmap <D-j> <M-j>
        nmap <D-k> <M-k>
        vmap <D-j> <M-j>
        vmap <D-k> <M-k>
      endif

      " Delete trailing white space on save, useful for some filetypes ;)
      fun! CleanExtraSpaces()
          let save_cursor = getpos(".")
          let old_query = getreg('/')
          silent! %s/\s\+$//e
          call setpos('.', save_cursor)
          call setreg('/', old_query)
      endfun

      if has("autocmd")
          autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
      endif

      nnoremap <C-J> <C-W><C-J>
      nnoremap <C-K> <C-W><C-K>
      nnoremap <C-L> <C-W><C-L>
      nnoremap <C-H> <C-W><C-H>


      """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      " => Spell checking
      """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      " Pressing ,ss will toggle and untoggle spell checking
      map <leader>ss :setlocal spell!<cr>

      " Shortcuts using <leader>
      map <leader>sn ]s
      map <leader>sp [s
      map <leader>sa zg
      map <leader>s? z=


      """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      " => Misc
      """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      " Remove the Windows ^M - when the encodings gets messed up
      noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

      " Quickly open a buffer for scribble
      map <leader>q :e ~/buffer<cr>

      " Quickly open a markdown buffer for scribble
      map <leader>x :e ~/buffer.md<cr>

      " Toggle paste mode on and off
      map <leader>pp :setlocal paste!<cr>


      """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      " => Helper functions
      """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
      " Returns true if paste mode is enabled
      function! HasPaste()
          if &paste
              return 'PASTE MODE  '
          endif
          return \'\'
      endfunction

      " Don't close window, when deleting a buffer
      command! Bclose call <SID>BufcloseCloseIt()
      function! <SID>BufcloseCloseIt()
         let l:currentBufNum = bufnr("%")
         let l:alternateBufNum = bufnr("#")

         if buflisted(l:alternateBufNum)
           buffer #
         else
           bnext
         endif

         if bufnr("%") == l:currentBufNum
           new
         endif

         if buflisted(l:currentBufNum)
           execute("bdelete! ".l:currentBufNum)
         endif
      endfunction

      set termguicolors
      " colorscheme molokai
      let g:airline_theme = 'molokai'

      set grepprg=rg\ --vimgrep
      " bind K to grep word under cursor
      nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

      let g:ctrlp_user_command = 'rg --files %s'
      let g:ctrlp_use_caching = 0

      " Error and warning signs.
      let g:ale_sign_error = '⤫'
      let g:ale_sign_warning = '⚠'

      " Enable integration with airline.
      let g:airline#extensions#ale#enabled = 1

      let g:go_highlight_build_constraints = 1
      let g:go_highlight_extra_types = 1
      let g:go_highlight_fields = 1
      let g:go_highlight_functions = 1
      let g:go_highlight_methods = 1
      let g:go_highlight_operators = 1
      let g:go_highlight_structs = 1
      let g:go_highlight_types = 1

      " let g:go_fmt_command = "goimports"

      au BufRead,BufNewFile *.tag :set filetype=html

      let g:elm_format_autosave = 1

      " NERDTree
      autocmd StdinReadPre * let s:std_in=1
      " open vim with nerdtree
      " DISABLED: autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
      " map Ctrl+n to NerdTree
      map <C-n> :NERDTreeToggle<CR>
      " Close when only nerdtree is open
      autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
      let g:NERDTreeDirArrowExpandable = '▸'
      let g:NERDTreeDirArrowCollapsible = '▾' 

      " YCM
      map <C-i> :YcmCompleter GoTo<CR>

    '';

    vam.knownPlugins = vimPlugins // my_plugins;
    vam.pluginDictionaries = [
      { names = [
        "nerdtree"
        "fzf-vim"
        "lightline-vim"
        "ale"
        "ctrlp"
        "vim-addon-nix"
        "youcompleteme"
        "molokai"
        "fugitive"
        "gitgutter"
        "vim-airline"
        "vim-airline-themes"
        "sleuth"
        "vim-go"
        "vim-javascript"
        "hexmode"
      ]; }
    ];
  };
}
