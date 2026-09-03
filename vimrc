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
colorscheme onedark              " 默认主题，可按 F9 轮换
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

" ================= 快捷键（F 键族，EDA 常用）=================
" F2  文件树开关
map <F2> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" ==============================================
" 7. nerdtree - 文件树
" ==============================================
nnoremap <silent> <leader>n :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeWinPos = 'left'
let g:NERDTreeWinSize = 30
let g:NERDTreeShowHidden = 1
let g:NERDTreeIgnore = ['\.pyc$', '\.swp$', '\.git$', '__pycache__']
let g:NERDTreeSortOrder=['\/$', '*', '[[timestamp]]']
nmap <leader>n :NERDTreeToggle <cr>
map <leader>ff :NERDTreeFind<cr><C-w><C-w>
autocmd VimEnter * NERDTree | wincmd p

" F3  .v <-> .vh 头文件互跳
nnoremap <F3> :A<CR>

" F8  Tagbar 代码结构栏
nmap <F8> :TagbarToggle<CR>
let g:tagbar_width = 30

" ================= CtrlP 模糊搜索 =================
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'   " 从项目根开始搜索
let g:ctrlp_max_files = 20000
let g:ctrlp_show_hidden = 1

" ================= Tabular 对齐 =================
" 可视模式选中后：\a=  按 = 对齐；\a:  按 : 对齐
vnoremap <Leader>a= :Tabularize /=<CR>
vnoremap <Leader>a: :Tabularize /:<CR>

" ================= nerdcommenter =================
" 默认快捷键：\cc 注释、\cu 取消、\c<space> 切换
let g:NERDSpaceDelims = 1    " 注释符后加空格（// 风格）

" ================= airline 状态栏 =================
let g:airline#extensions#tabline#enabled = 1

" ================= Verilog / SystemVerilog =================
" vim 7.4 无独立 systemverilog 语法文件，有则用之，无则回退 verilog
if !empty(globpath(&rtp, 'syntax/systemverilog.vim'))
  au BufRead,BufNewFile *.sv,*.svh set filetype=systemverilog
else
  au BufRead,BufNewFile *.sv,*.svh set filetype=verilog
endif
au BufRead,BufNewFile *.v set filetype=verilog

" ================= 主题轮换（F9）=================
" 在已安装的主题间循环切换，方便挑顺眼的
"let g:my_themes = ['gruvbox', 'onedark', 'dracula', 'apprentice', 'molokai',  'solarized']
let g:my_themes = ['gruvbox', 'onedark', 'molokai',  'solarized']
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

" ================= 其他实用项 =================
" 打开文件时记住上次光标位置
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"防止中文注释乱码
set fileencoding=utf-8
set fenc=utf-8
set fencs=utf-8,usc-bom,euc-jp,gb18030,gbk,gb2312,cp936,big－5                    
set enc=utf-8
let &termencoding=&encoding

"退格键一次删除4个空格
"set softtabstop=4
autocmd FileType make set noexpandtab

" 在编辑过程中，在右下角显示光标位置的状态行
set ruler
" 在状态列显示目前所执行的指令
set showcmd

"General {{{
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
"}}}

"Lang & Encoding {{{
set fileencodings=utf-8,gbk2312,gbk,gb18030,cp936
set langmenu=zh_CN
let $LANG = 'en_US.UTF-8'
"language messages zh_CN.UTF-8
"}}}

"GUI {{{
"source $VIMRUNTIME/delmenu.vim
"source $VIMRUNTIME/menu.vim
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
"}}}
"Format {{{
set foldmethod=indent
set nofoldenable
set autochdir
"}}}

"Keymap {{{
let mapleader=","
nmap <leader>sc :source $VIM/.vimrc<cr>
nmap <leader>ec :e $VIM/.vimrc<cr>
map <leader>tn :tabnew<cr>
map <leader>tc :tabclose<cr>
map <leader>tp :tabp<cr>
map <leader>tl :tabn<cr>
nmap <F10> "0p
map <F10> "0p

nnoremap <leader>w :set wrap!<cr>
"打开当前目录 windows
"map <leader>ex :!start explorer %:p:h<CR>

"打开当前目录CMD
"map <leader>cmd :!start<cr>
"打印当前时间
map <F3> a<C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR><Esc>
"复制当前文件/路径到剪贴板
nmap  <leader>fn :let @*=substitute(expand("%"), "/", "\\", "g")<CR>
nmap <leader>fp :let @*=substitute(expand("%:p"), "/", "\\", "g")<CR>
"设置切换Buffer快捷键"
nnoremap <C-left> :bn<CR>
nnoremap <C-right> :bp<CR>
nmap <C-s> :wall<CR>
imap <C-s> <ESC>:wall<CR>
"}}}

