#!/usr/bin/env bash
# Installs the latest Neovim AppImage and this config on any Linux distro,
# then adds an `nvim` alias to bash, zsh and fish.
set -euo pipefail

REPO="https://github.com/404alya/My-neovim-config"
APPIMAGE_DIR="$HOME/AppImages"
NVIM_DIR="$APPIMAGE_DIR/nvim"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

case "$(uname -m)" in
  x86_64) ARCH="x86_64" ;;
  aarch64 | arm64) ARCH="arm64" ;;
  *) echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

for cmd in curl git; do
  command -v "$cmd" >/dev/null || { echo "Missing dependency: $cmd" >&2; exit 1; }
done

# 1. Neovim AppImage
mkdir -p "$APPIMAGE_DIR"
echo "==> Downloading Neovim AppImage ($ARCH)"
curl -fL --progress-bar -o "$APPIMAGE_DIR/nvim.appimage" \
  "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-$ARCH.appimage"
chmod +x "$APPIMAGE_DIR/nvim.appimage"

# Without FUSE the AppImage can't mount itself, so extract it instead.
if "$APPIMAGE_DIR/nvim.appimage" --version >/dev/null 2>&1; then
  NVIM_BIN="$APPIMAGE_DIR/nvim.appimage"
else
  echo "==> FUSE not available, extracting AppImage"
  rm -rf "$NVIM_DIR"
  (cd "$APPIMAGE_DIR" && ./nvim.appimage --appimage-extract >/dev/null && mv squashfs-root "$NVIM_DIR")
  NVIM_BIN="$NVIM_DIR/AppRun"
fi

# 2. Config (existing one is backed up, not deleted)
if [ -e "$CONFIG_DIR" ]; then
  BACKUP="$CONFIG_DIR.bak.$(date +%s)"
  echo "==> Backing up existing config to $BACKUP"
  mv "$CONFIG_DIR" "$BACKUP"
fi
echo "==> Cloning config"
git clone --depth=1 "$REPO" "$CONFIG_DIR"
rm -rf "$CONFIG_DIR/.git"

# 3. Aliases
add_line() { # file line
  [ -f "$1" ] && grep -qxF "$2" "$1" && return
  mkdir -p "$(dirname "$1")"
  echo "$2" >>"$1"
  echo "==> Added alias to $1"
}
add_line "$HOME/.bashrc" "alias nvim='$NVIM_BIN'"
command -v zsh >/dev/null && add_line "$HOME/.zshrc" "alias nvim='$NVIM_BIN'"
command -v fish >/dev/null && add_line "${XDG_CONFIG_HOME:-$HOME/.config}/fish/config.fish" "alias nvim '$NVIM_BIN'"

echo "==> Done. Restart your shell and run: nvim"
