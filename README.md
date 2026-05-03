# dotfiles

My macOS window management and status bar setup. Built around a keyboard-first workflow on a 3-monitor desk.

## Stack

| Tool | Role |
|---|---|
| [yabai](https://github.com/koekeishiya/yabai) | Tiling window manager (BSP + stack) |
| [skhd](https://github.com/koekeishiya/skhd) | Hotkey daemon |
| [sketchybar](https://github.com/FelixKratz/SketchyBar) | Custom status bar |
| [Karabiner-Elements](https://karabiner-elements.pqrs.org/) | Hyper key remapping |

**Theme:** [Catppuccin Macchiato](https://github.com/catppuccin/catppuccin)  
**Font:** SF Pro (system)

---

## Requirements

- macOS 13+
- [Homebrew](https://brew.sh)
- [Karabiner-Elements](https://karabiner-elements.pqrs.org/) — for the Hyper key (`ctrl+alt+cmd` mapped to a single key)
- SIP partially disabled for yabai scripting addition (see [yabai docs](https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection))

---

## Installation

```bash
git clone https://github.com/istvan-takacs/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` will:
1. Install all Homebrew dependencies
2. Symlink `sketchybar/`, `yabai/`, `skhd/` into `~/.config/`
3. Compile the sketchybar C CPU helper
4. Write the yabai sudoers entry for the scripting addition
5. Load the hourly brew update launchd agent

After install, reload configs:
```bash
yabai --restart-service
skhd --restart-service
sketchybar --reload
```

---

## Sketchybar

### Bar layout

```
[ apple ][ I » JS  II » NeetCode  … ][ yabai ]          [ cal ][ brew ][ kb ][ wifi  bat  vol ][ cpu  disk  mem ][ front_app ]
```

### Items (left → right)

| Item | Description |
|---|---|
| Apple logo | Popup menu: Settings, Activity Monitor, Sleep, Reboot, Shutdown, Lock, Logout |
| Spaces | One item per space. Click = focus, right-click = destroy, shift+click = rename |
| Yabai | Window state indicator: grid (tiled), float, fullscreen zoom, parent zoom, stack |
| Calendar | Date + time. Click toggles **zen mode** (hides non-essential items) |
| Brew | Outdated package count. Hover = popup list of packages with → target version |
| Keyboard | Current input layout (3-char abbreviated) |
| Wifi / Battery / Volume | Hardware status cluster with animated volume slider |
| CPU / Disk / Memory | System stats cluster. CPU uses a low-overhead Mach helper (no shell polling) |
| Front app | Active application icon + name |

### Zen mode

Clicking the calendar toggles zen mode — hides everything except the current time, spaces, and yabai indicator. State is persisted across sketchybar restarts in `~/.config/sketchybar/.zen_state`.

### Brew updates

Outdated package count refreshes every hour via a launchd agent (`launchagents/sketchybar.brew.update.plist`). Click the brew icon to see a popup list.

---

## Keybindings

> **Hyper** = `ctrl + alt + cmd` (a single key in Karabiner)

### Window focus

| Key | Action |
|---|---|
| `shift+ctrl ↑↓←→` | Focus window north / south / west / east |

### Layout

| Key | Action |
|---|---|
| `shift+ctrl - r` | Rotate layout 270° |
| `shift+ctrl - y` | Mirror y-axis |
| `shift+ctrl - x` | Mirror x-axis |
| `shift+ctrl - b` | Balance split ratios |
| `shift+ctrl - t` | Toggle space layout BSP ↔ stack |
| `shift+ctrl - f` | Float / unfloat window (centred grid) |

### Zoom

| Key | Action |
|---|---|
| `shift+ctrl - space` | Fullscreen zoom — window fills screen, layout preserved underneath |
| `shift+ctrl - z` | Parent zoom — window fills its BSP container (e.g. fills right half without touching left) |

### Swap

| Key | Action |
|---|---|
| `shift+ctrl - h/j/k/l` | Swap window west / south / north / east |

### Stack management

| Key | Action |
|---|---|
| `hyper ←→` | Navigate stack — wraps around at both ends |
| `hyper - j/k/h/l` | Push window into stack with southern / northern / western / eastern neighbour |
| `hyper+shift - j/k/h/l` | Break window out of stack into BSP in that direction (rest of stack intact) |

### Ratio

| Key | Action |
|---|---|
| `hyper ↑↓` | Increase / decrease split ratio |

### Spaces

| Key | Action |
|---|---|
| `ctrl - 1…9` | Focus space 1–9 (creates if missing) |
| `hyper - 1…9` | Move focused window to space 1–9 and follow |
| `hyper - p` | Move window to previous space and follow |
| `hyper - n` | Move window to next space and follow |
| `hyper - 0x2C` (`/`) | Destroy all empty spaces |
| `hyper+shift - 0` | Re-tile all windows on current space |
| `hyper+shift - 1…9` | Rename space 1–9 (dialog prompt) |

### Misc

| Key | Action |
|---|---|
| `ctrl+shift - backspace` | Close focused window |

---

## yabai

- **Layout:** BSP (`bsp`) with `window_placement=second_child`
- **Gaps:** 10px all sides, 10px between windows
- **Opacity:** active = 1.0, inactive = 0.95, instant transition
- **Borders:** Catppuccin blue on active window, dimmed BG2 on inactive
- **Mouse:** `alt` modifier for drag-to-move and drag-to-resize; `focus_follows_mouse=autofocus`
- **Floating rules:** Calculator, Karabiner-Elements, Finder, System Settings
- **Signals:** `space_changed`, `window_focused`, `display_changed` → update sketchybar

### Scripts

| Script | Purpose |
|---|---|
| `scripts/switch_space.sh <N> <move>` | Focus space N, creating it if needed; optionally move the focused window |
| `scripts/destroy_empty_spaces.sh` | Destroy all empty spaces except space 1 |

---

## Directory structure

```
dotfiles/
├── install.sh                      # One-shot setup script
├── launchagents/
│   └── sketchybar.brew.update.plist  # Hourly brew outdated check
├── sketchybar/
│   ├── sketchybarrc                # Entry point
│   ├── colors.sh                   # Catppuccin Macchiato palette
│   ├── icons.sh                    # SF Symbols + Nerd Font codepoints
│   ├── update_brew.sh              # Runs brew outdated, sets label + popup directly (called by launchd)
│   ├── helper/                     # C helper for low-overhead CPU polling via Mach
│   │   ├── helper.c
│   │   ├── cpu.h
│   │   ├── sketchybar.h
│   │   └── makefile
│   ├── items/                      # Item declarations (add + set)
│   └── plugins/                    # Event handler scripts
├── yabai/
│   ├── yabairc                     # Main config
│   ├── scripts/
│   │   ├── switch_space.sh
│   │   └── destroy_empty_spaces.sh
│   └── custom/                     # Unused / experimental scripts
└── skhd/
    └── skhdrc                      # All keybindings
```

---

## Tips

**Adding a new space name:** `shift+click` a space in sketchybar or press `hyper+shift+<N>`.

**Enabling optional items** (spotify, github, bluetooth, network): uncomment the relevant `source` lines at the bottom of `sketchybar/sketchybarrc`.

**Rebuilding the CPU helper** (required after yabai/sketchybar updates):
```bash
cd ~/.config/sketchybar/helper && make
```

**Updating the yabai sudoers hash** (required after every yabai update):
```bash
YABAI=$(which yabai)
HASH=$(shasum -a 256 "$YABAI" | cut -d' ' -f1)
echo "$(whoami) ALL=(root) NOPASSWD: sha256:${HASH} ${YABAI} --load-sa" \
  | sudo tee /private/etc/sudoers.d/yabai
```