"----- Nerdcommenter ----- {{{
map <C-\> <Plug>NERDCommenterToggle
nmap <C-t> :TagbarToggle<CR>
"}}}


" ==============================================
" 11. nerdcommenter - 快速注释
" ==============================================
let g:NERDCommenterCreateFileCmds = 1
let g:NERDCommenterSpaceCompress = 0
" 常用快捷键：
"   <leader>cc - 注释当前行/选中块
"   <leader>cu - 取消注释
"   <leader>cA - 在行尾添加注释并进入插入模式
nnoremap <silent> <leader>cc :call nerdcommenter#Comment(0,"toggle")<CR>
vnoremap <silent> <leader>cc :call nerdcommenter#Comment(1,"toggle")<CR>

" ============================================================================
" SystemVerilog class template generators
" Insert a class skeleton after the current line.
"
"   :call SVGenObject()      -> uvm_object style    (common utility methods)
"   :call SVGenComponent()   -> uvm_component style (phase methods/tasks)
"
" Installation: append the contents of this file to your ~/.vimrc, or put this
"               file under ~/.vim/plugin/ so it is sourced automatically.
"
" Optional key bindings:
"   nnoremap <Leader>so :call SVGenObject()<CR>
"   nnoremap <Leader>sc :call SVGenComponent()<CR>
"
" Indentation: 4 spaces.
" ============================================================================

" ----------------------------------------------------------------------------
" Generate an OBJECT-style class (base: uvm_object by default).
" ----------------------------------------------------------------------------
function! SVGenObject()
    " let l:name = input('Class name: ')
    let l:name = expand('%:t:r')
    if l:name == ''
        echohl WarningMsg | echo 'Cancelled: no class name given' | echohl None
        return
    endif

    let l:base = input('Base class: ', 'uvm_object')
    if l:base == ''
        let l:base = 'uvm_object'
    endif

    let l:lines = []

    " ---- class header -------------------------------------------------------
    call add(l:lines, '//------------------------------------------------------------------------------')
    call add(l:lines, '// Class : ' . l:name)
    call add(l:lines, '// Base  : ' . l:base)
    call add(l:lines, '// Brief : ')
    call add(l:lines, '//------------------------------------------------------------------------------')
    call add(l:lines, 'class ' . l:name . ' extends ' . l:base . ';')
    call add(l:lines, '')
    call add(l:lines, '    `uvm_object_utils_begin(' . l:name . ')')
    call add(l:lines, '         //`uvm_field_int(var, UVM_ALL_ON)')
    call add(l:lines, '         //`uvm_field_string(var, UVM_ALL_ON)')
    call add(l:lines, '         //`uvm_field_sarray_int(var, UVM_ALL_ON)')
    call add(l:lines, '         //`uvm_field_array_int(var, UVM_ALL_ON)')
    call add(l:lines, '    `uvm_object_utils_end')
    call add(l:lines, '')
    " ---- constructor --------------------------------------------------------
    call add(l:lines, '    //--------------------------------------------------------------------------')
    call add(l:lines, '    // Function : new')
    call add(l:lines, '    // Brief    : constructor')
    call add(l:lines, '    //--------------------------------------------------------------------------')
    call add(l:lines, '    function new(string name = "' . l:name . '");')
    call add(l:lines, '        super.new(name);')
    call add(l:lines, '    endfunction : new')
    call add(l:lines, '')

    " ---- do_copy ------------------------------------------------------------
    call add(l:lines, '    //--------------------------------------------------------------------------')
    call add(l:lines, '    // Function : do_copy')
    call add(l:lines, '    // Brief    : deep-copy hook')
    call add(l:lines, '    //--------------------------------------------------------------------------')
    call add(l:lines, '    function void do_copy(uvm_object rhs);')
    call add(l:lines, '        super.do_copy(rhs);')
    call add(l:lines, '        // TODO : copy fields from rhs here')
    call add(l:lines, '    endfunction : do_copy')
    call add(l:lines, '')

    " ---- do_compare ---------------------------------------------------------
    call add(l:lines, '    //--------------------------------------------------------------------------')
    call add(l:lines, '    // Function : do_compare')
    call add(l:lines, '    // Brief    : comparison hook')
    call add(l:lines, '    //--------------------------------------------------------------------------')
    call add(l:lines, '    function bit do_compare(uvm_object rhs, uvm_comparer comparer);')
    call add(l:lines, '        return super.do_compare(rhs, comparer);')
    call add(l:lines, '        // TODO : compare fields against rhs here')
    call add(l:lines, '    endfunction : do_compare')
    call add(l:lines, '')

    " ---- convert2string -----------------------------------------------------
    call add(l:lines, '    //--------------------------------------------------------------------------')
    call add(l:lines, '    // Function : convert2string')
    call add(l:lines, '    // Brief    : printable representation')
    call add(l:lines, '    //--------------------------------------------------------------------------')
    call add(l:lines, '    function string convert2string();')
    call add(l:lines, '        return $sformatf("%s", super.convert2string());')
    call add(l:lines, '        // TODO : append field values here')
    call add(l:lines, '    endfunction : convert2string')
    call add(l:lines, '')

    call add(l:lines, 'endclass : ' . l:name)

    call append(line('.'), l:lines)
    call cursor(line('.') + 1, 1)
    echohl Function | echo 'Generated object class ' . l:name | echohl None
