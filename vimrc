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
set nocompatible
filetype off
for s:p in split(glob(s:bundle . '/*'), '\n')
  if isdirectory(s:p)
    execute 'set rtp^=' . escape(s:p, ' ')
  endif
endfor

" ---------- Vundle（仅当仓库里有 Vundle 时启用，用于 :PluginInstall）----------
" 注意 vundle#begin() 传入仓库 bundle 路径 —— 新装插件也落在仓库里，可提交
if isdirectory(s:bundle . '/Vundle.vim')
  call vundle#begin(s:bundle)
  Plugin 'VundleVim/Vundle.vim'
  " 插件清单（版本按 gvim 7.4 兼容性锁定，勿升最新版）
  Plugin 'preservim/nerdtree',         {'tag': '6.10.16'}
  Plugin 'kien/ctrlp.vim',             {'tag': '1.79'}
  Plugin 'preservim/tagbar'
  Plugin 'preservim/nerdcommenter',    {'tag': '2.5.2'}
  Plugin 'godlygeek/tabular',          {'tag': '1.0.0'}
  Plugin 'vim-scripts/a.vim',          {'tag': '2.18'}
  Plugin 'vim-airline/vim-airline',    {'tag': 'v0.12'}
  Plugin 'morhetz/gruvbox',            {'tag': 'v2.0.0'}
  Plugin 'joshdick/onedark.vim'
  Plugin 'dracula/vim'
  Plugin 'romainl/Apprentice'
  Plugin 'tomasr/molokai'
  Plugin 'altercation/vim-colors-solarized'
  call vundle#end()
endif
filetype plugin indent on

" ================= 外观与主题 =================
syntax on
set background=dark
colorscheme gruvbox              " 默认主题，可按 F9 轮换
set nu
set cursorline
set showmatch
set laststatus=2
set t_Co=256

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
nnoremap <Esc><Esc> :nohlsearch<CR>

" ================= 编辑体验 =================
set history=1000
set scrolloff=5
set nowrap
set backspace=indent,eol,start
set mouse=a

" ================= 快捷键（F 键族，EDA 常用）=================
" F2  文件树开关
map <F2> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" F3  .v <-> .vh 头文件互跳
nnoremap <F3> :A<CR>

" F8  Tagbar 代码结构栏
nmap <F8> :TagbarToggle<CR>
let g:tagbar_width = 30

" ================= CtrlP 模糊搜索 =================
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_max_files = 20000
let g:ctrlp_show_hidden = 1

" ================= Tabular 对齐 =================
vnoremap <Leader>a= :Tabularize /=<CR>
vnoremap <Leader>a: :Tabularize /:<CR>

" ================= nerdcommenter =================
let g:NERDSpaceDelims = 1

" ================= airline 状态栏 =================
let g:airline#extensions#tabline#enabled = 1

" ================= Verilog / SystemVerilog =================
if !empty(globpath(&rtp, 'syntax/systemverilog.vim'))
  au BufRead,BufNewFile *.sv,*.svh set filetype=systemverilog
else
  au BufRead,BufNewFile *.sv,*.svh set filetype=verilog
endif
au BufRead,BufNewFile *.v set filetype=verilog

" ================= 主题轮换（F9）=================
let g:my_themes = ['gruvbox', 'onedark', 'dracula', 'apprentice', 'molokai', 'solarized']
let g:my_theme_idx = index(g:my_themes, g:colors_name)
if g:my_theme_idx < 0
  let g:my_theme_idx = 0
endif
function! CycleTheme()
  let g:my_theme_idx = (g:my_theme_idx + 1) % len(g:my_themes)
  execute 'colorscheme ' . g:my_themes[g:my_theme_idx]
  echo 'Theme: ' . g:my_themes[g:my_theme_idx]
endfunction
nnoremap <F9> :call CycleTheme()<CR>

" ================= UVM 类模板生成 =================
" F5  -> uvm_component 模板   F6 -> uvm_object 模板
" 类名自动转换：my_txn.sv -> MyTxn
function! s:SnakeToCamel(name)
  let l:s = substitute(a:name, '_\(\a\)', '\u\1', 'g')
  return substitute(l:s, '^\a', '\u&', '')
endfunction

