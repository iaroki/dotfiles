local awful = require("awful")
local spawn = require("awful.spawn")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local naughty = require("naughty")

local pomo_get = "pomo.sh clock"
local pomo_toggle = "pomo.sh pause"
local pomo_start = "pomo.sh start"
local pomo_finish = "pomo.sh stop"

local text = wibox.widget {
    id = "txt",
    font = "FiraCode Nerd Font 6",
    widget = wibox.widget.textbox
}

-- mirror the text, because the whole widget will be mirrored after
local mirrored_text = wibox.container.margin(wibox.container.mirror(text, { horizontal = true }))
mirrored_text.right = 3 -- pour centrer le texte dans le rond

-- mirrored text with background
local mirrored_text_with_background = wibox.container.background(mirrored_text)

local pomodoroarc = wibox.widget {
    mirrored_text_with_background,
    max_value = 1,
    thickness = 2,
    start_angle = 4.71238898, -- 2pi*3/4
    forced_height = 32,
    forced_width = 32,
    rounded_edge = true,
    bg = "#ffffff11",
    paddings = 0,
    widget = wibox.container.arcchart
}

local pomodoroarc_widget = wibox.container.mirror(pomodoroarc, { horizontal = true })

local update_graphic = function(widget, stdout, _, _, _)
    local pomostatus = string.match(stdout, "  (%D?%D?):%D?%D?")
    if pomostatus == "--" then
      widget.colors = { "#FFFFFF"}
      text.text = "25"
      widget.value = 1
    else
      local pomomin = string.match(stdout, "[ P]?[BW](%d?%d?):%d?%d?")
      local pomosec = string.match(stdout, "[ P]?[BW]%d?%d?:(%d?%d?)")
      local pomodoro = pomomin * 60 + pomosec

      local status = string.match(stdout, "([ P]?)[BW]%d?%d?:%d?%d?")
      local workbreak = string.match(stdout, "[ P]?([BW])%d?%d?:%d?%d?")
      text.text = pomomin

-- Helps debugging
--       naughty.notify {
--         text = pomomin,
--         title = "pomodoro debug",
--         timeout = 5,
--         hover_timeout = 0.5,
--         width = 200,
--       }

      if status == " " then -- clock ticking
        if workbreak == "W" then
          widget.value = tonumber(pomodoro/(25*60))
          if tonumber(pomomin) < 5 then -- last 5 min of pomo
            widget.colors = {"#fb4934"}
          else
            widget.colors = {"#83a598"}
          end
        elseif workbreak == "B" then -- color during pause
          widget.colors = {"#b8bb26"}
          widget.value = tonumber(pomodoro/(5*60))
        end
      elseif status == "P" then -- paused
        if workbreak == "W" then
          widget.colors = {"#ff8800"}
          widget.value = tonumber(pomodoro/(25*60))
          text.text = "PW"
        elseif workbreak == "B" then
          widget.colors = {"#ff8800"}
          widget.value = tonumber(pomodoro/(5*60))
          text.text = "PB"
        end
      end
    end
end

pomodoroarc:connect_signal("button::press", function(_, _, _, button)
    if (button == 2) then awful.spawn(pomo_start, false)
    elseif (button == 1) then awful.spawn(pomo_toggle, false)
    elseif (button == 3) then awful.spawn(pomo_finish, false)
    end

    spawn.easy_async(pomo_get, function(stdout, stderr, exitreason, exitcode)
        update_graphic(pomodoroarc, stdout, stderr, exitreason, exitcode)
    end)
end)

local notification
local function show_pomodoro_status()
    spawn.easy_async(pomo_get,
        function(stdout, _, _, _)
            notification = naughty.notify {
                text = stdout,
                title = "pomodoro status",
                timeout = 5,
                hover_timeout = 0.5,
                width = 200,
            }
        end)
end

pomodoroarc:connect_signal("mouse::enter", function() show_pomodoro_status() end)
pomodoroarc:connect_signal("mouse::leave", function() naughty.destroy(notification) end)

watch(pomo_get, 1, update_graphic, pomodoroarc)

return pomodoroarc_widget