endfunction

" ----------------------------------------------------------------------------
" Generate a COMPONENT-style class (base: uvm_component by default).
" ----------------------------------------------------------------------------
function! SVGenComponent()
    " let l:name = input('Class name: ')
    let l:name = expand('%:t:r')
    if l:name == ''
        echohl WarningMsg | echo 'Cancelled: no class name given' | echohl None
        return
    endif

    let l:base = input('Base class: ', 'uvm_component')
    if l:base == ''
        let l:base = 'uvm_component'
    endif

    let l:lines = []

    " ---- class header -------------------------------------------------------
    call add(l:lines, '//------------------------------------------------------------------------------')
    call add(l:lines, '// Class : ' . l:name)
    call add(l:lines, '// Base  : ' . l:base)
    call add(l:lines, '// Brief : ')
    call add(l:lines, '//------------------------------------------------------------------------------')
    call add(l:lines, 'class ' . l:name . ' extends ' . l:base . ';')
    call add(l:lines, '')
    call add(l:lines, '')
    call add(l:lines, '')
    call add(l:lines, '    `uvm_component_utils_begin(' . l:name . ')')
    call add(l:lines, '         //`uvm_field_int(var, UVM_ALL_ON)')
    call add(l:lines, '         //`uvm_field_string(var, UVM_ALL_ON)')
    call add(l:lines, '         //`uvm_field_sarray_int(var, UVM_ALL_ON)')
    call add(l:lines, '         //`uvm_field_array_int(var, UVM_ALL_ON)')
    call add(l:lines, '    `uvm_component_utils_end')
    call add(l:lines, '')
    " ---- constructor --------------------------------------------------------
    call add(l:lines, '    //--------------------------------------------------------------------------')
    call add(l:lines, '    // Function : new')
    call add(l:lines, '    // Brief    : constructor')
    call add(l:lines, '    //--------------------------------------------------------------------------')
    call add(l:lines, '    function new(string name, uvm_component parent);')
    call add(l:lines, '        super.new(name, parent);')
    call add(l:lines, '    endfunction : new')
    call add(l:lines, '')

    " ---- build_phase --------------------------------------------------------
    call add(l:lines, '    //--------------------------------------------------------------------------')
    call add(l:lines, '    // Function : build_phase')
    call add(l:lines, '    //--------------------------------------------------------------------------')
    call add(l:lines, '    function void build_phase(uvm_phase phase);')
    call add(l:lines, '        super.build_phase(phase);')
    call add(l:lines, '        // TODO : build child components here')
    call add(l:lines, '    endfunction : build_phase')
    call add(l:lines, '')

    " ---- connect_phase ------------------------------------------------------
    call add(l:lines, '    //--------------------------------------------------------------------------')
    call add(l:lines, '    // Function : connect_phase')
    call add(l:lines, '    //--------------------------------------------------------------------------')
    call add(l:lines, '    function void connect_phase(uvm_phase phase);')
    call add(l:lines, '        super.connect_phase(phase);')
    call add(l:lines, '        // TODO : connect ports / TLM here')
    call add(l:lines, '    endfunction : connect_phase')
    call add(l:lines, '')

    " ---- end_of_elaboration_phase ------------------------------------------
    call add(l:lines, '    //--------------------------------------------------------------------------')
    call add(l:lines, '    // Function : end_of_elaboration_phase')
    call add(l:lines, '    //--------------------------------------------------------------------------')
    call add(l:lines, '    function void end_of_elaboration_phase(uvm_phase phase);')
    call add(l:lines, '        super.end_of_elaboration_phase(phase);')
    call add(l:lines, '        // TODO : post-elaboration checks here')
    call add(l:lines, '    endfunction : end_of_elaboration_phase')
    call add(l:lines, '')

    " ---- start_of_simulation_phase -----------------------------------------
    call add(l:lines, '    //--------------------------------------------------------------------------')
    call add(l:lines, '    // Function : start_of_simulation_phase')
    call add(l:lines, '    //--------------------------------------------------------------------------')
    call add(l:lines, '    function void start_of_simulation_phase(uvm_phase phase);')
    call add(l:lines, '        super.start_of_simulation_phase(phase);')
    call add(l:lines, '        // TODO : pre-simulation setup here')
    call add(l:lines, '    endfunction : start_of_simulation_phase')
    call add(l:lines, '')

    " ---- run_phase ----------------------------------------------------------
    call add(l:lines, '    //--------------------------------------------------------------------------')
    call add(l:lines, '    // Task     : run_phase')
    call add(l:lines, '    //--------------------------------------------------------------------------')
    call add(l:lines, '    task run_phase(uvm_phase phase);')
    call add(l:lines, '        super.run_phase(phase);')
    call add(l:lines, '        // TODO : main stimulus / behaviour here')
    call add(l:lines, '    endtask : run_phase')
    call add(l:lines, '')

    " ---- report_phase -------------------------------------------------------
    call add(l:lines, '    //--------------------------------------------------------------------------')
    call add(l:lines, '    // Function : report_phase')
    call add(l:lines, '    //--------------------------------------------------------------------------')
    call add(l:lines, '    function void report_phase(uvm_phase phase);')
    call add(l:lines, '        super.report_phase(phase);')
    call add(l:lines, '        // TODO : report results here')
    call add(l:lines, '    endfunction : report_phase')
    call add(l:lines, '')

    call add(l:lines, 'endclass : ' . l:name)

    call append(line('.'), l:lines)
    call cursor(line('.') + 1, 1)
    echohl Function | echo 'Generated component class ' . l:name | echohl None
