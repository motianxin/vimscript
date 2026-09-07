# vimscript —— 便携版 EDA gvim 配置

面向 **UVM / SystemVerilog** 开发的 gvim（Vim 7.4 / CentOS 7）配置仓库。
克隆到任意 Linux 机器，跑一次 `install.sh` 即可使用，插件经 Vundle 统一管理、
版本按 gvim 7.4 兼容性锁定，避免新版本插件对旧 Vim 不兼容。

> 仓库地址：`git@gitee.com:zghuang55/vimscript.git`

---

## 功能特性

- **UVM 类模板生成**：根据当前 `.sv` 文件名一键生成 `uvm_object` / `uvm_component` 类型的完整 class 骨架（含 `new`、`build_phase`、`run_phase` 等标准方法和宏）。
- **SystemVerilog 插入缩写**：输入 `modx`、`alwff`、`clsx`、`ifb`、`funcx` 等触发词即可展开为 Verilog/SV 常用代码块。
- **代码导航**：NERDTree 文件树、Tagbar 代码结构栏、CtrlP 模糊找文件、`.v ⇄ .vh` 跳转。
- **主题轮换**：F9 在多个暗色护眼主题间循环切换。
- **Verilog/SV 语法高亮与 ctags**：`ctags.conf` 提供模块/类/task/function/parameter/assign/宏的标签规则（供 Tagbar 使用，兼容 exuberant-ctags 5.8）。
- **目录快速跳转**：`go.sh` 把常用目录记入历史，彩色表格展示、按序号跳转。
- **彩色终端提示符**：`user.bashrc` 提供带时间/路径/git 状态的 PS1 及常用别名。

## 目录结构

```
vimscript/
├── vimrc              # 主入口：依次 source 各模块
├── base_config.vim    # 核心：路径自适应、Vundle 插件加载、外观/缩进/搜索/编码
├── plugin_config.vim  # 插件配置、主题轮换、UVM 类模板生成器(SVGenObject/SVGenComponent)
├── keymap.vim         # 快捷键映射
├── abk.vim            # SystemVerilog 插入模式缩写（snippets）
├── custom_config.vim  # 机器个性化配置（加载 ~/.vimrc.local）
├── install.sh         # 一键安装：生成 bootstrap ~/.vimrc + 软链 ~/.ctags
├── setup-fonts.sh     # 编程字体一键安装（可选，每台机器跑一次）
├── ctags.conf         # Verilog/SV 的 ctags 规则（Tagbar 依赖）
├── go.sh              # 彩色目录历史跳转工具（source 后以 `go` 调用）
├── user.bashrc        # 彩色 PS1 + 常用命令别名
├── README.md          # 本文档（中文）
└── README.en.md       # 英文版
```

## 新机器安装

```bash
# 1. 克隆到本地（路径任意，不依赖 ~/.vim 固定目录）
git clone git@gitee.com:zghuang55/vimscript.git ~/vimscript
cd ~/vimscript

# 2. 一键安装
bash install.sh

# 3. 启动 gvim 验证
gvim your_testbench.sv
```

`install.sh` 会完成：

1. （首次）若本机 `~/.vim/bundle` 已有插件而仓库为空，自动迁移进仓库；
2. 备份旧的 `~/.vimrc` / `~/.vim` / `~/.ctags` 为 `.bak.<时间戳>`；
3. 生成一个 2 行的 bootstrap `~/.vimrc`，`source` 仓库里的 `vimrc`（本体配置全部进仓库）；
4. 创建软链 `~/.ctags → 仓库/ctags.conf`；
5. 将 `source ~/vimscript/user.bashrc` 追加进 `~/.bashrc`。

## 个性化配置（不进仓库）

每台机器差异化的设置（如字体）写入 `~/.vimrc.local`，`custom_config.vim` 会自动加载：

```vim
set guifont=JetBrains\ Mono\ NL\ SemiBold\ 14
set guifontwide=WenQuanYi\ Micro\ Hei\ 11
```

## 插件

