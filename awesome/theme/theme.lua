local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi

local os = os
local my_table = gears.table

local theme               = {}
theme.confdir             = os.getenv("HOME") .. "/.config/awesome/theme"
theme.wallpaper           = os.getenv("HOME") .. "/Downloads/cp.jpg"
theme.font                = "FiraCode Nerd Font 12"
theme.menu_bg_normal      = "#000000"
theme.menu_bg_focus       = "#000000"
theme.bg_normal           = "#000000"
theme.bg_focus            = "#000000"
theme.bg_urgent           = "#000000"
theme.fg_normal           = "#dddddd"
theme.fg_focus            = "#ff8c00"
theme.fg_urgent           = "#af1d18"
theme.fg_minimize         = "#ffffff"
theme.border_width        = dpi(0)    -- NOTE: BORDERLESS SETUP
theme.border_normal       = "#1c2022"
theme.border_focus        = "#606060"
theme.border_marked       = "#3ca4d8"
theme.menu_border_width   = 0
theme.menu_width          = dpi(130)
theme.menu_submenu_icon   = theme.confdir .. "/icons/submenu.png"
theme.menu_fg_normal      = "#aaaaaa"
theme.menu_fg_focus       = "#ff8c00"
theme.menu_bg_normal      = "#050505dd"
theme.menu_bg_focus       = "#050505dd"
theme.useless_gap         = 0
theme.layout_tile         = theme.confdir .. "/icons/tile.png"
theme.layout_tilegaps     = theme.confdir .. "/icons/tilegaps.png"
theme.layout_tileleft     = theme.confdir .. "/icons/tileleft.png"
theme.layout_tilebottom   = theme.confdir .. "/icons/tilebottom.png"
theme.layout_tiletop      = theme.confdir .. "/icons/tiletop.png"
theme.layout_fairv        = theme.confdir .. "/icons/fairv.png"
theme.layout_fairh        = theme.confdir .. "/icons/fairh.png"
theme.layout_spiral       = theme.confdir .. "/icons/spiral.png"
theme.layout_dwindle      = theme.confdir .. "/icons/dwindle.png"
theme.layout_max          = theme.confdir .. "/icons/max.png"
theme.layout_fullscreen   = theme.confdir .. "/icons/fullscreen.png"
theme.layout_magnifier    = theme.confdir .. "/icons/magnifier.png"
theme.layout_floating     = theme.confdir .. "/icons/floating.png"

local markup = lain.util.markup

local mysep = wibox.widget.textbox(markup("#ff8800", " "))
local mykb = awful.widget.keyboardlayout()
local mypomo = require("mypomo")

-- -- Pomodoro
-- local awmodoro = require("awmodoro")
--
-- --pomodoro wibox
-- pomowibox = awful.wibox({ position = "bottom", screen = 1, height=2})
-- pomowibox.visible = true
-- local pomodoro = awmodoro.new({
-- 	minutes 			= 1,
-- 	do_notify 			= true,
-- 	active_bg_color 	= '#313131',
-- 	paused_bg_color 	= '#7746D7',
-- 	fg_color			= {type = "linear", from = {0,0}, to = {pomowibox.width, 0}, stops = {{0, "#AECF96"},{0.5, "#88A175"},{1, "#FF5656"}}},
-- 	width 				= pomowibox.width,
-- 	height 				= pomowibox.height,
-- -- })
--
-- 	begin_callback = function()
-- 		pomowibox.visible = true
-- 	end,
--
-- 	finish_callback = function()
-- 		pomowibox.visible = true
-- 	end})
-- pomowibox:set_widget(pomodoro)
-- local mypomo = wibox.widget.textbox(pomodoro:info())

-- mypomo = require("pomodoro")

-- Textclock
os.setlocale(os.getenv("LANG")) -- to localize the clock
local mytextclock = wibox.widget.textclock("        " .. markup("#FFFFFF", " %A %d %B ") .. markup("#FF7700", " %H:%M "))
mytextclock.font = theme.font

-- CPU
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, "#fb4934","閭 " .. cpu_now.usage .. "% "))
    end
})

-- MEM
local memory = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, "#b8bb26", "﬙ " .. mem_now.perc .. "% "))
    end
})

-- FS
theme.fs = lain.widget.fs({
    settings  = function()
        widget:set_markup(markup.fontfg(theme.font, "#83a598", " " .. fs_now["/"].percentage .. "% "))
    end
})

-- ALSA volume
theme.volume = lain.widget.alsa({
    settings = function()
        if volume_now.status == "off" then
            volume_now.level = "婢" .. volume_now.level .. "M"
        end

        widget:set_markup(markup.fontfg(theme.font, "#d3869b", " " .. volume_now.level .. "% "))
    end
})

-- Battery
local bat = lain.widget.bat({
    settings = function()
        local perc = bat_now.perc ~= "N/A" and bat_now.perc .. "%" or bat_now.perc

        if bat_now.ac_status == 1 then
            perc =  perc .. ""
        end

        widget:set_markup(markup.fontfg(theme.font, "#8ec07c", "  " .. perc .. " "))
    end
})

function theme.at_screen_connect(s)
    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(my_table.join(
                           awful.button({}, 1, function () awful.layout.inc( 1) end),
                           awful.button({}, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
                           awful.button({}, 3, function () awful.layout.inc(-1) end),
                           awful.button({}, 4, function () awful.layout.inc( 1) end),
                           awful.button({}, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({
      position = "top",
      screen = s,
      height = dpi(20),
      bg = theme.bg_normal .. 99,
      fg = theme.fg_normal })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            --s.mylayoutbox,
            s.mytaglist,
            s.mypromptbox,
            mysep,
            mypomo,
        },
        {
        --s.mytasklist, -- Middle widget
            layout = wibox.layout.align.horizontal,
            expand = 'outside',
            placeholder,
            mytextclock,
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykb,
            cpu.widget,
            mysep,
            memory.widget,
            mysep,
            theme.fs.widget,
            mysep,
            theme.volume.widget,
            mysep,
            bat.widget,
            wibox.widget.systray(),
            s.mylayoutbox,
        },
    }
end

return theme