endfunction

" Optional convenience commands
command! SVObject    call SVGenObject()
command! SVComponent call SVGenComponent()
nnoremap <silent> <leader>svo :call SVGenObject()<CR>
nnoremap <silent> <leader>svc :call SVGenComponent()<CR>

" =============================================================================
" SystemVerilog  insert-mode abbreviations  (gvim 7.4 / CentOS 7)
"
" 触发方式：输入左侧「触发词」后接一个非关键字字符（空格、()、;、回车等），
"           即展开为右侧模板；用于触发的那一个字符会被消费掉、不会插入。
"
" 光标落点：多数块模板以 <Esc>O 结尾（Esc 退出插入模式 → O 在结束符上方开一
"           空行），其后的空格用于给光标定位到块内并缩进。请保留这些行尾空格。
"           若你的编辑器会自动删除行尾空白，唯一影响是光标落在第 1 列。
"
" 缩进设置（与模板的 4 空格缩进匹配）：
"       set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
"
" 注意：
"   - 仅插入模式下生效；开启 'paste' 时不会展开。
"   - 若只想在 .sv/.svh 中生效，把下面的 iabbrev 换成 iabbrev <buffer>，
"     并包一层 augroup + FileType systemverilog,verilog 即可。
" =============================================================================

" --- module / interface / package / program / class --------------------------
iabbrev modx module mod_name (<CR>    input logic clk,<CR>    input logic rst_n<CR>);<CR>endmodule : mod_name<Esc>O    
iabbrev itfx interface intf_name ();<CR>endinterface : intf_name<Esc>O    
iabbrev pkgx package pkg_name;<CR>endpackage : pkg_name<Esc>O    
iabbrev progx program prog_name ();<CR>endprogram : prog_name<Esc>O    
iabbrev clsx class cls_name;<CR>endclass : cls_name<Esc>O    

" --- typedef struct / enum / union ------------------------------------------
iabbrev structx typedef struct packed {<CR>} struct_name_t;<Esc>O    
iabbrev enumx typedef enum logic [1:0] {<CR>} enum_name_t;<Esc>O    
iabbrev unionx typedef union packed {<CR>} union_name_t;<Esc>O    

