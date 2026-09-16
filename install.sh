#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
VIMRC_SOURCE="$SCRIPT_DIR/.vimrc"
HELP_SOURCE="$SCRIPT_DIR/HELP.md"
VIMRC_TARGET="${HOME}/.vimrc"
HELP_TARGET="${HOME}/.vim/HELP.md"
PLUG_TARGET="${HOME}/.vim/autoload/plug.vim"
BACKUP=1
INSTALL_COC=1

usage() {
  cat <<'EOF'
Usage: ./install.sh [options]

Install this Vim configuration, vim-plug, plugins, and the default coc.nvim extensions.

Options:
  --no-coc      Skip installing coc.nvim extensions
  --no-backup   Do not back up an existing ~/.vimrc or ~/.vim/HELP.md
  -h, --help    Show this help
EOF
}

for arg in "$@"; do
  case "$arg" in
    --no-coc) INSTALL_COC=0 ;;
    --no-backup) BACKUP=0 ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown option: %s\n\n' "$arg" >&2; usage >&2; exit 2 ;;
  esac
done

fail() {
  printf 'Error: %s\n' "$1" >&2
  exit 1
}

command -v vim >/dev/null 2>&1 || fail 'Vim is not installed or not on PATH.'
command -v curl >/dev/null 2>&1 || fail 'curl is required to install vim-plug.'
command -v git >/dev/null 2>&1 || fail 'git is required by vim-plug to download plugins.'
[[ -f "$VIMRC_SOURCE" ]] || fail "Cannot find $VIMRC_SOURCE"
[[ -f "$HELP_SOURCE" ]] || fail "Cannot find $HELP_SOURCE"

backup_file() {
  local file="$1"
  [[ "$BACKUP" -eq 1 && -e "$file" ]] || return 0
  local stamp backup
  stamp="$(date +%Y%m%d-%H%M%S)"
  backup="${file}.backup-${stamp}"
  cp -p "$file" "$backup"
  printf 'Backed up %s to %s\n' "$file" "$backup"
}

backup_file "$VIMRC_TARGET"
backup_file "$HELP_TARGET"

mkdir -p "$(dirname "$VIMRC_TARGET")" "$(dirname "$HELP_TARGET")" "$(dirname "$PLUG_TARGET")"

printf 'Installing vim-plug...\n'
curl -fLo "$PLUG_TARGET" --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

install -m 0644 "$VIMRC_SOURCE" "$VIMRC_TARGET"
install -m 0644 "$HELP_SOURCE" "$HELP_TARGET"
printf 'Installed .vimrc and HELP.md.\n'

printf 'Installing Vim plugins...\n'
vim -Nu "$VIMRC_TARGET" -n -es '+PlugInstall --sync' +qa

if [[ "$INSTALL_COC" -eq 1 ]]; then
  if command -v node >/dev/null 2>&1; then
    printf 'Installing coc.nvim extensions...\n'
    vim -Nu "$VIMRC_TARGET" -n -es \
      '+CocInstall -sync coc-json coc-clangd coc-go' +qa
  else
    printf 'Warning: node is not on PATH; skipped coc.nvim extensions.\n' >&2
  fi
else
  printf 'Skipped coc.nvim extensions (--no-coc).\n'
fi

cat <<EOF

Installation complete.

Configuration: $VIMRC_TARGET
Help file:     $HELP_TARGET
Plugin dir:    ${HOME}/.vim/plugged

Start Vim with:
  vim

Useful checks inside Vim:
  :PlugStatus
  :CocInfo
  :CocList extensions
EOF
