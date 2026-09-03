#!/bin/bash
# ============================================================
# install.sh —— vim-dotfiles 一键安装
# 作用：
#   1. 若仓库 vim/bundle 为空且 ~/.vim/bundle 有插件，先把插件搬进仓库
#   2. 备份本机旧的 ~/.vimrc / ~/.vim / ~/.ctags
#   3. 生成 bootstrap ~/.vimrc，指向仓库内 vimrc
#   4. 软链 ~/.ctags 指向仓库 ctags.conf
# 用法：git clone 仓库后，进入目录执行  bash install.sh
# ============================================================
set -e
REPO="$(cd "$(dirname "$0")" && pwd)"
STAMP=$(date +%Y%m%d%H%M%S)

echo "==> 仓库目录: $REPO"

# 1. 迁移插件（仅首次：仓库 bundle 为空且本机 ~/.vim/bundle 有货）
if [ ! -d "$REPO/vim/bundle/Vundle.vim" ] && [ -d "$HOME/.vim/bundle" ]; then
  echo "==> 检测到本机已有插件，迁移到仓库 vim/bundle/ ..."
  mkdir -p "$REPO/vim/bundle"
  cp -rf "$HOME/.vim/bundle/." "$REPO/vim/bundle/"
fi

# 2. 备份旧配置（软链本身不备份，直接覆盖）
for f in "$HOME/.vimrc" "$HOME/.ctags"; do
  if [ -e "$f" ] && [ ! -L "$f" ]; then
    mv "$f" "$f.bak.$STAMP"
    echo "备份 $f -> $f.bak.$STAMP"
  fi
done
if [ -d "$HOME/.vim" ] && [ ! -L "$HOME/.vim" ]; then
  mv "$HOME/.vim" "$HOME/.vim.bak.$STAMP"
  echo "备份 ~/.vim -> ~/.vim.bak.$STAMP"
fi

# 3. 生成 bootstrap ~/.vimrc（gvim 固定只加载这个文件，让它转手 source 仓库配置）
cat > "$HOME/.vimrc" <<EOF
" 自动生成 by vim-dotfiles install.sh —— 请勿手动编辑
let g:dotvim_repo = '$REPO'
source $REPO/vimrc
EOF
echo "==> 已生成 bootstrap ~/.vimrc"
echo "source ~/vimscript/user.bashrc" >> $HOME/.bashrc
echo "==> 已生成 bootstrap ~/.bashrc"

# 4. ctags 配置软链
ln -sf "$REPO/ctags.conf" "$HOME/.ctags"
echo "==> 已链接 ~/.ctags -> $REPO/ctags.conf"

echo ""
echo "==> 安装完成！运行 gvim 验证（F2 文件树 / F5 F6 UVM 模板 / F8 Tagbar）"
echo "    个性化设置（字体等）写入 ~/.vimrc.local，见 vimrc 末尾说明"
