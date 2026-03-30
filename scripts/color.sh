#!/usr/bin/env bash
set -euo pipefail

# Tomorrow Night color scheme
# https://github.com/chriskempson/tomorrow-theme
BG="#1d1f21"
FG="#c5c8c6"
CURSOR="#c5c8c6"
BLACK="#1d1f21"
RED="#cccc66"
GREEN="#bab6b6"
YELLOW="#f0c674"
BLUE="#81a2be"
MAGENTA="#b29493"
CYAN="#8abab7"
WHITE="#b6b6b6"
BRIGHT_BLACK="#656565"
BRIGHT_RED="#f66151"
BRIGHT_GREEN="#33d17a"
BRIGHT_YELLOW="#f0c674"
BRIGHT_BLUE="#81a2be"
BRIGHT_MAGENTA="#b29493"
BRIGHT_CYAN="#8abab7"
BRIGHT_WHITE="#ffffff"

apply_gnome_terminal() {
    if ! command -v dconf &>/dev/null; then
        echo "dconf not found, skipping GNOME Terminal." >&2
        return 1
    fi

    local profile
    profile="$(dconf read /org/gnome/terminal/legacy/profiles:/default | tr -d "'")"
    if [[ -z "$profile" ]]; then
        profile="$(dconf list /org/gnome/terminal/legacy/profiles:/ | head -1 | tr -d '/:')"
    fi
    if [[ -z "$profile" ]]; then
        echo "No GNOME Terminal profile found." >&2
        return 1
    fi

    local path="/org/gnome/terminal/legacy/profiles:/:${profile}/"

    dconf write "${path}use-theme-colors" "false"
    dconf write "${path}foreground-color" "'${FG}'"
    dconf write "${path}background-color" "'${BG}'"
    dconf write "${path}cursor-foreground-color" "'${BG}'"
    dconf write "${path}cursor-background-color" "'${CURSOR}'"
    dconf write "${path}cursor-colors-set" "true"
    dconf write "${path}bold-color-same-as-fg" "true"
    dconf write "${path}palette" "['${BLACK}','${RED}','${GREEN}','${YELLOW}','${BLUE}','${MAGENTA}','${CYAN}','${WHITE}','${BRIGHT_BLACK}','${BRIGHT_RED}','${BRIGHT_GREEN}','${BRIGHT_YELLOW}','${BRIGHT_BLUE}','${BRIGHT_MAGENTA}','${BRIGHT_CYAN}','${BRIGHT_WHITE}']"

    echo "GNOME Terminal profile '${profile}' updated."
}

apply_wsl() {
    local wt_dir
    # Windows Terminal settings location from WSL
    local win_home
    win_home="$(wslpath "$(cmd.exe /C 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')")"
    wt_dir="${win_home}/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState"

    if [[ ! -d "$wt_dir" ]]; then
        # Try Windows Terminal Preview
        wt_dir="${win_home}/AppData/Local/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState"
    fi

    local scheme
    scheme=$(cat <<'SCHEME'
{
    "name": "Tomorrow Night",
    "background": "#1D1F21",
    "foreground": "#C5C8C6",
    "cursorColor": "#C5C8C6",
    "selectionBackground": "#373B41",
    "black": "#1D1F21",
    "red": "#CCCC66",
    "green": "#BAB6B6",
    "yellow": "#F0C674",
    "blue": "#81A2BE",
    "purple": "#B29493",
    "cyan": "#8ABAB7",
    "white": "#B6B6B6",
    "brightBlack": "#656565",
    "brightRed": "#F66151",
    "brightGreen": "#33D17A",
    "brightYellow": "#F0C674",
    "brightBlue": "#81A2BE",
    "brightPurple": "#B29493",
    "brightCyan": "#8ABAB7",
    "brightWhite": "#FFFFFF"
}
SCHEME
)

    if [[ -d "$wt_dir" ]]; then
        local settings="${wt_dir}/settings.json"
        if [[ -f "$settings" ]]; then
            echo "Windows Terminal settings found at:"
            echo "  ${settings}"
            echo ""
            echo "Add this color scheme to the \"schemes\" array in settings.json,"
            echo "then set \"colorScheme\": \"Tomorrow Night\" in your WSL profile:"
            echo ""
            echo "$scheme"
        else
            echo "Windows Terminal settings.json not found at expected path." >&2
            return 1
        fi
    else
        echo "Windows Terminal directory not found." >&2
        echo "Paste this scheme into your Windows Terminal settings.json \"schemes\" array:"
        echo ""
        echo "$scheme"
        return 1
    fi
}

is_wsl() {
    [[ -f /proc/version ]] && grep -qi microsoft /proc/version
}

if is_wsl; then
    echo "WSL detected."
    apply_wsl
    # Also apply to GNOME Terminal if running a GUI (e.g. WSLg)
    if [[ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ]]; then
        apply_gnome_terminal 2>/dev/null || true
    fi
else
    apply_gnome_terminal
fi
