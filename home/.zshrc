# =============================================================================
#  ~/.zshrc — Arch Linux + Sway
# =============================================================================

# ── Early exit for non-interactive shells ────────────────────────────────────
[[ $- != *i* ]] && return

# ── History ───────────────────────────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS HIST_IGNORE_SPACE
setopt HIST_VERIFY SHARE_HISTORY INC_APPEND_HISTORY EXTENDED_HISTORY

# ── Options ───────────────────────────────────────────────────────────────────
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT
setopt CORRECT EXTENDED_GLOB GLOB_DOTS NO_BEEP
setopt INTERACTIVE_COMMENTS

# ── Completion ────────────────────────────────────────────────────────────────
autoload -Uz compinit
compinit -d "$HOME/.cache/zsh/zcompdump"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}No matches for: %d%f'
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*' rehash true

# ── Plugins ───────────────────────────────────────────────────────────────────
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6c7086"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# ── Key bindings ──────────────────────────────────────────────────────────────
bindkey -e
bindkey '^[[A'  history-search-backward
bindkey '^[[B'  history-search-forward
bindkey '^[[H'  beginning-of-line
bindkey '^[[F'  end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# ── Aliases — Navigation ──────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# ── Aliases — ls / eza ───────────────────────────────────────────────────────
if command -v eza &>/dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -lah --icons --group-directories-first --git'
  alias la='eza -a --icons'
  alias lt='eza --tree --level=2 --icons'
  alias l='eza -lh --icons --group-directories-first'
else
  alias ls='ls --color=auto'
  alias ll='ls -lahF'
  alias la='ls -A'
fi

# ── Aliases — bat / cat ───────────────────────────────────────────────────────
if command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
  alias less='bat --paging=always'
  alias man='MANPAGER="sh -c '\''col -bx | bat -l man -p'\''" man'
fi

# ── Aliases — grep ────────────────────────────────────────────────────────────
alias grep='grep --color=auto'
# rg (ripgrep) binary is already named 'rg' — no alias needed

# ── Aliases — Git ─────────────────────────────────────────────────────────────
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gp='git push'
alias gpl='git pull'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gds='git diff --staged'

# ── Aliases — System ──────────────────────────────────────────────────────────
alias update='sudo pacman -Syu && paru -Sua'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq) 2>/dev/null; paru -Sc'
alias sysd='systemctl'
alias usysd='systemctl --user'
alias j='journalctl'
alias jf='journalctl -f'

# ── Aliases — Dev ────────────────────────────────────────────────────────────
alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias py='python'
alias pip='pip3'
alias dk='docker'
alias dkc='docker compose'
alias mk='make'

# ── Aliases — Misc ───────────────────────────────────────────────────────────
alias please='sudo'
alias q='exit'
alias clr='clear'
alias reload='source ~/.zshrc'
alias dotfiles='cd "${DOTFILES_DIR:-$HOME/.dotfiles}"'
alias ip='ip --color=auto'
alias ports='ss -tulnp'
alias df='df -h'
alias du='du -sh'
alias free='free -h'
alias myip='curl -s ifconfig.me'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'

# ── Functions ────────────────────────────────────────────────────────────────
# cd and list
cdl() { cd "$1" && ls; }

# mkdir and cd into it
mkcd() { mkdir -p "$1" && cd "$1" || return; }

# Extract any archive
extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz)  tar xzf "$1" ;;
      *.tar.xz)  tar xJf "$1" ;;
      *.tar)     tar xf  "$1" ;;
      *.bz2)     bunzip2 "$1" ;;
      *.gz)      gunzip  "$1" ;;
      *.zip)     unzip   "$1" ;;
      *.7z)      7z x    "$1" ;;
      *.rar)     unrar x "$1" ;;
      *.xz)      xz -d   "$1" ;;
      *)         echo "Don't know how to extract '$1'" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# fzf file open in nvim
fv() {
  local file
  file=$(fd --type f --hidden --exclude .git | fzf --preview 'bat --style=numbers --color=always {}')
  [[ -n "$file" ]] && nvim "$file"
}

# fzf cd into directory
fcd() {
  local dir
  dir=$(fd --type d --hidden --exclude .git | fzf --preview 'ls {}')
  [[ -n "$dir" ]] && cd "$dir" || return
}

# Git clone and cd
gclone() { git clone "$1" && cd "$(basename "$1" .git)" || return; }

# Quick note
note() { echo "$(date): $*" >> "$HOME/notes.txt"; }
notes() { bat "$HOME/notes.txt" 2>/dev/null || cat "$HOME/notes.txt"; }

# ── fzf integration ───────────────────────────────────────────────────────────
if command -v fzf &>/dev/null; then
  source /usr/share/fzf/key-bindings.zsh  2>/dev/null || true
  source /usr/share/fzf/completion.zsh    2>/dev/null || true

  export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
  export FZF_DEFAULT_OPTS="
    --height 40% --layout=reverse --border=rounded
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
  "
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
fi

# ── zoxide (smart cd) ─────────────────────────────────────────────────────────
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh --cmd cd)"
fi

# ── Starship prompt ───────────────────────────────────────────────────────────
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# ── Misc exports ──────────────────────────────────────────────────────────────
# NOTE: Wayland/XDG env vars are set in ~/.zshenv (loaded for all shells)
export LESS='-R --use-color'
export MANPAGER='less -R --use-color -Dd+r -Du+b'

# PATH is set in ~/.zshenv for all shell types

# ── Welcome message ───────────────────────────────────────────────────────────
if command -v fastfetch &>/dev/null && [[ -z "$FASTFETCH_SHOWN" ]]; then
  export FASTFETCH_SHOWN=1
  fastfetch
fi
