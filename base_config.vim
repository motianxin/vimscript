"git config --global url."https://ghfast.top/https://github.com/".insteadOf "https://github.com/"
"cd ~/.vim/bundle

"# 已配 ghfast.top 加速，原 URL 自动走加速
"
"# Vundle（如果还没装）
"git clone --depth 1 https://github.com/VundleVim/Vundle.vim.git
"
"# 需锁旧版的（兼容 vim 7.4）
"git clone --branch 6.10.16 --depth 1 https://github.com/preservim/nerdtree.git
"git clone --branch 2.5.2  --depth 1 https://github.com/preservim/nerdcommenter.git
"
"# 新版本即可用的
"git clone --branch 1.79   --depth 1 https://github.com/kien/ctrlp.vim.git
"git clone --branch v0.12  --depth 1 https://github.com/vim-airline/vim-airline.git
"git clone --depth 1 https://github.com/preservim/tagbar.git
"git clone --branch 1.0.0  --depth 1 https://github.com/godlygeek/tabular.git
"git clone --branch 2.18   --depth 1 https://github.com/vim-scripts/a.vim.git
"git clone --depth 1 https://github.com/altercation/vim-colors-solarized.git
"git clone --branch v2.0.0 --depth 1 https://github.com/morhetz/gruvbox.git
"git clone --depth 1 https://github.com/joshdick/onedark.vim.git
"git clone --depth 1 https://github.com/dracula/vim.git
"git clone --depth 1 https://github.com/romainl/Apprentice.git
"git clone --depth 1 https://github.com/tomasr/molokai.git
"git clone https://github.com/WeiChungWu/vim-SystemVerilog.git
" ============================================================
"  ~/.vimrc  ——  gvim 7.4.629 (CentOS 7) EDA 开发环境完整配置
"  插件管理器: Vundle（插件已手动 clone 到 ~/.vim/bundle）
"  配套插件  : NERDTree / CtrlP / tagbar / nerdcommenter
"              tabular / a.vim / vim-airline
"  主题      : gruvbox / onedark / dracula / apprentice
"              molokai / hybrid / solarized（F9 轮换）
"  覆盖方式  : 备份旧配置后整份替换 ~/.vimrc
" ============================================================

" ============================================================
"  vimrc —— 便携版 EDA gvim 配置（兼容 gvim 7.4+）
"  本文件不依赖 ~/.vim 目录，插件从仓库内 vim/bundle/ 加载
"  加载链路: ~/.vimrc(bootstrap, install.sh 生成) -> source 本文件
"  机器个性化配置放 ~/.vimrc.local（字体等），不进仓库
" ============================================================

" ---------- 核心：定位仓库根目录，一切路径自适应 ----------
" bootstrap 里已设 g:dotvim_repo；直接用本文件当 ~/.vimrc 时自动取所在目录
if !exists('g:dotvim_repo')
  let g:dotvim_repo = expand('<sfile>:p:h')
endif
let s:bundle = g:dotvim_repo . '/vim/bundle'

" ---------- 插件加载：把仓库 bundle/ 下所有目录加入 runtimepath ----------
" 等效 pathogen：gvim 查找插件靠 runtimepath，不靠固定 ~/.vim
" ---------------- Vundle 初始化（必须放在最前面）----------------
set nocompatible              " 关闭 vi 兼容模式（必须）
filetype off                  " 关闭文件类型检测（Vundle 要求）
for s:p in split(glob(s:bundle . '/*'), '\n')
  if isdirectory(s:p)
    execute 'set rtp^=' . escape(s:p, ' ')
  endif
endfor
if isdirectory(s:bundle . '/Vundle.vim')
  call vundle#begin(s:bundle)
