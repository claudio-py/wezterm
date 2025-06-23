local wezterm = require('wezterm')
local act = wezterm.action

local config = {}


if wezterm.config_builder then config = wezterm.config_builder() end
    --overall settings

    config.automatically_reload_config = true
    config.enable_tab_bar = false
    config.window_decorations = "RESIZE" -- disable the title bar but enable the resible border
    config.default_cursor_style = "BlinkingBar"
    config.color_scheme = "Dark Pastel"
    config.font = wezterm.font("MesloLGS NF",{weight = "Bold"})
    config.font_size = 13.8
    config.scrollback_lines = 30000
    config.use_fancy_tab_bar = false
    --keys
    config.leader = {
        key = "k", 
        mods = "CTRL", 
        timeout_miliseconds = 1000
    }
    config.keys = {
        --Send C-a when pressing C-a twice
        {
            key = "a",
            mods = "LEADER",    
            action = act.SendKey {
                key="a",
                mods = "CTRL"
            }
        }, 
        {
            key = "c",
            mods = "LEADER",
            action = act.ActivateCopyMode
        },
        --Pane keybindings
        {
            key = "-",
            mods = "LEADER",
            action = act.SplitVertical {
                domain = "CurrentPaneDomain"
            }
        },
        -- SHIFT  is for when caps lock is on
        {
            key = "|",
            mods = "LEADER|SHIFT",
            action = act.SplitHorizontal {
                domain = "CurrentPaneDomain"
            }

        },
        --zoom mode
        {
            key = "z",
            mods = "LEADER",
            action = act.TogglePaneZoomState
        },
        {
            key = "s",
            mods = "LEADER",
            action = act.RotatePanes "Clockwise"
        },
        {
            key = "d",
            mods = "LEADER",
            action = act.RotatePanes "CounterClockwise"
        }
    }
    --window config
    config.background = {
        {
            source = {
            File = "/home/claud/Pictures/wallpapers/image1.jpg"
            },
            hsb ={
                hue =1.0,
                saturation =1.02,
                brightness = 5,
            },
            width ="100%",
            height = "100%",
            opacity= .58
        },
        {
            source={
                Color = "#000000",
            },
            width = "100%",
            height = "100%",
            opacity = 0.8
        },
    }
    config.window_padding ={
        left = 3,
        right = 3,
        top = 0,
        bottom = 0,
    }


return config 