" --- always blocks ----------------------------------------------------------
iabbrev alw always @(*) begin<CR>end<Esc>O    
iabbrev alwcb always_comb begin<CR>end<Esc>O    
iabbrev alwl always_latch begin<CR>end<Esc>O    
iabbrev alwff always_ff @(posedge clk) begin<CR>end<Esc>O    
iabbrev alwffr always_ff @(posedge clk or negedge rst_n) begin<CR>    if (!rst_n) begin<CR>    end else begin<CR>    end<CR>end<Esc>kO        
iabbrev alwffs always_ff @(posedge clk) begin<CR>    if (rst_n) begin<CR>    end else begin<CR>    end<CR>end<Esc>kO        

" --- initial / final --------------------------------------------------------
iabbrev initx initial begin<CR>end<Esc>O    
iabbrev finalx final begin<CR>end<Esc>O    

" --- control flow -----------------------------------------------------------
iabbrev ifx if () begin<CR>end<Esc>O    
iabbrev ifex if () begin<CR>end else begin<CR>end<Esc>kO    
iabbrev forx for (int i = 0; i < N; i++) begin<CR>end<Esc>O    
iabbrev fore foreach (arr[i]) begin<CR>end<Esc>O    
iabbrev whx while () begin<CR>end<Esc>O    
iabbrev dowh do begin<CR>end while ();<Esc>O    
iabbrev forev forever begin<CR>end<Esc>O    
iabbrev repx repeat () begin<CR>end<Esc>O    
iabbrev blk begin<CR>end<Esc>O    

" --- case -------------------------------------------------------------------
iabbrev cas case ()<CR>endcase<Esc>O    
iabbrev casz casez ()<CR>endcase<Esc>O    
iabbrev casx casex ()<CR>endcase<Esc>O    

" --- fork / join ------------------------------------------------------------
iabbrev forkn fork<CR>join_none<Esc>O    
iabbrev forka fork<CR>join_any<Esc>O    
iabbrev forkj fork<CR>join<Esc>O    

" --- function / task --------------------------------------------------------
iabbrev funcx function void ();<CR>endfunction <Esc>O    
iabbrev funcr function logic ();<CR>endfunction<Esc>O    
iabbrev taskx task ();<CR>endtask<Esc>O    
iabbrev newx function new(string name);<CR>    super.new(name);<CR>endfunction : new<Esc>O    

" --- generate ---------------------------------------------------------------
iabbrev genx generate<CR>endgenerate<Esc>O    

" --- assertions / coverage --------------------------------------------------
iabbrev asrt assert property (@(posedge clk));
iabbrev coverg covergroup  @(posedge clk);<CR>endgroup<Esc>O    
iabbrev covp coverpoint {<CR>}<Esc>O    
iabbrev cros cross cp_a, cp_b;

" --- $display / $format / $finish / report ----------------------------------
iabbrev disp $display("");
iabbrev sfmt $sformatf("%s", );
iabbrev sprint $sprintf("%s", );
iabbrev sfin $finish();
iabbrev serr $error("");
iabbrev sinfo $info("");
iabbrev sfatal $fatal(1);

" --- preprocessor / timescale -----------------------------------------------
iabbrev tsx `timescale 1ns/1ps
iabbrev ifdx `ifdef MACRO<CR>`endif<Esc>O    
iabbrev ifndefx `ifndef MACRO<CR>`endif<Esc>O    

" --- misc -------------------------------------------------------------------
iabbrev posx @(posedge clk)
iabbrev negx @(negedge rst_n)
iabbrev lte <=
iabbrev que [$]
iabbrev uran $urandom_range();
iabbrev std std::randomize() with {};

" --- log -------------------------------------------------------------------
iabbrev logi `uvm_info(get_type_name(), $sformatf("", ), UVM_NONE)
iabbrev logw `uvm_warning(get_type_name(), $sformatf("", ))
iabbrev loge `uvm_error(get_type_name(), $sformatf("", ))
iabbrev logf `uvm_fatal(get_type_name(), $sformatf("", ))

" ---------- 机器个性化配置（字体等，不进仓库）----------
" 每台机器建一个 ~/.vimrc.local，写本机专属设置，例如：
"   set guifont=JetBrains\ Mono\ 11
"   set guifontwide=WenQuanYi\ Micro\ Hei\ 11
if filereadable(expand('~/.vimrc.local'))
  execute 'source ' . expand('~/.vimrc.local')
endif

