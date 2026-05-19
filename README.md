# 🌙 dotfiles — Arch Linux · Sway · Catppuccin Mocha

> Minimal, stable, focused. Built for a coding journey on an Intel i5-1035G1 laptop.

![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![Sway](https://img.shields.io/badge/Sway-WM-48B9C7?style=for-the-badge)
![Catppuccin](https://img.shields.io/badge/Catppuccin-Mocha-CBA6F7?style=for-the-badge)
![Wayland](https://img.shields.io/badge/Wayland-FFBC00?style=for-the-badge)

---

## ✨ Stack

| Component       | Choice                                     |
|-----------------|--------------------------------------------|
| OS              | Arch Linux (rolling)                       |
| WM              | Sway (Wayland)                             |
| Kernel          | linux-zen                                  |
| Filesystem      | Btrfs + LUKS2 encryption                   |
| Bootloader      | systemd-boot                               |
| Shell           | Zsh + Starship                             |
| Terminal        | foot (primary) · kitty (secondary)         |
| Editor          | Neovim (full LSP setup)                    |
| Bar             | Waybar                                     |
| Launcher        | Wofi                                       |
| Notifications   | Dunst                                      |
| File Manager    | Yazi + Thunar                              |
| Theme           | Catppuccin Mocha (everywhere)              |
| Font            | JetBrainsMono Nerd Font                    |
| AUR Helper      | paru                                       |

---

## 🚀 Quick Install

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh

./install.sh --all        # Full install (recommended on fresh Arch)
./install.sh              # Interactive menu
```

### Install options

```
./install.sh --all        Full install (packages + configs + services)
./install.sh --packages   Packages only
./install.sh --link       Symlink configs only (backs up existing)
./install.sh --services   Enable systemd services only
./install.sh --theme      Apply GTK/cursor theme only
```

---

## 🖥️ Prerequisites

- Fresh Arch Linux install
- Internet connection + `sudo`/`wheel` access
- `git` and `base-devel` available

---

## 💿 Fresh Arch Setup (archinstall)

```bash
iwctl
station wlan0 connect "Your-Network"
exit
archinstall
```

| Setting       | Value                          |
|---------------|--------------------------------|
| Filesystem    | **Btrfs**                      |
| Encryption    | **LUKS2**                      |
| Bootloader    | **systemd-boot**               |
| Kernel        | **linux-zen**                  |
| Audio         | Pipewire                       |
| Network       | NetworkManager                 |
| Profile       | Minimal                        |
| Extra pkgs    | `git base-devel`               |
| User          | Create user → `wheel` group    |

---

## ⌨️  Key Bindings

### Sway

| Key                      | Action                           |
|--------------------------|----------------------------------|
| `Super + Return`         | Terminal (foot)                  |
| `Super + Shift+Return`   | Terminal (kitty)                 |
| `Super + d`              | App launcher (wofi)              |
| `Super + b`              | Firefox                          |
| `Super + e`              | Yazi (TUI file manager)          |
| `Super + Shift+e`        | Thunar (GUI file manager)        |
| `Super + Escape`         | Lock screen                      |
| `Super + Shift+l`        | Lock + suspend                   |
| `Super + Shift+x`        | Logout menu (wlogout)            |
| `Super + f`              | Fullscreen                       |
| `Super + Shift+space`    | Toggle floating                  |
| `Super + space`          | Focus mode toggle                |
| `Super + [1–0]`          | Switch workspace                 |
| `Super + Shift+[1–0]`    | Move window to workspace         |
| `Super + Arrow`          | Focus left/down/up/right         |
| `Super + Shift+Arrow`    | Move window                      |
| `Super + r`              | Resize mode                      |
| `Super + \`              | Split horizontal                 |
| `Super + -`              | Split vertical                   |
| `Super + v`              | Clipboard history (cliphist)     |
| `Super + .`              | Emoji picker                     |
| `Super + grave`          | Scratchpad show                  |
| `Super + Shift+minus`    | Move to scratchpad               |
| `Super + Tab`            | Next workspace                   |
| `Super + Shift+Tab`      | Previous workspace               |
| `Print`                  | Screenshot full screen           |
| `Super + Print`          | Screenshot area → save           |
| `Super + Shift+Print`    | Screenshot area → clipboard      |
| `XF86AudioRaiseVolume`   | Volume +5%                       |
| `XF86AudioLowerVolume`   | Volume -5%                       |
| `XF86AudioMute`          | Toggle mute                      |
| `XF86MonBrightnessUp`    | Brightness up                    |
| `XF86MonBrightnessDown`  | Brightness down                  |
| `XF86AudioPlay`          | Play/Pause                       |
| `XF86AudioNext`          | Next track                       |
| `XF86AudioPrev`          | Previous track                   |

### Neovim (leader = `Space`)

| Key            | Action                   |
|----------------|--------------------------|
| `<leader>e`    | File explorer (NvimTree) |
| `<leader>ff`   | Find files (Telescope)   |
| `<leader>fg`   | Live grep                |
| `<leader>fb`   | Buffers                  |
| `<leader>fr`   | Recent files             |
| `<leader>rn`   | Rename symbol            |
| `<leader>ca`   | Code actions             |
| `<leader>f`    | Format file              |
| `<leader>t`    | Float terminal           |
| `<leader>xx`   | Trouble (diagnostics)    |
| `gd`           | Go to definition         |
| `gr`           | References               |
| `K`            | Hover docs               |
| `[d` / `]d`    | Prev/next diagnostic     |
| `<C-s>`        | Save                     |

### Tmux (prefix = `Ctrl+a`)

| Key              | Action                  |
|------------------|-------------------------|
| `prefix + \|`    | Split horizontal        |
| `prefix + -`     | Split vertical          |
| `prefix + h/j/k/l` | Navigate panes        |
| `prefix + H/J/K/L` | Resize panes          |
| `prefix + r`     | Reload config           |
| `Alt + H/L`      | Previous/next window    |
| `prefix + Tab`   | Last window             |

---

## 📁 Repository Structure

```
dotfiles/
├── install.sh                  # Installer (--all, --link, --packages, ...)
├── README.md
├── .gitignore
│
├── config/                     # Symlinked to ~/.config/
│   ├── sway/
│   │   ├── config              # Main Sway config
│   │   └── swaylock.conf       # Lock screen
│   ├── waybar/
│   │   ├── config.jsonc        # Bar modules + layout
│   │   └── style.css           # Catppuccin Mocha theme
│   ├── foot/
│   │   └── foot.ini            # Primary terminal
│   ├── kitty/
│   │   └── kitty.conf          # Secondary terminal
│   ├── dunst/
│   │   └── dunstrc             # Notification daemon
│   ├── wofi/
│   │   ├── config              # Launcher config
│   │   └── style.css           # Theme
│   ├── nvim/
│   │   └── init.lua            # Neovim — packer, LSP, cmp, telescope
│   ├── starship.toml           # Prompt
│   ├── btop/
│   │   └── btop.conf           # System monitor
│   ├── yazi/
│   │   ├── yazi.toml           # File manager
│   │   └── theme.toml          # Catppuccin theme
│   ├── zathura/
│   │   └── zathurarc           # PDF viewer
│   └── fastfetch/
│       └── config.jsonc        # System info on shell open
│
├── home/                       # Symlinked to ~/
│   ├── .zshrc                  # Interactive shell (aliases, fzf, functions)
│   ├── .zshenv                 # Env vars — loaded for ALL shells
│   ├── .gitconfig              # Git — delta pager, aliases
│   └── .tmux.conf              # Tmux — Catppuccin, vi copy mode
│
└── etc/
    └── auto-cpufreq.conf       # Copy to /etc/ for CPU power management
```

---

## 🎨 Customisation

**Wallpaper** — place any image at `~/.config/sway/wallpaper.jpg`
(or change the path/fallback color in `config/sway/config`)

**Display resolution/scale:**
```
# config/sway/config
output eDP-1 resolution 1920x1080 scale 1
# Find your display name: swaymsg -t get_outputs
```

**Keyboard layout:**
```
# config/sway/config
input type:keyboard {
    xkb_layout gb
}
```

**Timezone (Waybar clock):**
```jsonc
// config/waybar/config.jsonc
"clock": { "timezone": "America/New_York" }
```

---

## 🔄 Updating

```bash
cd ~/.dotfiles
git pull
./install.sh --link     # Re-symlink configs
```

---

## 🩹 Troubleshooting

**Sway won't start**
```bash
sway --validate
journalctl --user -xe
```

**Waybar missing**
```bash
waybar --log-level debug 2>&1 | head -50
```

**No audio**
```bash
systemctl --user status pipewire pipewire-pulse wireplumber
systemctl --user restart wireplumber
```

**Bluetooth**
```bash
sudo systemctl enable --now bluetooth
bluetoothctl power on
```

**auto-cpufreq not applying**
```bash
sudo cp ~/.dotfiles/etc/auto-cpufreq.conf /etc/
sudo auto-cpufreq --install
```

---

## 📋 Post-Install Checklist

- [ ] Set git identity: `git config --global user.name/email`
- [ ] Launch Neovim → `:PackerSync`
- [ ] Place wallpaper at `~/.config/sway/wallpaper.jpg`
- [ ] Copy CPU freq config: `sudo cp etc/auto-cpufreq.conf /etc/`
- [ ] Log out and back in (group changes: docker, libvirt, video)
- [ ] Test audio: `wpctl status`
- [ ] Verify UFW: `sudo ufw status`

---

## 🙏 Credits

- [Catppuccin](https://catppuccin.com) — the colour scheme
- [swaywm](https://swaywm.org) — tiling Wayland compositor
- [Waybar](https://github.com/Alexays/Waybar)
- [Starship](https://starship.rs)
- The Arch Linux community

---

*"Simplicity is the ultimate sophistication."*
