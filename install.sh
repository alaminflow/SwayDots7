#!/usr/bin/env bash
# =============================================================================
#  Dotfiles Installer — Arch Linux + Sway + Catppuccin Mocha
#  GitHub: https://github.com/YOUR_USERNAME/dotfiles
# =============================================================================
set -euo pipefail

# ── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; PURPLE='\033[0;35m'; CYAN='\033[0;36m'
BOLD='\033[1m'; RESET='\033[0m'

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
LOG_FILE="$HOME/.dotfiles_install.log"

# ── Helpers ───────────────────────────────────────────────────────────────────
log()  { echo -e "${CYAN}[INFO]${RESET}  $*" | tee -a "$LOG_FILE"; }
ok()   { echo -e "${GREEN}[OK]${RESET}    $*" | tee -a "$LOG_FILE"; }
warn() { echo -e "${YELLOW}[WARN]${RESET}  $*" | tee -a "$LOG_FILE"; }
err()  { echo -e "${RED}[ERROR]${RESET} $*" | tee -a "$LOG_FILE"; }
step() { echo -e "\n${BOLD}${PURPLE}▶ $*${RESET}" | tee -a "$LOG_FILE"; }

confirm() {
  read -rp "$(echo -e "${YELLOW}$* [y/N]${RESET} ")" ans
  [[ "${ans,,}" == "y" ]]
}

banner() {
  echo -e "${BOLD}${BLUE}"
  cat <<'EOF'
  ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
  ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
  ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
  ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
  ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
  ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝
EOF
  echo -e "${RESET}"
  echo -e "  ${BOLD}Arch Linux · Sway · Catppuccin Mocha${RESET}"
  echo -e "  ${CYAN}Intel i5-1035G1 · Minimal · Stable · Focused${RESET}\n"
}

# ── Pre-flight checks ─────────────────────────────────────────────────────────
preflight() {
  step "Pre-flight checks"

  # Must be Arch Linux
  if [[ ! -f /etc/arch-release ]]; then
    err "This script is for Arch Linux only."; exit 1
  fi

  # Must NOT be root
  if [[ "$EUID" -eq 0 ]]; then
    err "Do not run as root. Run as your regular user."; exit 1
  fi

  # sudo works
  if ! sudo -v &>/dev/null; then
    err "sudo not available. Add yourself to the wheel group."; exit 1
  fi

  ok "Arch Linux detected, running as $(whoami)"
}

# ── Install paru (AUR helper) ─────────────────────────────────────────────────
install_paru() {
  if command -v paru &>/dev/null; then
    ok "paru already installed"; return
  fi
  step "Installing paru (AUR helper)"
  sudo pacman -S --needed --noconfirm git base-devel
  local tmp; tmp=$(mktemp -d)
  git clone --depth=1 https://aur.archlinux.org/paru.git "$tmp/paru"
  (cd "$tmp/paru" && makepkg -si --noconfirm)
  rm -rf "$tmp"
  ok "paru installed"
}

