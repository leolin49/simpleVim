# simpleVim

一个面向日常开发的 Vim 配置，目标是：**一键安装、开箱即用，同时方便定制**。

安装后可以直接获得文件树、代码搜索、主题、状态栏、补全、跳转、诊断、格式化和终端等常用能力。配置基于 Vim，插件通过 vim-plug 管理；不需要的功能可以按需关闭或修改。

## 功能

- Vim Airline 状态栏和 buffer 标签栏
- PaperColor、Gruvbox、Everforest、Dracula、OneDark 等主题
- NERDTree 文件树
- CtrlSF 全文搜索
- Tagbar 代码结构查看
- coc.nvim 代码补全和 LSP 功能
- Go、C/C++、JSON 语言支持
- Python 运行和终端快捷键
- 自定义帮助文档
- Vim/系统剪贴板支持

## 一键安装（推荐）

先获取项目：

```bash
git clone https://github.com/leolin49/simpleVim.git ~/simpleVim
cd ~/simpleVim
```

运行安装脚本：

```bash
./install.sh
```

脚本会：

1. 备份已有的 `~/.vimrc` 和 `~/.vim/HELP.md`
2. 安装 vim-plug
3. 安装本项目声明的 Vim 插件
4. 部署 `.vimrc` 和 `HELP.md`
5. 安装 `coc-json`、`coc-clangd`、`coc-go`

脚本不会自动使用系统包管理器安装 Vim、Node.js、clangd 等软件；这样可以避免在不同 Linux 发行版或 macOS 上执行不适用的系统命令。请先准备好下方的系统依赖。

### 安装脚本选项

```bash
./install.sh --help
./install.sh --no-coc       # 不安装 coc.nvim 扩展
./install.sh --no-backup    # 不备份已有配置
```

安装完成后启动：

```bash
vim
```

检查安装状态：

```vim
:PlugStatus
:CocInfo
:CocList extensions
```

## 手动安装

### 1. 安装系统依赖

至少需要：

- Vim
- Git
- curl

使用 coc.nvim 时还需要：

- Vim `>= 9.0.0438`，或 Neovim `>= 0.8.0`
- Node.js `>= 22.15.0`

检查版本：

```bash
vim --version | head -n 2
node --version
```

Ubuntu/Debian 示例：

```bash
sudo apt update
sudo apt install vim git curl nodejs npm
```

可选依赖：

| 功能 | 依赖 |
|---|---|
| `<F2>` 终端 | `zsh`，也可以把配置改为 `bash` |
| `<F5>` 运行 Python | `pypy3` 和当前目录中的 `input` 文件 |
| `<F9>` Tagbar | `universal-ctags` |
| `coc-clangd` | `clangd` |
| `<Leader>py` Python 终端 | `python3` |
| 系统剪贴板 | Vim `+clipboard` 和可用的系统剪贴板服务 |

Ubuntu/Debian 可选安装：

```bash
sudo apt install zsh python3 pypy3 universal-ctags clangd
```

请确认发行版提供的 Node.js 版本满足 `>= 22.15.0`；如果版本过低，请使用 Node.js 官方渠道升级。

### 2. 安装 vim-plug

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \\
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

官方文档：<https://github.com/junegunn/vim-plug>

### 3. 部署配置

```bash
cp ~/.vimrc ~/.vimrc.backup 2>/dev/null || true
cp .vimrc ~/.vimrc
mkdir -p ~/.vim
cp HELP.md ~/.vim/HELP.md
```

### 4. 安装插件和 coc 扩展

```bash
vim +PlugInstall +qall
```

进入 Vim 后执行：

```vim
:CocInstall coc-json coc-clangd coc-go
```

coc.nvim 官方文档：<https://cocnvim.com/docs/install-coc.nvim>

## 定制配置

安装脚本会把配置复制到：

```text
~/.vimrc
```

直接编辑它即可定制。项目中的 `.vimrc` 是源文件，之后重新运行 `install.sh` 会覆盖已部署的配置，因此建议：

- 个人修改长期保留在 `~/.vimrc`
- 希望分享给其他人的修改同步回项目中的 `.vimrc`
- 修改快捷键时使用 `nnoremap`、`inoremap` 等 Vim 映射命令
- 不需要的插件可以在 `call plug#begin()` 和 `call plug#end()` 之间注释掉
- 修改插件列表后执行 `:PlugInstall` 或 `:PlugUpdate`

自定义 coc.nvim 设置：

```vim
:CocConfig
```

它会打开或创建：

```text
~/.vim/coc-settings.json
```

自定义帮助文档：

```text
~/.vim/HELP.md
```

项目中的 `HELP.md` 是默认帮助文档副本；修改后可以同步回项目，或者只保留本地版本。

## 外部文件和可选功能

### 帮助文件

