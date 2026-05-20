local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Font (matches GNOME Terminal "Tomorrow Night" profile)
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 13.0

-- Default shell: zsh inside tmux (attach to session 0, create if missing)
config.default_prog = { "/usr/bin/bash", "-l", "-c", "tmux new-session -A -s 0" }
-- If you'd rather just launch zsh and run tmux manually, swap to:
-- config.default_prog = { "/usr/bin/zsh", "-l" }

-- Colors: replicate "Tomorrow Night" profile from gnome-terminal
config.colors = {
    foreground = "#c5c8c6",
    background = "#1d1f21",

    cursor_bg = "#c5c8c6",
    cursor_fg = "#1d1f21",
    cursor_border = "#c5c8c6",

    selection_fg = "#1d1f21",
    selection_bg = "#c5c8c6",

    ansi = {
        "#1d1f21", -- black
        "#cccc66", -- red
        "#33d17a", -- green
        "#f0c674", -- yellow
        "#81a2be", -- blue
        "#b29493", -- magenta
        "#8abab7", -- cyan
        "#b6b6b6", -- white
    },
    brights = {
        "#656565", -- bright black
        "#f66151", -- bright red
        "#33d17a", -- bright green
        "#f0c674", -- bright yellow
        "#81a2be", -- bright blue
        "#b29493", -- bright magenta
        "#8abab7", -- bright cyan
        "#ffffff", -- bright white
    },
}

-- bold-is-bright behavior from gnome-terminal
config.bold_brightens_ansi_colors = true

-- Cursor: solid block, system blink rate (matches gnome-terminal "block" + "system")
config.default_cursor_style = "SteadyBlock"
config.cursor_blink_rate = 0

-- You're using tmux for splits/tabs, so hide wezterm's own tab bar
config.enable_tab_bar = false
config.use_fancy_tab_bar = false
config.window_decorations = "NONE"

-- Quality-of-life
config.scrollback_lines = 10000
config.audible_bell = "Disabled"
config.window_padding = { left = 4, right = 4, top = 2, bottom = 2 }

-- Background image with translucent terminal overlay
config.window_background_opacity = 1.0
config.background = {
    {
        source = { File = os.getenv("HOME") .. "/Pictures/shinjuku.png" },
        attachment = "Fixed",
        repeat_x = "NoRepeat",
        repeat_y = "NoRepeat",
        horizontal_align = "Center",
        vertical_align = "Middle",
        hsb = { brightness = 0.10 },
    },
    {
        source = { Color = "#1d1f21" },
        height = "100%",
        width = "100%",
        opacity = 0.75,
    },
}

-- Tell apps we support truecolor + undercurl (good for nvim)
config.term = "wezterm"

return config