# ── Package installation ───────────────────────────────────────────────────────
install_packages() {
  step "Installing packages"

  # ── Official repo packages ──────────────────────────────────────────────────
  PACMAN_PKGS=(
    # Core system
    base-devel linux-zen linux-zen-headers linux-firmware intel-ucode btrfs-progs
    networkmanager bluez bluez-utils blueman
    pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber
    polkit polkit-kde-agent

    # Sway desktop
    sway swaybg swayidle swaylock
    waybar dunst wofi
    foot kitty
    cliphist wl-clipboard
    grim slurp brightnessctl playerctl pavucontrol
    xdg-desktop-portal-wlr xdg-user-dirs

    # Development
    git nodejs npm python python-pipx python-virtualenv
    docker docker-compose

    # CLI tools
    bat eza fd ripgrep fzf btop fastfetch starship
    zsh zsh-completions zsh-autosuggestions zsh-syntax-highlighting
    timeshift ufw cronie alsa-utils
    neovim vim tmux

    # File managers
    yazi thunar
    gvfs gvfs-mtp ffmpegthumbnailer unar jq poppler fd zoxide

    # Apps
    firefox obsidian libreoffice-fresh okular zathura zathura-pdf-mupdf
    mpv imv

    # Virtualisation
    qemu-full virt-manager virt-viewer ovmf libvirt

    # Theming / fonts
    ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji
    gtk3 gtk4 qt5ct qt6ct

    # System tools
    auto-cpufreq power-profiles-daemon
    htop lsof strace man-db man-pages
    wget curl unzip p7zip rsync
    pipewire-v4l2

    # Wayland specific
    qt5-wayland qt6-wayland
    xorg-xwayland
  )

  log "Updating system..."
  sudo pacman -Syu --noconfirm

  log "Installing pacman packages..."
  sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}" 2>&1 | tee -a "$LOG_FILE" || true

  # ── AUR packages ────────────────────────────────────────────────────────────
  AUR_PKGS=(
    brave-bin
    vscodium-bin
    bitwarden
    telegram-desktop
    catppuccin-gtk-theme-mocha
    catppuccin-cursors-mocha
    wlogout
    grimblast-git
    swappy
    nwg-look
  )

  log "Installing AUR packages..."
  paru -S --needed --noconfirm "${AUR_PKGS[@]}" 2>&1 | tee -a "$LOG_FILE" || true

  ok "All packages installed"
}

# ── Backup existing configs ────────────────────────────────────────────────────
backup_configs() {
  step "Backing up existing configs to $BACKUP_DIR"
  mkdir -p "$BACKUP_DIR"

  local targets=(
    "$HOME/.config/sway"
    "$HOME/.config/waybar"
    "$HOME/.config/foot"
    "$HOME/.config/kitty"
    "$HOME/.config/dunst"
    "$HOME/.config/wofi"
    "$HOME/.config/nvim"
    "$HOME/.config/starship.toml"
    "$HOME/.config/btop"
    "$HOME/.config/yazi"
    "$HOME/.config/zathura"
    "$HOME/.zshrc"
    "$HOME/.zshenv"
    "$HOME/.gitconfig"
  )

  for t in "${targets[@]}"; do
    if [[ -e "$t" ]]; then
      cp -r "$t" "$BACKUP_DIR/" && log "Backed up: $t"
    fi
  done
  ok "Backup complete: $BACKUP_DIR"
}

# ── Stow / symlink configs ─────────────────────────────────────────────────────
link_configs() {
  step "Symlinking dotfiles"
  mkdir -p "$HOME/.config"

  # Config dirs
  local config_dirs=(sway waybar foot kitty dunst wofi nvim btop yazi zathura)
  for d in "${config_dirs[@]}"; do
    local src="$DOTFILES_DIR/config/$d"
    local dst="$HOME/.config/$d"
    if [[ -d "$src" ]]; then
      rm -rf "$dst"
      ln -sf "$src" "$dst"
      ok "Linked: ~/.config/$d"
    fi
  done

  # Single config files
  local cfg_files=(starship.toml)
  for f in "${cfg_files[@]}"; do
    local src="$DOTFILES_DIR/config/$f"
    local dst="$HOME/.config/$f"
    if [[ -f "$src" ]]; then
      rm -f "$dst"
      ln -sf "$src" "$dst"
      ok "Linked: ~/.config/$f"
    fi
  done

  # Home dotfiles
  local home_files=(.zshrc .zshenv .gitconfig .tmux.conf)
  for f in "${home_files[@]}"; do
    local src="$DOTFILES_DIR/home/$f"
    local dst="$HOME/$f"
    if [[ -f "$src" ]]; then
      rm -f "$dst"
      ln -sf "$src" "$dst"
      ok "Linked: ~/$f"
    fi
  done
}

