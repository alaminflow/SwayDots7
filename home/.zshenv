# ~/.zshenv — loaded for ALL zsh instances (login, interactive, scripts)
# Keep this minimal and fast
# shellcheck shell=bash

# XDG base directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# Default apps
export EDITOR=nvim
export VISUAL=nvim
export BROWSER=firefox
export PAGER=less

# Zsh dirs
export ZDOTDIR="$HOME"
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"

# Wayland
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export GDK_BACKEND=wayland,x11
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway
export XDG_SESSION_TYPE=wayland

# PATH
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
