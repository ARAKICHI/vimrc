" NeoBundle
if has('vim_starting')
  set nocompatible
  if !isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
    echo "install neobundle..."
    :call system("git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim")
  endif
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle'))
let g:neobundle_default_git_protocol='https'

" NeoBundle plugin begin
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'ajh17/Spacegray.vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'airblade/vim-gitgutter'
" NetBundle plugin end

NeoBundleCheck
call neobundle#end()

filetype plugin indent on

" syntax color
set t_Co=256
syntax on
colorscheme spacegray

" vim-gitgutter
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '>'
let g:gitgutter_sign_removed = '×'
