#!/usr/bin/env bash
# install.sh — symlink dotfiles into ~/.config and set up dependencies
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$HOME/.config"

# ─── Colours ──────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
info()    { echo -e "${GREEN}[install]${NC} $*"; }
warn()    { echo -e "${YELLOW}[warn]${NC}    $*"; }
die()     { echo -e "${RED}[error]${NC}   $*" >&2; exit 1; }

# ─── Homebrew ────────────────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  die "Homebrew not found. Install it from https://brew.sh first."
fi

info "Installing dependencies via Homebrew..."
brew install koekeishiya/formulae/yabai \
             koekeishiya/formulae/skhd \
             FelixKratz/formulae/sketchybar \
             jq blueutil switchaudio-osx ifstat 2>&1 | tail -5

brew services start yabai
brew services start skhd
brew services start sketchybar

# ─── Symlinks ────────────────────────────────────────────────────────────────
link() {
  local src="$DOTFILES/$1"
  local dst="$CONFIG/$1"

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    info "Already linked: $dst"
    return
  fi

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    warn "Backing up existing $dst → ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi

  ln -s "$src" "$dst"
  info "Linked: $dst → $src"
}

mkdir -p "$CONFIG"
link sketchybar
link yabai
link skhd

# ─── Sketchybar C helper ──────────────────────────────────────────────────────
info "Building sketchybar C helper..."
(cd "$DOTFILES/sketchybar/helper" && make)

# ─── yabai scripting addition ────────────────────────────────────────────────
info "Configuring yabai scripting addition sudoers entry..."
YABAI_BIN="$(which yabai)"
YABAI_HASH="$(shasum -a 256 "$YABAI_BIN" | cut -d' ' -f1)"
SUDOERS_LINE="$(whoami) ALL=(root) NOPASSWD: sha256:${YABAI_HASH} ${YABAI_BIN} --load-sa"

if sudo grep -qF "$SUDOERS_LINE" /private/etc/sudoers.d/yabai 2>/dev/null; then
  info "sudoers entry already present."
else
  echo "$SUDOERS_LINE" | sudo tee /private/etc/sudoers.d/yabai >/dev/null
  info "sudoers entry written."
fi

# ─── Brew update launchd agent ────────────────────────────────────────────────
PLIST_SRC="$DOTFILES/launchagents/sketchybar.brew.update.plist"
PLIST_DST="$HOME/Library/LaunchAgents/sketchybar.brew.update.plist"
if [ -f "$PLIST_SRC" ]; then
  cp "$PLIST_SRC" "$PLIST_DST"
  launchctl load "$PLIST_DST" 2>/dev/null || true
  info "Brew update launchd agent loaded."
fi

# ─── Done ─────────────────────────────────────────────────────────────────────
echo ""
info "Done! Restart your terminal and run: sketchybar --reload"
warn "Remember to install Karabiner-Elements and import your hyper key profile."