# ── Shell setup ───────────────────────────────────────────────────────────────
setup_shell() {
  step "Setting up Zsh as default shell"
  if [[ "$SHELL" != "$(which zsh)" ]]; then
    chsh -s "$(which zsh)"
    ok "Default shell changed to zsh"
  else
    ok "zsh already default shell"
  fi

  # Create XDG dirs
  xdg-user-dirs-update
}

# ── Services ──────────────────────────────────────────────────────────────────
enable_services() {
  step "Enabling systemd services"

  local system_services=(NetworkManager docker cronie ufw libvirtd bluetooth)
  for svc in "${system_services[@]}"; do
    if systemctl list-unit-files --type=service | grep -q "^${svc}.service"; then
      sudo systemctl enable --now "$svc" && ok "System service: $svc"
    else
      warn "Service not found: $svc"
    fi
  done

  local user_services=(pipewire pipewire-pulse wireplumber dunst)
  for svc in "${user_services[@]}"; do
    if systemctl --user list-unit-files --type=service | grep -q "^${svc}.service"; then
      systemctl --user enable --now "$svc" && ok "User service: $svc"
    else
      warn "User service not found: $svc"
    fi
  done

  # UFW basic rules
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw allow ssh
  sudo ufw --force enable
  ok "UFW firewall configured"
}

# ── User groups ───────────────────────────────────────────────────────────────
setup_groups() {
  step "Adding user to required groups"
  local groups=(libvirt kvm video audio storage docker wheel input)
  for g in "${groups[@]}"; do
    if getent group "$g" &>/dev/null; then
      sudo usermod -aG "$g" "$USER" && ok "Group: $g"
    fi
  done
}

# ── auto-cpufreq ──────────────────────────────────────────────────────────────
setup_cpufreq() {
  step "Setting up auto-cpufreq"
  if command -v auto-cpufreq &>/dev/null; then
    if ! systemctl is-enabled auto-cpufreq &>/dev/null; then
      sudo auto-cpufreq --install
      # Mask power-profiles-daemon — conflicts with auto-cpufreq
      sudo systemctl mask power-profiles-daemon 2>/dev/null || true
      ok "auto-cpufreq installed and enabled (power-profiles-daemon masked)"
    else
      ok "auto-cpufreq already enabled"
    fi
  else
    warn "auto-cpufreq not found — install via AUR: paru -S auto-cpufreq"
  fi
}

# ── Neovim setup ──────────────────────────────────────────────────────────────
setup_neovim() {
  step "Setting up Neovim"
  # Neovim's init.lua self-bootstraps packer.nvim on first launch.
  # Just ensure the cache dir exists so zsh compinit doesn't warn.
  mkdir -p "$HOME/.cache/zsh"
  ok "Neovim will self-bootstrap packer on first launch — run :PackerSync"
}

# ── GTK / cursor theme ────────────────────────────────────────────────────────
setup_theme() {
  step "Applying Catppuccin Mocha theme"

  mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"

  cat > "$HOME/.config/gtk-3.0/settings.ini" <<EOF
[Settings]
gtk-theme-name=catppuccin-mocha-mauve-standard+default
gtk-icon-theme-name=Papirus-Dark
gtk-cursor-theme-name=catppuccin-mocha-dark-cursors
gtk-cursor-theme-size=24
gtk-font-name=JetBrainsMono Nerd Font 11
gtk-application-prefer-dark-theme=1
EOF

  cat > "$HOME/.config/gtk-4.0/settings.ini" <<EOF
[Settings]
gtk-theme-name=catppuccin-mocha-mauve-standard+default
gtk-icon-theme-name=Papirus-Dark
gtk-cursor-theme-name=catppuccin-mocha-dark-cursors
gtk-cursor-theme-size=24
gtk-font-name=JetBrainsMono Nerd Font 11
gtk-application-prefer-dark-theme=1
EOF

  # Cursor for Wayland/X11
  mkdir -p "$HOME/.icons/default"
  cat > "$HOME/.icons/default/index.theme" <<EOF
[Icon Theme]
Name=Default
Comment=Default Cursor Theme
Inherits=catppuccin-mocha-dark-cursors
EOF

  ok "GTK theme applied"
}