- **插件管理器**：Vundle（插件列表位于 `base_config.vim`）。
- **已配置插件**：`NERDTree`、`ctrlp.vim`、`tagbar`、`nerdcommenter`、`tabular`、`a.vim`、`vim-airline`。
- **主题**：`gruvbox`、`onedark`（默认）、`dracula`、`Apprentice`、`molokai`、`solarized`。
- **新增插件**：在 `base_config.vim` 的 `call vundle#begin()` 与 `call vundle#end()` 之间加一行 `Plugin 'owner/repo'`，然后执行 `:PluginInstall`。

> 说明：插件本体（`vim/bundle/`）**不**提交进仓库，由 Vundle 在目标机器上安装。
> 部分插件版本已按 gvim 7.4 兼容性锁定过版本号（tag），勿随意升级到最新版。

## 快捷键

| 键 | 功能 |
|----|------|
| `F2` | NERDTree 文件树开关 |
| `F3` | 插入当前时间 |
| `F5` | 复制选中内容到系统剪贴板 |
| `F6` | 从系统剪贴板粘贴 |
| `F8` | Tagbar 代码结构开关 |
| `F9` | 轮换主题 |
| `<C-p>` | CtrlP 模糊找文件 |
| `<C-s>` | 保存所有文件 |
| `<C-\>` | 注释 / 取消注释（nerdcommenter） |
| `<C-l>/<C-r>` 或 `<C-left>/<C-right>` | 切换 buffer |
| `,n` | NERDTree 开关 |
| `,cc` | 注释切换 |
| `,a=` `,a:` `,a,` | 按 `=` / `:` / `,` 对齐（tabular） |
| `,so` / `,svo` | 生成 UVM **object** 类模板 |
| `,sc` / `,svc` | 生成 UVM **component** 类模板 |
| `<S-Up>` / `<S-Down>` | 上移 / 下移当前行 |

`<leader>` 为 `,`（在 `keymap.vim` 中设置）。

## UVM 类模板生成

基于当前文件名自动生成类名（`expand('%:t:r')`），可在插入时输入基类名。

- **`,so`（`SVGenObject`）**：生成 `uvm_object` 风格类，包含 `new`、`do_copy`、`do_compare`、`convert2string` 及 `uvm_object_utils_begin/end` 宏。
- **`,sc`（`SVGenComponent`）**：生成 `uvm_component` 风格类，包含 `new`、`build_phase`、`connect_phase`、`end_of_elaboration_phase`、`start_of_simulation_phase`、`run_phase`、`report_phase` 及 `uvm_component_utils_begin/end` 宏。

也可直接执行命令 `:SVObject` / `:SVComponent`。

## SystemVerilog 插入缩写（abk.vim）

插入模式下输入触发词后接一个非关键字字符（空格、`(`、`;`、回车）即可展开。
示例：

- `modx` → `module ... endmodule`
- `itfx` → `interface ... endinterface`
- `clsx` → `class ... endclass`
- `alwff` → `always_ff @(posedge clk) begin ... end`
- `ifb` / `ife` / `fori` / `whi` / `cas` → 各控制流块
- `funcx` / `taskx` / `newx` → function / task / 构造函数
- `disp` / `sfor` / `sfin` → `$display()` / `$sformatf()` / `$finish()`
- `logi` / `logw` / `loge` / `logf` → `uvm_info` / `uvm_warning` / `uvm_error` / `uvm_fatal`

完整列表见 `abk.vim`。

## 目录快速跳转（go.sh）

```bash
source ~/vimscript/go.sh     # 或 source ~/vimscript/user.bashrc（含 go 别名）

go        # 显示历史记录并选择跳转
go -a     # 添加当前目录到历史
go -l     # 显示历史记录（彩色表格）
go -r     # 删除某条历史记录
go -s     # 显示简化版历史
```

历史文件默认位于 `~/go.his`，行号以 7 种颜色循环显示。

## 维护

- **改配置**：编辑仓库里的 `vimrc` 或各 `.vim` 模块 → `commit` + `push`，其他机器 `git pull` 即生效。
- **加插件**：`base_config.vim` 加 `Plugin` 行 → `:PluginInstall`。
- **字体**：体积大不入库，新机器需要时运行 `bash setup-fonts.sh`（会安装 JetBrains Mono / Fira Code / Source Code Pro / Cascadia Code）。
- **换机器**：克隆仓库 → `bash install.sh` → 写入 `~/.vimrc.local` 字体 → `source ~/.bashrc`。
