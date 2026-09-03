# vim-dotfiles

便携版 EDA gvim 配置（兼容 gvim 7.4+ / CentOS 7）。克隆到任何 Linux 机器，
跑一次 install.sh 即可用，不依赖 `~/.vim` 固定目录。

## 结构

```
vim-dotfiles/
├── install.sh        # 一键安装（生成 bootstrap ~/.vimrc + 软链 .ctags）
├── vimrc             # 完整配置（路径全部自适应仓库位置）
├── ctags.conf        # Verilog/SV 的 ctags 规则（Tagbar 用）
├── setup-fonts.sh    # 编程字体安装（可选，每台机器跑一次）
└── vim/bundle/       # 插件目录（提交进仓库，克隆即得）
```

## 新机器安装

```bash
git clone <仓库地址> ~/vim-dotfiles
bash ~/vim-dotfiles/install.sh
gvim any_file.v
```

## 原理

- gvim 固定加载 `~/.vimrc` → install.sh 生成一个 2 行的 bootstrap，
  `source` 仓库里的 vimrc，本体配置全部进仓库
- vimrc 用 `expand('<sfile>')` 定位仓库根，把 `vim/bundle/` 下所有目录
  加入 `runtimepath`（等效 pathogen），gvim 就能从仓库目录加载插件
- Vundle 的安装目录也指向仓库 bundle（`vundle#begin(path)`），
  以后 `:PluginInstall` 装的新插件同样落在仓库里，git 提交即同步

## 个性化

每台机器的字体等差异设置写 `~/.vimrc.local`（不进仓库）：

```vim
set guifont=JetBrains\ Mono\ 11
set guifontwide=WenQuanYi\ Micro\ Hei\ 11
```

## 快捷键

| 键 | 功能 |
|----|------|
| F2 | NERDTree 文件树 |
| F3 | .v <-> .vh 跳转 |
| F5 / F6 | 生成 UVM component / object 类模板 |
| F8 | Tagbar 代码结构 |
| F9 | 轮换主题 |
| Ctrl+P | 模糊找文件 |
| \cc / \cu | 注释 / 取消注释 |

## 维护

- 改配置：编辑仓库里的 `vimrc`，commit + push，其他机器 `git pull` 即生效
- 加插件：vimrc 加 Plugin 行 → `:PluginInstall` → commit bundle 目录
- 字体体积大，不入库；新机器需要时跑 `setup-fonts.sh`
