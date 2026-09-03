" ---------- 机器个性化配置（字体等，不进仓库）----------
" 每台机器建一个 ~/.vimrc.local，写本机专属设置，例如：
"   set guifont=JetBrains\ Mono\ 11
"   set guifontwide=WenQuanYi\ Micro\ Hei\ 11
if filereadable(expand('~/.vimrc.local'))
  execute 'source ' . expand('~/.vimrc.local')
endif

