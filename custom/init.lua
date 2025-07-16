--- wezterm.lua
--- $ figlet -f small Wezterm
--- __      __      _
--- \ \    / /__ __| |_ ___ _ _ _ __
---  \ \/\/ / -_)_ /  _/ -_) '_| '  \
---   \_/\_/\___/__|\__\___|_| |_|_|_|
---
--- My Wezterm config file

local wezterm = require("wezterm")
local balance = require("config.custom.equalize_panels")
local act = wezterm.action

local shell = {}

local config = {}
-- Use config builder object if possible
if wezterm.config_builder then
	config = wezterm.config_builder()
end

if wezterm.target_triple:find("windows") then
	-- shell = { "powershell.exe", "-NoLogo" }
	-- shell = { "pwsh.exe", "-NoLogo" }
	-- shell = { "cmd.exe" }
	config.default_domain = "WSL:archlinux" -- ✅ Force into the WSL domain

	config.launch_menu = {
		{ label = "Arch WSL", args = { "wsl.exe", "-d", "Arch" } },
		{ label = "CMD", args = { "cmd.exe" } },
		{ label = "PowerShell", args = { "powershell.exe", "-NoLogo" } },
		{ label = "pwsh_core", args = { "pwsh.exe", "-NoLogo" } },
	}
else
	shell = { "/usr/bin/fish", "-l" }
end

-- Settings
config.default_prog = shell

config.color_scheme = "Dark Pastel"
config.font = wezterm.font_with_fallback({
	{ family = "MesloLGS NF", weight = "Bold" },
	-- { family = "DengXian", weight = "Bold" },
})
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 30000
config.default_workspace = "main"

-- Dim inactive panes
config.inactive_pane_hsb = {
	saturation = 0.8,
	brightness = 0.5,
}

