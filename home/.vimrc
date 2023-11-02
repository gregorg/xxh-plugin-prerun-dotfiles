" vimrc de Greg <greg-vim@duchatelet.net>
" .
"
"
" vimrc sympas:
" http://github.com/jferris/config_files/blob/2e1a03b1fe56b122758a9051eebe0e9302fd8be8/vimrc
"
" ['']
" %s@\[\(\w\+\)]@['\1']@g
"

" Inclut le debian.vim sinon erreur
runtime! debian.vim

" set {{{
set nocp
set autoindent				" always set autoindenting on
set backspace=indent,eol,start		" allow backspacing over everything in insert mode
set helplang=en
syntax on
set bg=dark
set hls
set tabstop=4
set shiftwidth=4
set wh=99
set tw=0
set fdm=marker
set isk-=$
set scrolloff=3
set formatoptions=tcrq2
set isfname-==
"set grepprg=mygrep
"set mouse=a				" Enable mouse usage (all modes) in terminals
"set mouse=vi			" Enable mouse in Insert and Command modes
set showcmd				" Show (partial) command in status line.
set encoding=utf-8
set fileencoding=utf-8
set ruler				" show the cursor position all the time
set autowrite				" Automatically save before commands like :next and :make
set vb t_vb=				" prevents vi from making its annoying beeps when a command doesn't work. Instead, it briefly flashes the screen
set incsearch				" will search for text as you enter it.
filetype plugin on

"4 spaces instead of tabs:
set expandtab
set softtabstop=4
" }}}

" COULEURS / STYLE {{{
" change la couleur du highlight de parenthèse
hi MatchParen ctermbg=lightgrey
" highlight toujours :
match ErrorMsg /^Error/
" http://marcotrosi.tumblr.com/post/120767954868/vim-listchars
set listchars=eol:↲,tab:▶▹,nbsp:␣,extends:…,trail:•
" }}}

" TODO : set statusline= {{{
" }}}

" KDE4 cursor shape {{{
"let &t_SI = "\<Esc>]50;CursorShape=1\x7"
"let &t_EI = "\<Esc>]50;CursorShape=0\x7"
" }}}

" GNOME cursor shape {{{
"if has("autocmd")
"  au InsertEnter * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
"
"  au InsertLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
"
"  au VimLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
"endif
" }}}

" XTERM cursor shape {{{
if &term =~ "xterm\\|rxvt"
	:silent !echo -ne "\033]12;red\007"
	let &t_SI = "\033]12;orange\007"
	let &t_EI = "\033]12;red\007"
	autocmd VimLeave * :!echo -ne "\033]12;red\007"
endif 
" }}}

" MAPPING {{{1

" mapping commun {{{2
nmap Q <C-]>
nmap W :cn<CR>

imap §A ['']<esc>F'i
imap §N ['<esc>ea']
" fait un debug_echo d'une var , sur la prochaine ligne de code
nmap §D :call PutDebug()<cr>
func! PutDebug()
	let old_isk=&iskeyword
	set isk+=$
	" lit la variable dans @v
	exe 'norm "vyiw'
	let l=line('.')
	exe "norm 0/;\n"
	while synIDattr(synID(line("."), col("."), 1), "name") != 'phpRegion'
		norm n
	endw
	exe "norm odebug_echo(\<c-r>v);\e"
	let &iskeyword=old_isk
endf
imap §B ."<br>\n"
imap §T this->
imap ÉA §A
imap ÉN §N
nmap ÉD §D
imap ÉB §B
imap ÉT §T

imap ÉR $row['']<esc>F'i

" euro digraph : =e
nmap ÉU /[^a-zA-Z0-9!"/$%?&*()+=\\|#@^<>~	 ',{}[\]`;:.éÉàÀùÙèÈêÊûÛçÇÎîôÔ€_-]<cr>
function! ReUTF8()
	"%s/Ã /à/g
	%s/Ã©/é/ge
	%s/Ã¨/è/ge
	%s/Ã /à/ge
	%s/Ãª/ê/ge
	%s/Ã§/ç/ge
	%s/Ã»/û/ge
	%s/â€¦/... /ge
	%s/Ã´/ô/ge
endf
function! ConvertUTF8()
	set fileencoding=utf8
	set bomb
endf
function! DeEacute()
	%s/&eacute;/é/gc
	%s/&egrave;/è/gc
	%s/&agrave;/à/gc
	%s/&ecirc;/ê/gc
	%s/&ccedil;/ç/gc
	%s/&ucirc;/û/gc
endf

" mapping d'édition {{{2
" remplace ici, supprime
vmap ÉV s'..'<esc>F.i
" parenthèse et quote
imap É( ('');<esc>F'i
" gettext 
nmap É_ i_(<esc>2f"a)<esc>
vmap É_ "txi_()<esc>"tP
imap É_ _("")<esc>F"i

" goto file dans les fichiers .po
nmap Égf $T:"ly$0/trunc<cr>f/l"fyt::new <c-r>f<cr>:<c-r>l<cr>

" rompt une string sur plusieurs lignes
func! BreakString()
	" recherche la guillemet de la string, considérant qu'on est dans la string
	let l=line('.')
	exec "norm mm?['\"]\n"
	if line('.') != l
		" erreur dans la recherche, retour à la position de départ
		exec 'norm `m'
		return
	endif

	exec 'norm "gyl`m'
	" insertion du caratère de quote et bris de la ligne
	exec 'norm "gP'."a.\n\<c-r>g "
endf
nmap ÉJ :call BreakString()<cr>

" ouvre le fichier sous le curseur dans une nouvelle fenêtre
nmap <f5> :new <cfile><cr>

" ajout un espace de _inc dans les require pour faire des fg ou <c-x><c-f>
nmap «i ?_inc<cr>i <esc>
" fait un <c-x><c-f> sur le chemin de _inc courrant en ajoutant un espace
imap «f <esc>mm?_inc<cr>i <esc>`mla<c-x><c-f>
" supprime l'Espace ajouté avec les macros précédantes
nmap «F ? _inc<cr>yl:if @" == ' '<bar>norm x<bar>endif<cr>

" fait un recherche avec grep sur le mot courant
let g:mygrep_option=''
nmap Ég yiw:exe "grep ".g:mygrep_option." '".@"."'"<cr>

" exécution de script PHP
imap [23~ <esc>:!php %<cr>
nmap [23~ :!php %<cr>

" supprime les -> avec des espaces
nmap É> :s/[ 	]->[ 	]/->/g<cr>

" folding: ?
nmap z0 zM1zr

" CD: chdir dans le dossier courant du fichier
command CD :exe 'cd '.expand('%:p:h')

" easy buffer switching: b <Tab>
set wildchar=<Tab> wildmenu wildmode=full
" }}}1

" {{{ pathogen (disabled)
" call pathogen if installed
" silent! call pathogen#infect()
" silent! call pathogen#helptags()
" }}}