function! s:UvmClass(type)
  let l:file = expand('%:t:r')
  if empty(l:file)
    echohl WarningMsg | echo '请先保存文件（:w 文件名.sv），文件名用于生成类名' | echohl None
    return
  endif
  let l:cls   = s:SnakeToCamel(l:file)
  let l:date  = strftime('%Y-%m-%d')
  let l:file  = l:file . '.sv'
  let l:lines = []

  call add(l:lines, '`include "uvm_macros.svh"')
  call add(l:lines, 'import uvm_pkg::*;')
  call add(l:lines, '')
  call add(l:lines, '//======================================================================')
  call add(l:lines, '// Class  : ' . l:cls)
  call add(l:lines, '// Type   : uvm_' . a:type)
  call add(l:lines, '// File   : ' . l:file)
  call add(l:lines, '// Author : ')
  call add(l:lines, '// Date   : ' . l:date)
  call add(l:lines, '// Desc   : TODO')
  call add(l:lines, '//======================================================================')

  if a:type ==# 'component'
    call add(l:lines, 'class ' . l:cls . ' extends uvm_component;')
    call add(l:lines, '')
    call add(l:lines, '  //--------------------------------------------------------------------')
    call add(l:lines, '  // Members')
    call add(l:lines, '  //--------------------------------------------------------------------')
    call add(l:lines, '  // TODO: 声明子组件、配置、接口句柄等成员')
    call add(l:lines, '')
    call add(l:lines, '  `uvm_component_utils(' . l:cls . ')')
    call add(l:lines, '')
    call add(l:lines, '  //--------------------------------------------------------------------')
    call add(l:lines, '  // Function : new')
    call add(l:lines, '  // Desc     : 构造函数')
    call add(l:lines, '  //--------------------------------------------------------------------')
    call add(l:lines, '  function new(string name, uvm_component parent);')
    call add(l:lines, '    super.new(name, parent);')
    call add(l:lines, '  endfunction : new')
    call add(l:lines, '')
    call add(l:lines, '  //--------------------------------------------------------------------')
    call add(l:lines, '  // Function : build_phase')
    call add(l:lines, '  // Desc     : 创建子组件、获取配置')
    call add(l:lines, '  //--------------------------------------------------------------------')
    call add(l:lines, '  virtual function void build_phase(uvm_phase phase);')
    call add(l:lines, '    super.build_phase(phase);')
    call add(l:lines, '    // TODO: 创建子组件 / uvm_config_db 获取配置')
    call add(l:lines, '  endfunction : build_phase')
    call add(l:lines, '')
    call add(l:lines, '  //--------------------------------------------------------------------')
    call add(l:lines, '  // Function : connect_phase')
    call add(l:lines, '  // Desc     : 连接端口、句柄赋值')
    call add(l:lines, '  //--------------------------------------------------------------------')
    call add(l:lines, '  virtual function void connect_phase(uvm_phase phase);')
    call add(l:lines, '    super.connect_phase(phase);')
    call add(l:lines, '    // TODO: 端口连接')
    call add(l:lines, '  endfunction : connect_phase')
    call add(l:lines, '')
    call add(l:lines, '  //--------------------------------------------------------------------')
    call add(l:lines, '  // Task : run_phase')
    call add(l:lines, '  // Desc : 主任务，驱动/采样/处理数据')
    call add(l:lines, '  //--------------------------------------------------------------------')
    call add(l:lines, '  virtual task run_phase(uvm_phase phase);')
    call add(l:lines, '    `uvm_info(get_type_name(), "run_phase start", UVM_LOW)')
    call add(l:lines, '    // TODO: 主逻辑，耗时代码放这里')
    call add(l:lines, '    `uvm_info(get_type_name(), "run_phase done", UVM_LOW)')
    call add(l:lines, '  endtask : run_phase')
    call add(l:lines, '')
    call add(l:lines, '  //--------------------------------------------------------------------')
    call add(l:lines, '  // Function : report_phase')
    call add(l:lines, '  // Desc     : 仿真结束打印统计信息')
    call add(l:lines, '  //--------------------------------------------------------------------')
    call add(l:lines, '  virtual function void report_phase(uvm_phase phase);')
    call add(l:lines, '    super.report_phase(phase);')
    call add(l:lines, '    // TODO: 打印统计')
    call add(l:lines, '  endfunction : report_phase')
    call add(l:lines, '')
    call add(l:lines, 'endclass : ' . l:cls)
  else
    call add(l:lines, 'class ' . l:cls . ' extends uvm_object;')
    call add(l:lines, '')
    call add(l:lines, '  //--------------------------------------------------------------------')
    call add(l:lines, '  // Members')
    call add(l:lines, '  //--------------------------------------------------------------------')
    call add(l:lines, '  rand bit [31:0] addr;         // TODO: 示例成员，按需修改')
    call add(l:lines, '  rand bit [31:0] data;')
    call add(l:lines, '')
    call add(l:lines, '  //--------------------------------------------------------------------')
    call add(l:lines, '  // Constraints')
    call add(l:lines, '  //--------------------------------------------------------------------')
    call add(l:lines, '  // constraint c_addr { addr < 32''h1000; }')
    call add(l:lines, '')
    call add(l:lines, '  `uvm_object_utils(' . l:cls . ')')
    call add(l:lines, '')
    call add(l:lines, '  //--------------------------------------------------------------------')
    call add(l:lines, '  // Function : new')
    call add(l:lines, '  // Desc     : 构造函数')
    call add(l:lines, '  //--------------------------------------------------------------------')
    call add(l:lines, '  function new(string name = "' . l:cls . '");')
    call add(l:lines, '    super.new(name);')
    call add(l:lines, '  endfunction : new')
    call add(l:lines, '')
    call add(l:lines, '  // ---- 以下为可选重载，按需取消注释 ----')
    call add(l:lines, '')
    call add(l:lines, '  // copy        : 深拷贝')
    call add(l:lines, '  /* ------------------------------------------------------------------')
    call add(l:lines, '  virtual function void do_copy(uvm_object rhs);')
    call add(l:lines, '    ' . l:cls . ' that;')
    call add(l:lines, '    if (!$cast(that, rhs))')
    call add(l:lines, '      `uvm_fatal("DO_COPY", "cast of rhs object failed")')
    call add(l:lines, '    super.do_copy(rhs);')
    call add(l:lines, '    // TODO: this.xxx = that.xxx;')
    call add(l:lines, '  endfunction : do_copy')
    call add(l:lines, '  ------------------------------------------------------------------ */')
    call add(l:lines, '')
    call add(l:lines, '  // convert2string : 打印对象内容（配合 uvm_info 打印）')
    call add(l:lines, '  /* ------------------------------------------------------------------')
    call add(l:lines, '  virtual function string convert2string();')
    call add(l:lines, '    string s = super.convert2string();')
    call add(l:lines, '    // TODO: $sformatf(s, "%s\n addr:0x%0h", s, addr);')
    call add(l:lines, '    return s;')
    call add(l:lines, '  endfunction : convert2string')
    call add(l:lines, '  ------------------------------------------------------------------ */')
    call add(l:lines, '')
    call add(l:lines, '  // do_compare : 比较两个事务（scoreboard 常用）')
    call add(l:lines, '  /* ------------------------------------------------------------------')
    call add(l:lines, '  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);')
    call add(l:lines, '    ' . l:cls . ' that;')
    call add(l:lines, '    if (!$cast(that, rhs))')
    call add(l:lines, '      `uvm_fatal("DO_COMPARE", "cast of rhs object failed")')
    call add(l:lines, '    return super.do_compare(rhs, comparer) &&')
    call add(l:lines, '           1;  // TODO: && this.addr === that.addr')
    call add(l:lines, '  endfunction : do_compare')
    call add(l:lines, '  ------------------------------------------------------------------ */')
    call add(l:lines, '')
    call add(l:lines, 'endclass : ' . l:cls)
  endif

  if line('$') == 1 && empty(getline(1))
    call setline(1, l:lines)
  else
    call append(line('$'), '')
    call append(line('$'), l:lines)
  endif
  normal! ggzz
  echo '已生成 uvm_' . a:type . ' 模板：' . l:cls
endfunction

nnoremap <silent> <F5> :call <SID>UvmClass('component')<CR>
nnoremap <silent> <F6> :call <SID>UvmClass('object')<CR>

" ================= 其他实用项 =================
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" ---------- 机器个性化配置（字体等，不进仓库）----------
" 每台机器建一个 ~/.vimrc.local，写本机专属设置，例如：
"   set guifont=JetBrains\ Mono\ 11
"   set guifontwide=WenQuanYi\ Micro\ Hei\ 11
if filereadable(expand('~/.vimrc.local'))
  execute 'source ' . expand('~/.vimrc.local')
endif