-- Keys
-- creates a leader key
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
	-- disables default configurations
	{ key = "T", mods = "CTRL", action = wezterm.action.DisableDefaultAssignment },
	{ key = "W", mods = "CTRL|SHIFT", action = wezterm.action.DisableDefaultAssignment },

	-- Send C-a when pressing C-a twice
	{ key = "a", mods = "LEADER|CTRL", action = act.SendKey({ key = "a", mods = "CTRL" }) },
	{ key = "c", mods = "LEADER", action = act.ActivateCopyMode },
	{ key = "phys:Space", mods = "LEADER", action = act.ActivateCommandPalette },
	{ key = "q", mods = "CTRL", action = act.CloseCurrentPane({ confirm = false }) },
	{ key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "f", mods = "LEADER", action = act.Search({ Regex = "" }) },
	-- Wezterm offers custom "mode" in the name of "KeyTable"
	{
		key = "a",
		mods = "LEADER",
		action = act.ActivateKeyTable({ name = "SUPER", one_shot = false }),
	},

	-- Pane keybindings
	-- splits
	{ key = "s", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

	--EQUALIZE
	{
		key = "S",
		mods = "LEADER|SHIFT",
		action = act.Multiple({
			wezterm.action_callback(balance.balance_panes("x")),
		}),
	},
	{
		key = "V",
		mods = "LEADER|SHIFT",
		action = act.Multiple({
			wezterm.action_callback(balance.balance_panes("y")),
		}),
	},
	--pane navigation
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{
		key = "H",
		mods = "LEADER",
		action = act.Multiple({
			act.ActivatePaneDirection("Left"),
			act.AdjustPaneSize({ "Right", 200 }),
		}),
	},
	{
		key = "L",
		mods = "LEADER",
		action = act.Multiple({
			act.ActivatePaneDirection("Right"),
			act.AdjustPaneSize({ "Left", 200 }),
		}),
	},
	{
		key = "K",
		mods = "LEADER",
		action = act.Multiple({
			act.ActivatePaneDirection("Up"),
			act.AdjustPaneSize({ "Down", 100 }),
		}),
	},
	{
		key = "J",
		mods = "LEADER",
		action = act.Multiple({
			act.ActivatePaneDirection("Down"),
			act.AdjustPaneSize({ "Up", 100 }),
		}),
	},

	-- pane management
	{ key = "q", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "o", mods = "LEADER", action = act.RotatePanes("Clockwise") },
	{ key = "O", mods = "LEADER", action = act.RotatePanes("CounterClockwise") },

	-- Tab keybindings
	--Tab navigation
	{ key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "n", mods = "LEADER", mods = "LEADER", action = act.ShowTabNavigator },
	--  shortcuts to move tab. SHIFT is for when caps lock is on
	{ key = "}", mods = "LEADER|SHIFT", action = act.MoveTabRelative(1) },
	{ key = "{", mods = "LEADER|SHIFT", action = act.MoveTabRelative(-1) },
	--Tab management
	{ key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	--creates workspace
	{ key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
	--tab raname
	{
		key = "e",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Renaming Tab Title...:" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}

config.key_tables = {

	SUPER = {
		-- Pane keybindings
		-- splits
		{ key = "s", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ key = "v", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

		--pane navigation
		{ key = "h", action = act.ActivatePaneDirection("Left") },
		{ key = "j", action = act.ActivatePaneDirection("Down") },
		{ key = "k", action = act.ActivatePaneDirection("Up") },
		{ key = "l", action = act.ActivatePaneDirection("Right") },
		{
			key = "H",
			action = act.Multiple({
				act.ActivatePaneDirection("Left"),
				act.AdjustPaneSize({ "Right", 200 }),
			}),
		},
		{
			key = "L",
			action = act.Multiple({
				act.ActivatePaneDirection("Right"),
				act.AdjustPaneSize({ "Left", 200 }),
			}),
		},
		{
			key = "K",
			action = act.Multiple({
				act.ActivatePaneDirection("Up"),
				act.AdjustPaneSize({ "Down", 100 }),
			}),
		},
		{
			key = "J",
			action = act.Multiple({
				act.ActivatePaneDirection("Down"),
				act.AdjustPaneSize({ "Up", 100 }),
			}),
		},

		-- pane management
		{ key = "q", action = act.CloseCurrentPane({ confirm = true }) },
		{ key = "z", action = act.TogglePaneZoomState },
		{ key = "o", action = act.RotatePanes("Clockwise") },
		{ key = "O", action = act.RotatePanes("CounterClockwise") },

		-- Tab keybindings
		--Tab navigation
		{ key = "[", action = act.ActivateTabRelative(-1) },
		{ key = "]", action = act.ActivateTabRelative(1) },
		{ key = "n", action = act.ShowTabNavigator },

		--  shortcuts to move tab. SHIFT is for when caps lock is on
		{ key = "{", mods = "SHIFT", action = act.MoveTabRelative(-1) },
		{ key = "}", mods = "SHIFT", action = act.MoveTabRelative(1) },

		--Tab management
		{ key = "t", action = act.SpawnTab("CurrentPaneDomain") },
		--tab raname
		{
			key = "e",

			action = act.PromptInputLine({
				description = wezterm.format({
					{ Attribute = { Intensity = "Bold" } },
					{ Foreground = { AnsiColor = "Fuchsia" } },
					{ Text = "Renaming Tab Title...:" },
				}),
				action = wezterm.action_callback(function(window, pane, line)
					if line then
						window:active_tab():set_title(line)
					end
				end),
			}),
		},
		--PANE RESIZE
		-- Adjust pane size with arrow keys
		{ key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "UpArrow", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "DownArrow", action = act.AdjustPaneSize({ "Down", 1 }) },

		--EQUALIZE
		{
			key = "S",
			action = act.Multiple({
				wezterm.action_callback(balance.balance_panes("x")),
			}),
		},
		{
			key = "V",
			action = act.Multiple({
				wezterm.action_callback(balance.balance_panes("y")),
			}),
		},
		--COPYMODE
		{ key = "c", action = act.ActivateCopyMode },
		-- Lastly, workspace
		{ key = "w", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
		-- Finish
		{ key = "Escape", action = "PopKeyTable" },
	},
}

--  quickly navigate tabs with index in LEADER mode;
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
end
--  quickly navigate tabs with index in SUPER mode;
for i = 1, 9 do
	table.insert(config.key_tables.SUPER, {
		key = tostring(i),
		action = act.ActivateTab(i - 1),
	})
end

-- Tab bar
-- I don't like the look of "fancy" tab bar
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.status_update_interval = 1000
config.tab_bar_at_bottom = false
wezterm.on("update-status", function(window, pane)
	-- Workspace name
	local stat = window:active_workspace()
	local stat_color = "#0af529"
	-- It's a little silly to have workspace name all the time
	-- Utilize this to display LDR or current key table name
	if window:active_key_table() == "SUPER" then
		stat = window:active_key_table()
		stat_color = "#eb1b08"
	end
	if window:active_key_table() == "copy_mode" then
		stat = window:active_key_table()
		stat = "VISUAL"
		stat_color = "#7dcfff"
	end
	if window:active_key_table() == "search_mode" then
		stat = window:active_key_table()
		stat = "FIND"
		stat_color = "#be0af5"
	end
	if window:leader_is_active() then
		stat = "LEADER"
		stat_color = "#ff5"
	end

	local basename = function(s)
		-- Nothing a little regex can't fix
		return string.gsub(s, "(.*[/\\])(.*)", "%2")
	end

	-- Current working directory
	local cwd = pane:get_current_working_dir()
	if cwd then
		if type(cwd) == "userdata" then
			-- Wezterm introduced the URL object in 20240127-113634-bbcac864
			cwd = basename(cwd.file_path)
		else
			-- 20230712-072601-f4abf8fd or earlier version
			cwd = basename(cwd)
		end
	else
		cwd = ""
	end

	-- Current command
	local cmd = pane:get_foreground_process_name()
	-- CWD and CMD could be nil (e.g. viewing log using Ctrl-Alt-l)
	cmd = cmd and basename(cmd) or ""

	-- Time
	local time = wezterm.strftime("%H:%M")

	-- Left status (left of the tab line)
	window:set_left_status(wezterm.format({
		{ Foreground = { Color = stat_color } },
		{ Text = "  " },
		{ Text = wezterm.nerdfonts.oct_table .. "  " .. stat },
		{ Text = " |" },
	}))

	-- Right status
	window:set_right_status(wezterm.format({
		-- Wezterm has a built-in nerd fonts
		-- https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html
		{ Text = wezterm.nerdfonts.md_folder .. "  " .. cwd },
		{ Text = " | " },
		{ Foreground = { Color = "#e0af68" } },
		{ Text = wezterm.nerdfonts.fa_code .. "  " .. cmd },
		"ResetAttributes",
		{ Text = " | " },
		{ Text = wezterm.nerdfonts.md_clock .. "  " .. time },
		{ Text = "  " },
	}))
end)

--
--window config
config.background = {
	{
		source = {
			-- it can be a little tricky because you must use the
			-- path relative the wezterm.lua and not the current working directory

			File = "./config/custom/wallpapers/gif2.gif",
			-- File = "./config/custom/wallpapers/image4.jpg",
		},
		-- -- Toon colorful
		-- hsb = {
		-- 	hue = 1.0,
		-- 	saturation = 1.02,
		-- 	brightness = 5,
		-- },
		-- cool and dim
		-- hsb = {
		-- 	hue = 0.7,
		-- 	saturation = 0.9,
		-- 	brightness = 0.5,
		-- },
		-- deep warm toones
		-- hsb = {
		-- 	hue = 0.05,
		-- 	saturation = 1.0,
		-- 	brightness = 0.5,
		-- },
		-- subtle purple night
		-- hsb = {
		-- 	hue = 0.75,
		-- 	saturation = 0.7,
		-- 	brightness = 0.45,
		-- },
		width = "100%",
		height = "100%",
		opacity = 0.3,
	},
	----------------- NO IMAGE BG -----------
	{
		source = {
			Color = "#000000",
			-- Color = "#510d5e",
		},

		-- -- Toon colorful
		-- hsb = {
		-- 	hue = 1.0,
		-- 	saturation = 1.02,
		-- 	brightness = 5,
		-- },
		-- -- subtle purple night
		hsb = {
			hue = 0.75,
			saturation = 0.7,
			brightness = 0.45,
		},
		-- -- deep warm toones
		-- hsb = {
		-- 	hue = 0.05,
		-- 	saturation = 1.0,
		-- 	brightness = 0.5,
		-- },
		-- --grayscale
		-- hsb = {
		-- 	hue = 0.0,
		-- 	saturation = 0.2,
		-- 	brightness = 0.4,
		-- },
		-- -- cool and dim
		-- hsb = {
		-- 	hue = 0.7,
		-- 	saturation = 0.9,
		-- 	brightness = 0.5,
		-- },
		-- --Dark & Muted
		-- hsb = {
		-- 	hue = 1.0,
		-- 	saturation = 0.8,
		-- 	brightness = 0.6,
		-- },
		width = "100%",
		height = "100%",
		opacity = 0.5,
	},
}

config.window_background_opacity = 0
--windows
--values: Auto, Disable, Acrylic, Mica, Tabbed
-- config.win32_system_backdrop = "Mica"
config.win32_system_backdrop = "Acrylic"
-- config.win32_system_backdrop = "Tabbed"
--
-- linux
-- config.kde_window_background_blur = true
-- Appearance setting for when I need to take pretty screenshots
-- config.enable_tab_bar = false
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
--
return config
