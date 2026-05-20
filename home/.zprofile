# ~/.zprofile — executed on login shell
# Auto-start Sway on TTY1 login

if [[ -z "${WAYLAND_DISPLAY}" && -z "${DISPLAY}" && "$(tty)" == "/dev/tty1" ]]; then
  exec sway 2>&1 | tee ~/.local/share/sway.log
fi