按 `<F1>` 时，配置会读取：

```text
~/.vim/HELP.md
```

安装脚本会自动部署该文件。如果手动安装，请执行：

```bash
mkdir -p ~/.vim
cp HELP.md ~/.vim/HELP.md
```

如果希望 `<F1>` 打开 Vim 默认帮助，把 `.vimrc` 中的映射改为：

```vim
nnoremap <F1> :help<CR>
```

### 文件模板

新建 `.cc` 或 `.py` 文件时，配置会尝试读取：

```text
~/algo_competition/Template/template_algo.cc
~/algo_competition/Template/template_algo_simple.py
```

这属于可选功能，不使用时可以注释 `.vimrc` 中对应的两行。需要时可以创建模板目录和文件：

```bash
mkdir -p ~/algo_competition/Template
touch ~/algo_competition/Template/template_algo.cc
touch ~/algo_competition/Template/template_algo_simple.py
```

### Python 输入文件

Python 文件按 `<F5>` 后执行的命令相当于：

```bash
pypy3 current_file.py < input
```

需要在当前工作目录准备名为 `input` 的输入文件。

## 快捷键

`<Leader>` 未重新定义，默认是反斜杠 `\`。例如 `<Leader>rn` 实际按键为 `\rn`。

| 快捷键 | 功能 |
|---|---|
| `<F1>` | 打开 `~/.vim/HELP.md` |
| `<F2>` | 打开 zsh 终端弹窗 |
| `<F3>` | 用寄存器内容覆盖整个文件 |
| `<F4>` | 复制整个文件到系统剪贴板 |
| `<F5>` | 保存并使用 `pypy3` 执行当前 Python 文件 |
| `<F9>` | 打开/关闭 Tagbar |
| `,,` | 清除搜索高亮 |
| `;` | 打开/关闭 NERDTree |
| `<C-H>` / `<C-L>` | 切换上一个/下一个 buffer |
| `<Leader>py` | 打开 Python 终端 |
| `gd` | 跳转到定义 |
| `gy` | 跳转到类型定义 |
| `gi` | 跳转到实现 |
| `gr` | 查找引用 |
| `K` | 查看当前符号文档 |
| `[g` / `]g` | 上一个/下一个诊断信息 |
| `<Leader>rn` | 重命名符号 |
| `<Leader>f` | 格式化代码 |
| `<Leader>a` | 执行代码操作 |
| `<Leader>qf` | 修复当前行 |
| `<Leader>re` | 执行重构 |
| `<Leader>cl` | 执行 Code Lens |
| `<C-J>` / `<C-K>` | 在补全菜单中移动 |
| `<CR>` | 确认补全项 |
| `<C-Space>` | 手动触发补全 |
| `f` | 打开/关闭 CtrlSF |
| `F` | 搜索光标所在单词 |
| `:CtrlSF xxx` | 在当前目录搜索 `xxx` |
| `<C-w> h/l` | 切换到左/右窗口 |
| `<C-w> w` | 循环切换窗口 |

## 自定义命令

| 命令 | 功能 |
|---|---|
| `:Format` | 格式化当前 buffer |
| `:Fold` | 执行代码折叠 |
| `:OR` | 整理 import |
| `:CocInfo` | 查看 coc.nvim 状态 |
| `:CocDiagnostics` | 查看当前文件诊断信息 |
| `:CocList extensions` | 查看/管理 coc 扩展 |
| `:PlugStatus` | 查看插件状态 |

## 已知注意事项

- `;` 覆盖 Vim 原本的重复 `f`/`t` 查找功能。
- `f` 和 `F` 覆盖 Vim 原本的字符查找功能，改为 CtrlSF 搜索。
- `<F1>` 读取 `~/.vim/HELP.md`，不是 Vim 默认帮助。
- `<C-F>` 同时被 NERDTree 和 coc.nvim 使用；现代 Vim 中通常会用于滚动 coc 浮动窗口。
- `<F3>` 会覆盖整个文件内容，请谨慎使用。
- `<C-H>` 和 `<C-L>` 使用 `:bp!`/`:bn!` 切换 buffer，可能强制放弃未保存修改。
- `colorscheme PaperColor` 依赖插件安装成功。
- 如果 `F2` 弹窗打开后立即关闭，请安装 `zsh`，或将映射改为 `bash`。
- 如果 `F1` 提示找不到文件，请确认已执行 `cp HELP.md ~/.vim/HELP.md`。
- 主题部分当前使用的是 `PaperColor`；`.vimrc` 中的 `termguicolor` 看起来是笔误，如需真彩色可改为 `termguicolors`。

## 许可证

`HELP.md` 中标注本配置使用 GPL v3.0。若以 GPL v3.0 正式发布，建议同时在仓库根目录提交完整的 `LICENSE` 文件。
