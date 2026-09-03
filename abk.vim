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
iabbrev ifb if () begin<CR>end<Esc>O    
iabbrev ife if () begin<CR>end else begin<CR>end<Esc>kO    
iabbrev fori for (int i = 0; i < N; i++) begin<CR>end<Esc>O    
iabbrev fore foreach (arr[i]) begin<CR>end<Esc>O    
iabbrev whi while () begin<CR>end<Esc>O    
iabbrev dob do begin<CR>end while ();<Esc>O    
iabbrev forev forever begin<CR>end<Esc>O    
iabbrev repe repeat () begin<CR>end<Esc>O    
iabbrev beg begin<CR>end<Esc>O    

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
iabbrev sfor $sformatf("%s", );
iabbrev spri $sprintf("%s", );
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