# ── Docker post-install ───────────────────────────────────────────────────────
setup_docker() {
  step "Configuring Docker"
  if ! getent group docker &>/dev/null; then
    sudo groupadd docker
  fi
  sudo usermod -aG docker "$USER"
  ok "Docker configured (re-login required)"
}

# ── Git global config ─────────────────────────────────────────────────────────
setup_git() {
  step "Git configuration"
  if [[ ! -f "$HOME/.gitconfig" ]] || ! grep -q "dotfiles" "$HOME/.gitconfig" 2>/dev/null; then
    log "$HOME/.gitconfig managed by dotfiles (linked from home/.gitconfig)"
  fi
  ok "Git config ready"
}

# ── Final message ──────────────────────────────────────────────────────────────
finish() {
  echo -e "\n${BOLD}${GREEN}╔══════════════════════════════════════════════════════╗${RESET}"
  echo -e "${BOLD}${GREEN}║         Installation Complete!                       ║${RESET}"
  echo -e "${BOLD}${GREEN}╚══════════════════════════════════════════════════════╝${RESET}\n"

  echo -e "${CYAN}Next steps:${RESET}"
  echo -e "  ${BOLD}1.${RESET} Log out and back in (for group changes to take effect)"
  echo -e "  ${BOLD}2.${RESET} Start Sway: ${CYAN}sway${RESET} (or select from display manager)"
  echo -e "  ${BOLD}3.${RESET} Launch Neovim and run ${CYAN}:PackerSync${RESET}"
  echo -e "  ${BOLD}4.${RESET} Set git identity: ${CYAN}git config --global user.name / user.email${RESET}"
  echo -e "  ${BOLD}5.${RESET} Install Papirus icons: ${CYAN}paru -S papirus-icon-theme${RESET} (optional)"
  echo -e "\n${YELLOW}Log file: $LOG_FILE${RESET}\n"
}

# ── Menu / argument parsing ───────────────────────────────────────────────────
usage() {
  echo -e "Usage: ${BOLD}$0 [OPTIONS]${RESET}"
  echo ""
  echo "Options:"
  echo "  --all         Full installation (recommended for fresh install)"
  echo "  --packages    Install packages only"
  echo "  --link        Symlink dotfiles only"
  echo "  --services    Enable services only"
  echo "  --theme       Apply GTK theme only"
  echo "  --help        Show this help"
  echo ""
  echo "No args = interactive menu"
}

run_all() {
  preflight
  install_paru
  install_packages
  backup_configs
  link_configs
  setup_shell
  setup_groups
  enable_services
  setup_cpufreq
  setup_neovim
  setup_theme
  setup_docker
  setup_git
  finish
}

# ── Entry point ───────────────────────────────────────────────────────────────
banner

case "${1:-}" in
  --all)      run_all ;;
  --packages) preflight; install_paru; install_packages ;;
  --link)     backup_configs; link_configs ;;
  --services) enable_services ;;
  --theme)    setup_theme ;;
  --help|-h)  usage ;;
  "")
    echo -e "${BOLD}What would you like to do?${RESET}\n"
    echo "  1) Full install (fresh Arch system)"
    echo "  2) Link dotfiles only (already have packages)"
    echo "  3) Install packages only"
    echo "  4) Enable services only"
    echo "  5) Apply theme only"
    echo "  6) Exit"
    echo ""
    read -rp "Choice [1-6]: " choice
    case "$choice" in
      1) run_all ;;
      2) backup_configs; link_configs ;;
      3) preflight; install_paru; install_packages ;;
      4) enable_services ;;
      5) setup_theme ;;
      6) exit 0 ;;
      *) err "Invalid choice"; exit 1 ;;
    esac
    ;;
  *) usage; exit 1 ;;
esac
