"""""""""""""""""""""""""""""""""""""""""""""""
" プラグインがインストール済みかを確認する関数
"""""""""""""""""""""""""""""""""""""""""""""""
function s:is_plugged(name)
    if exists('g:plugs') && has_key(g:plugs, a:name) && isdirectory(g:plugs[a:name].dir)
        return 1
    else
        return 0
    endif
endfunction

" vim-plugの設定
call plug#begin('~/.vim/plugged')

				Plug 'tomasr/molokai', {'do': 'cp colors/* ~/.vim/colors/'}
				" ステータスラインの表示強化
				Plug 'itchyny/lightline.vim'
				" 行末に存在する空白を強調表示してくれる
				Plug 'bronson/vim-trailing-whitespace'
				" インデントの可視化
				Plug 'Yggdroot/indentLine'
				" 補完機能の拡張
				if has('lua')
								Plug 'Shougo/neocomplete.vim'
								Plug 'Shougo/neosnippet'
								Plug 'Shougo/neosnippet-snippets'
				endif
				" lightlineにbranchを表示する
				" Plug 'itchyny/vim-gitbranch'
				" vimでgitを使えるようにする
				Plug 'tpope/vim-fugitive'
				" gitの差分を記号表示する
				Plug 'airblade/vim-gitgutter'

call plug#end()

" setting
"""""""""""""""""""""""
" 文字コードの設定
"""""""""""""""""""""""

"文字コードをUFT-8に設定
set fenc=utf-8
" 保存時の文字コード
set fileencoding=utf-8
" 読み込み時の文字コードの自動判別. 左側が優先される
set fileencodings=ucs-boms,utf-8,euc-jp,cp932
" 改行コードの自動判別. 左側が優先される
set fileformats=unix,dos,mac
" □や○文字が崩れる問題を解決
set ambiwidth=double

"""""""""""""""""""""""
" ファイルに関する扱い
""""""""""""""""""""""

" バックアップファイルを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden

"""""""""""
" 見た目系
"""""""""""
" 256色を使用
set t_Co=256
" 背景をダークカラーにする
set background=dark
" カラースキームをmolokaiにする
colorscheme molokai
" 入力中のコマンドをステータスに表示する
set showcmd
" 現在のモードを非表示
set noshowmode
" ステータスラインにカーソルの位置を表示
set ruler
" 行番号を表示
set number
" 現在の行を強調表示
set cursorline
" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" インデントはスマートインデント
set smartindent
" タブの幅を設定
set tabstop=2
" ビープ音を可視化
set visualbell
" 括弧入力時の対応する括弧を表示
set showmatch
" %機能の拡張
source $VIMRUNTIME/macros/matchit.vim
" ステータスラインを常に表示
set laststatus=2
" コマンドラインの補完
set wildmode=list:longest
" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk
" シンタックスハイライト
syntax on
"iTerm2のColorsインポート
" let g:hybrid_use_iTerm_colors = 1
" コマンドの補完設定
set wildmenu
" コマンド履歴の数
set history=5000

""""""""
" Tab系
""""""""
" 不可視文字を可視化(タブが「▸-」と表示される)
set list listchars=tab:\▸\-

"""""""""
" 検索系
"""""""""

" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch
" ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>

"""""""""""""""
" その他の設定
"""""""""""""""

" コピペした時にインデントがずれないようにする
if &term =~ "xterm"
    let &t_SI .= "\e[?2004h"
    let &t_EI .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction

    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif

"""""""""""""""""""""""""""""""""
" neocomplete, neosnippet の設定
"""""""""""""""""""""""""""""""""
if s:is_plugged("neocomplete.vim")
    " Vim起動時にneocompleteを有効にする
    let g:neocomplete#enable_at_startup = 1
    " smartcase有効化. 大文字が入力されるまで大文字小文字の区別を無視する
    let g:neocomplete#enable_smart_case = 1
    " 3文字以上の単語に対して補完を有効にする
    let g:neocomplete#min_keyword_length = 3
    " 区切り文字まで補完する
    let g:neocomplete#enable_auto_delimiter = 1
    " 1文字目の入力から補完のポップアップを表示
    let g:neocomplete#auto_completion_start_length = 1
    " バックスペースで補完のポップアップを閉じる
    inoremap <expr><BS> neocomplete#smart_close_popup()."<C-h>"

    " エンターキーで補完候補の確定. スニペットの展開もエンターキーで確定
    imap <expr><CR> neosnippet#expandable() ? "<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "<C-y>" : "<CR>"
    " タブキーで補完候補の選択. スニペット内のジャンプもタブキーでジャンプ
    imap <expr><TAB> pumvisible() ? "<C-n>" : neosnippet#jumpable() ? "<Plug>(neosnippet_expand_or_jump)" : "<TAB>"
endif

""""""""""""""""""
" gitgutterの設定
""""""""""""""""""
" 更新タイムを変更する
set updatetime=250
let g:gitgutter_sign_added = '✚'
let g:gitgutter_sign_modified = '➜'
let g:gitgutter_sign_removed = '✘'

""""""""""""""""""
" lightlineの設定
""""""""""""""""""
let g:lightline = {
      \ 'colorscheme': 'landscape',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'fugitive', 'gitgutter', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'MyFugitive',
      \   'gitgutter': 'MyGitGutter',
      \ },
      \ }

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
