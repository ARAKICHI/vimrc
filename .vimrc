" Encoding
set encoding=utf-8

" Tab
set tabstop=4
set autoindent
set expandtab
set shiftwidth=4

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

" -->NeoBundle plugin begin
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'ajh17/Spacegray.vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'airblade/vim-gitgutter'
" <--NetBundle plugin end

NeoBundleCheck
call neobundle#end()

filetype plugin indent on

" syntax color
set t_Co=256
syntax on
colorscheme spacegray

" vim-gitgutter
let g:gitgutter_sign_added = '✚'
let g:gitgutter_sign_modified = '➜'
let g:gitgutter_sign_removed = '✘'

" lightline.vim
set laststatus=2
let g:lightline = {
        \ 'colorscheme': 'wombat',
        \ 'mode_map': {'c': 'NORMAL'},
        \ 'active': {
        \   'left': [
        \     ['mode', 'paste'],
        \     ['fugitive', 'gitgutter', 'filename'],
        \   ],
        \   'right': [
        \     ['lineinfo', 'syntastic'],
        \     ['percent'],
        \     ['charcode', 'fileformat', 'fileencoding', 'filetype'],
        \   ]
        \ },
        \ 'component_function': {
        \   'modified': 'MyModified',
        \   'readonly': 'MyReadonly',
        \   'fugitive': 'MyFugitive',
        \   'filename': 'MyFilename',
        \   'fileformat': 'MyFileformat',
        \   'filetype': 'MyFiletype',
        \   'fileencoding': 'MyFileencoding',
        \   'mode': 'MyMode',
        \   'syntastic': 'SyntasticStatuslineFlag',
        \   'charcode': 'MyCharCode',
        \   'gitgutter': 'MyGitGutter',
        \ },
        \ 'separator': {'left': ' ', 'right': ' '},
        \ 'subseparator': {'left': ' ', 'right': ' '}
        \ }

function! MyModified()
    return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
    return &ft !~? 'help\|vimfiler\|gundo' && &ro ? '⭤' : ''
endfunction

function! MyFilename()
    return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
	 \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
         \  &ft == 'unite' ? unite#get_status_string() :
	 \  &ft == 'vimshell' ? substitute(b:vimshell.current_dir,expand('~'),'~','') :
	 \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
	 \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
    try
	if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
	    let _ = fugitive#head()
	    return strlen(_) ? '⭠ '._ : ''
	endif
    catch
    endtry
    return ''
endfunction

function! MyFileformat()
    return winwidth('.') > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
    return winwidth('.') > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
    return winwidth('.') > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
    return winwidth('.') > 60 ? lightline#mode() : ''
endfunction

function! MyGitGutter()
    if ! exists('*GitGutterGetHunkSummary')
         \ || ! get(g:, 'gitgutter_enabled', 0)
         \ || winwidth('.') <= 90
	return ''
    endif
    let symbols = [
	\ g:gitgutter_sign_added . ' ',
	\ g:gitgutter_sign_modified . ' ',
        \ g:gitgutter_sign_removed . ' '
        \ ]
    let hunks = GitGutterGetHunkSummary()
    let ret = []
    for i in [0, 1, 2]
	if hunks[i] > 0
	    call add(ret, symbols[i] . hunks[i])
        endif
    endfor
    return join(ret, ' ')
endfunction

function! MyCharCode()
    if winwidth('.') <= 70
	return ''
    endif
    redir => ascii
    silent! ascii
    redir END
    if match(ascii, 'NUL') != -1
	return 'NUL'
    endif
    let nrformat = '0x%02x'
    let encoding = (&fenc == '' ? &enc : &fenc)
    if encoding == 'utf-8'
        let nrformat = '0x%04x'
    endif
    let [str, char, nr; rest] = matchlist(ascii, '\v\<(.{-1,})\>\s*([0-9]+)')
    let nr = printf(nrformat, nr)
    return "'". char ."' ". nr
endfunction

" line number
set number

