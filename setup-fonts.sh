#!/bin/bash
# setup-fonts.sh —— 编程字体一键安装（每台机器执行一次，字体不入库）
set -e

FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
TMP=$(mktemp -d)
cd "$TMP"

echo "==> 通过 git clone 下载字体（已配 GitHub 加速则自动生效）..."

git clone --depth 1 --quiet https://github.com/JetBrains/JetBrainsMono.git
git clone --depth 1 --quiet https://github.com/tonsky/FiraCode.git
git clone --depth 1 --quiet https://github.com/adobe-fonts/source-code-pro.git
git clone --depth 1 --quiet https://github.com/microsoft/cascadia-code.git

echo "==> 安装到 $FONT_DIR ..."
find . -iname "*.ttf" -exec cp -f {} "$FONT_DIR/" \;

echo "==> 刷新字体缓存 ..."
fc-cache -fv "$FONT_DIR" > /dev/null

echo "==> 安装结果："
fc-list | grep -Ei "jetbrains mono|fira code|source code|cascadia" | sort

echo ""
echo "==> 完成！把字体设置写进 ~/.vimrc.local，例如："
echo '    set guifont=JetBrains\ Mono\ 11'
echo '    set guifontwide=WenQuanYi\ Micro\ Hei\ 11'

rm -rf "$TMP"
