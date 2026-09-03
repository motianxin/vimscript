let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeWinPos = 'left'
let g:NERDTreeWinSize = 30
let g:NERDTreeShowHidden = 1
let g:NERDTreeIgnore = ['\.pyc$', '\.swp$', '\.git$', '__pycache__']
let g:NERDTreeSortOrder=['\/$', '*', '[[timestamp]]']
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd VimEnter * NERDTree | wincmd p

let g:tagbar_width = 30

" ================= CtrlP 模糊搜索 =================
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'   " 从项目根开始搜索
let g:ctrlp_max_files = 20000
let g:ctrlp_show_hidden = 1

" ==============================================
" 11. nerdcommenter - 快速注释
" ==============================================
let g:NERDCommenterCreateFileCmds = 1
let g:NERDCommenterSpaceCompress = 0
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

" ================= 其他实用项 =================
" 打开文件时记住上次光标位置
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

autocmd FileType make set noexpandtab
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


