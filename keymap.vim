"Keymap {{{
let mapleader=","
nmap <leader>sc :source $VIM/.vimrc<cr>
nmap <leader>ec :e $HOME/vimscript/vimrc<cr>
map <leader>tn :tabnew<cr>
map <leader>tc :tabclose<cr>
map <leader>tp :tabp<cr>
map <leader>tl :tabn<cr>
nmap <leader>n :NERDTreeToggle <cr>
map <leader>ff :NERDTreeFind<cr><C-w><C-w>
nnoremap <leader>w :set wrap!<cr>
nnoremap <silent> <leader>n :NERDTreeToggle<CR>
"复制当前文件/路径到剪贴板
nmap  <leader>fn :let @*=substitute(expand("%"), "/", "\\", "g")<CR>
nmap <leader>fp :let @*=substitute(expand("%:p"), "/", "\\", "g")<CR>
map <F2> :NERDTreeToggle<CR>
"打印当前时间
map <F3> a<C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR><Esc>
vmap <F5> "+y
map <F6> "+p
nnoremap <F9> :call CycleTheme()<CR>
nmap <F10> "0p
map <F10> "0p
nmap <S-Up> ddkP
nmap <S-Down> ddp

nmap <F8> :TagbarToggle<CR>

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

" 常用快捷键：
"   <leader>cc - 注释当前行/选中块
"   <leader>cu - 取消注释
"   <leader>cA - 在行尾添加注释并进入插入模式
nnoremap <silent> <leader>cc :call nerdcommenter#Comment(0,"toggle")<CR>
vnoremap <silent> <leader>cc :call nerdcommenter#Comment(1,"toggle")<CR>

" ================= Tabular 对齐 =================
vnoremap <Leader>a= :Tabularize /=<CR>
vnoremap <Leader>a: :Tabularize /:<CR>
vnoremap <Leader>a, :Tabularize /,<CR>

nnoremap <silent> <leader>svo :call SVGenObject()<CR>
nnoremap <silent> <leader>svc :call SVGenComponent()<CR>