" Vundle 自身
    Plugin 'VundleVim/Vundle.vim'
    " ===== 插件列表（版本按 gvim 7.4 兼容性锁定，勿升最新版）=====
    Plugin 'preservim/nerdtree',         {'tag': '6.10.16'}   " 文件树（7.x 起需 vim8+，锁旧版）
    Plugin 'kien/ctrlp.vim',             {'tag': '1.79'}      " 模糊找文件
    Plugin 'preservim/tagbar'                                    " 代码结构栏（支持 7.3.1058+）
    Plugin 'preservim/nerdcommenter',    {'tag': '2.5.2'}     " 快速注释（新版需 vim8+）
    Plugin 'godlygeek/tabular',          {'tag': '1.0.0'}     " 代码对齐
    Plugin 'vim-scripts/a.vim',          {'tag': '2.18'}      " .v <-> .vh 跳转
    Plugin 'vim-airline/vim-airline',    {'tag': 'v0.12'}     " 状态栏
    " ===== 暗色护眼主题（版本按 gvim 7.4 兼容性锁定）=====
    Plugin 'morhetz/gruvbox',            {'tag': 'v2.0.0'}    " 复古暖色，最火（master 需 vim 7.4.1968+，锁旧版）
    Plugin 'joshdick/onedark.vim'                             " Atom One Dark 风格，蓝灰调
    Plugin 'dracula/vim'                                      " 暗紫高对比
    Plugin 'romainl/Apprentice'                               " 低对比柔和，最护眼
    Plugin 'tomasr/molokai'                                   " Monokai 鲜艳高对比
    Plugin 'altercation/vim-colors-solarized'                 " 经典护眼主题
    Plugin 'WeiChungWu/vim-SystemVerilog'                 
    call vundle#end()
endif
filetype plugin indent on     " 恢复文件类型检测（必须）

" ================= 外观与主题 =================
syntax on
"set background=dark
set guifont=DejaVu\ Sans\ Mono\ Bold\ 14
set nu                       " 行号
set cursorline               " 高亮当前行
set showmatch                " 括号匹配
set laststatus=2             " 始终显示状态栏（airline 需要）
set t_Co=256                 " 256 色（暗色主题都依赖它）

" ================= 缩进（Verilog 常规风格）=================
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent

" ================= 搜索 =================
set hlsearch
set incsearch
set ignorecase
set smartcase
nnoremap <Esc><Esc> :nohlsearch<CR>   " 连按两次 Esc 取消高亮

" ================= 编辑体验 =================
set history=1000
set scrolloff=5
set nowrap
set backspace=indent,eol,start
set mouse=a                  " gvim 鼠标支持

"防止中文注释乱码
set fileencoding=utf-8
set fenc=utf-8
set fencs=utf-8,usc-bom,euc-jp,gb18030,gbk,gb2312,cp936,big－5                    
set enc=utf-8
set fileencodings=utf-8,gbk2312,gbk,gb18030,cp936
set langmenu=zh_CN
let $LANG = 'en_US.UTF-8'
let &termencoding=&encoding
"退格键一次删除4个空格
"set softtabstop=4

" 在编辑过程中，在右下角显示光标位置的状态行
set ruler
" 在状态列显示目前所执行的指令
set showcmd
set nobackup
set noswapfile
set nowritebackup
set noundofile
set whichwrap=b,s,<,>,[,]
set nobomb
"set backspace=indent,eol,start whichwrap+=<,>,[,]
"Vim 的默认寄存器和系统剪贴板共享
"set clipboard+=unnamed
"set clipboard+=unnamedplus
"设置 alt 键不映射到菜单栏
set winaltkeys=no

winpos 0 0
"窗口大小
set lines=999 columns=999
"分割出来的窗口位于当前窗口下边/右边
set splitbelow
set splitright
"不显示工具/菜单栏
set guioptions-=T
set guioptions-=m
set guioptions-=L
set guioptions-=r
set guioptions-=b
"使用内置 tab 样式而不是 gui
set guioptions-=e
set nolist
"set listchars=tab:▶\ ,eol:¬,trail:·,extends:>,precedes:<
"set guifont=FiraMono_Nerd_Font_Mono:h14:cANSI:qDRAFT
set foldmethod=indent
set nofoldenable
set autochdir
colorscheme onedark              " 默认主题，可按 F9 轮换

