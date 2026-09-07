# vimscript — Portable EDA gvim Configuration

A gvim (Vim 7.4 / CentOS 7) configuration repo for **UVM / SystemVerilog** development.
Clone it to any Linux machine, run `install.sh` once, and you are ready to go. Plugins are
managed by Vundle and have their versions locked for gvim 7.4 compatibility, so newer plugin
versions won't break the old Vim.

> Repo: `git@gitee.com:zghuang55/vimscript.git`

---

## Features

- **UVM class template generation**: generate a complete `uvm_object` / `uvm_component`
  class skeleton (with `new`, `build_phase`, `run_phase`, and other standard methods and
  macros) from the current `.sv` filename.
- **SystemVerilog insert-mode abbreviations**: type triggers like `modx`, `alwff`, `clsx`,
  `ifb`, `funcx` to expand into common Verilog/SV code blocks.
- **Code navigation**: NERDTree file tree, Tagbar code structure bar, CtrlP fuzzy file
  finder, `.v ⇄ .vh` switching.
- **Theme rotation**: F9 cycles through several dark eye-friendly themes.
- **Verilog/SV syntax highlighting + ctags**: `ctags.conf` provides tag rules for
  module/class/task/function/parameter/assign/macro (used by Tagbar, compatible with
  exuberant-ctags 5.8).
- **Quick directory jumping**: `go.sh` records frequently used directories into history and
  shows them in a colorful table for jumping by index.
- **Colorful terminal prompt**: `user.bashrc` supplies a PS1 with time / path / git status
  plus common command aliases.

## Directory Layout

```
vimscript/
├── vimrc              # Main entry: sources each module in order
├── base_config.vim    # Core: path adaptation, Vundle plugin loading, appearance/indent/search/encoding
├── plugin_config.vim  # Plugin config, theme rotation, UVM class generators (SVGenObject / SVGenComponent)
├── keymap.vim         # Key mappings
├── abk.vim            # SystemVerilog insert-mode abbreviations (snippets)
├── custom_config.vim  # Machine-specific config (loads ~/.vimrc.local)
├── install.sh         # One-click install: creates bootstrap ~/.vimrc + symlinks ~/.ctags
├── setup-fonts.sh     # One-click programming font install (optional, once per machine)
├── ctags.conf         # Verilog/SV ctags rules (required by Tagbar)
├── go.sh              # Colorful directory history jumping tool (call via `go`)
├── user.bashrc        # Colorful PS1 + common aliases
├── README.md          # This doc (Chinese)
└── README.en.md       # English version
```

## Installation on a New Machine

```bash
# 1. Clone to any location (does NOT depend on a fixed ~/.vim directory)
git clone git@gitee.com:zghuang55/vimscript.git ~/vimscript
cd ~/vimscript

# 2. One-click install
bash install.sh

# 3. Launch gvim and verify
gvim your_testbench.sv
```

`install.sh` will:

1. (First run only) If plugins already exist in `~/.vim/bundle` but the repo's bundle is
   empty, migrate them into the repo;
2. Back up the old `~/.vimrc` / `~/.vim` / `~/.ctags` as `.bak.<timestamp>`;
3. Generate a 2-line bootstrap `~/.vimrc` that `source`s the repo `vimrc` (all real config
   lives in the repo);
4. Create a symlink `~/.ctags → repo/ctags.conf`;
5. Append `source ~/vimscript/user.bashrc` to `~/.bashrc`.

## Personalization (not in the repo)

Machine-specific settings (e.g. fonts) go into `~/.vimrc.local`, which `custom_config.vim`
loads automatically:

```vim
set guifont=JetBrains\ Mono\ NL\ SemiBold\ 14
set guifontwide=WenQuanYi\ Micro\ Hei\ 11
```

## Plugins

- **Plugin manager**: Vundle (plugin list is in `base_config.vim`).
- **Configured plugins**: `NERDTree`, `ctrlp.vim`, `tagbar`, `nerdcommenter`, `tabular`,
  `a.vim`, `vim-airline`.
- **Themes**: `gruvbox`, `onedark` (default), `dracula`, `Apprentice`, `molokai`,
  `solarized`.
- **Adding a plugin**: add a `Plugin 'owner/repo'` line between `call vundle#begin()` and
  `call vundle#end()` in `base_config.vim`, then run `:PluginInstall`.

> Note: the plugin bodies (`vim/bundle/`) are **not** committed to the repo; Vundle installs
> them on the target machine. Some plugin versions are locked (by tag) for gvim 7.4
> compatibility — do not casually upgrade to the latest.

## Key Mappings

| Key | Function |
|----|----------|
| `F2` | NERDTree file tree toggle |
| `F3` | Insert current time |
| `F5` | Copy selection to system clipboard |
| `F6` | Paste from system clipboard |
| `F8` | Tagbar code structure toggle |
| `F9` | Cycle theme |
| `<C-p>` | CtrlP fuzzy file finder |
| `<C-s>` | Save all files |
| `<C-\>` | Comment / uncomment (nerdcommenter) |
| `<C-l>/<C-r>` or `<C-left>/<C-right>` | Switch buffer |
| `,n` | NERDTree toggle |
| `,cc` | Comment toggle |
| `,a=` `,a:` `,a,` | Align by `=` / `:` / `,` (tabular) |
| `,so` / `,svo` | Generate UVM **object** class template |
| `,sc` / `,svc` | Generate UVM **component** class template |
| `<S-Up>` / `<S-Down>` | Move current line up / down |

`<leader>` is `,` (set in `keymap.vim`).

## UVM Class Template Generation

The class name is derived from the current filename (`expand('%:t:r')`); you can type a base
class name when prompted.

- **`,so` (`SVGenObject`)**: generates a `uvm_object`-style class with `new`, `do_copy`,
  `do_compare`, `convert2string` and the `uvm_object_utils_begin/end` macros.
- **`,sc` (`SVGenComponent`)**: generates a `uvm_component`-style class with `new`,
  `build_phase`, `connect_phase`, `end_of_elaboration_phase`, `start_of_simulation_phase`,
  `run_phase`, `report_phase` and the `uvm_component_utils_begin/end` macros.

You can also run the commands `:SVObject` / `:SVComponent`.

## SystemVerilog Insert Abbreviations (abk.vim)

In insert mode, type a trigger followed by a non-keyword character (space, `(`, `;`, return)
to expand. Examples:

- `modx` → `module ... endmodule`
- `itfx` → `interface ... endinterface`
- `clsx` → `class ... endclass`
- `alwff` → `always_ff @(posedge clk) begin ... end`
- `ifb` / `ife` / `fori` / `whi` / `cas` → control-flow blocks
- `funcx` / `taskx` / `newx` → function / task / constructor
- `disp` / `sfor` / `sfin` → `$display()` / `$sformatf()` / `$finish()`
- `logi` / `logw` / `loge` / `logf` → `uvm_info` / `uvm_warning` / `uvm_error` / `uvm_fatal`

See `abk.vim` for the full list.

## Quick Directory Jumping (go.sh)

```bash
source ~/vimscript/go.sh     # or source ~/vimscript/user.bashrc (includes the `go` alias)

go        # show history and jump by selection
go -a     # add current directory to history
go -l     # show history (colorful table)
go -r     # remove a history entry
go -s     # show simplified history
```

The history file defaults to `~/go.his`; line numbers are cycled through 7 colors.

## Maintenance

- **Change config**: edit `vimrc` or any `.vim` module in the repo → `commit` + `push`;
  other machines just `git pull`.
- **Add a plugin**: add a `Plugin` line in `base_config.vim` → `:PluginInstall`.
- **Fonts**: too large to commit; run `bash setup-fonts.sh` on a new machine when needed
  (installs JetBrains Mono / Fira Code / Source Code Pro / Cascadia Code).
- **Switch machines**: clone → `bash install.sh` → write fonts into `~/.vimrc.local` →
  `source ~/.bashrc`.
