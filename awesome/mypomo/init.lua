local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")

local text = wibox.widget {
    id = "txt",
    font = "FiraCode Nerd Font 3",
    widget = wibox.widget.textbox
}

local pomo = {}

-- Set the work duration in seconds (default is 25 minutes)
pomo.work_duration = 2 * 60

-- Set the break duration in seconds (default is 5 minutes)
pomo.break_duration = 1 * 60

-- Initialize the remaining time to the work duration
pomo.remaining_time = pomo.work_duration

-- Default period
pomo.period = "work"

-- Initialize the timer object
pomo.timer = gears.timer {
  timeout = 1,
  autostart = false,
  callback = function()
    pomo.remaining_time = pomo.remaining_time - 1
    if pomo.remaining_time <= 0 then
      pomo:switch_period()
    end
  end
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

function pomodoroarc:update_text()
  local status = pomo.timer.started and "Running" or "Stopped"
  local time_remaining = pomo.timer.started and pomo.remaining_time or 0
  local minutes = math.floor(time_remaining / 60)
  local seconds = time_remaining - minutes * 60
  if status == "Stopped" then
  pomodoroarc.colors = { "#FFFFFF"}
  text.text = "S"
  pomodoroarc.value = tonumber(1)
  else
    text.text = minutes .. ":" .. seconds
    if pomo.period == "work" then
      pomodoroarc.value = tonumber(time_remaining/pomo.work_duration)
      if tonumber(minutes) < 5 then -- last 5 min of pomo
        pomodoroarc.colors = {"#fb4934"}
      else
        pomodoroarc.colors = {"#83a598"}
      end
    elseif pomo.period == "break" then
      pomodoroarc.value = tonumber(time_remaining/pomo.break_duration)
      pomodoroarc.colors = {"#b8bb26"}
    end
  end
end

-- local update_graphic = function(widget, stdout, _, _, _)
--     local pomostatus = string.match(stdout, "  (%D?%D?):%D?%D?")
--     if pomostatus == "--" then
--       widget.colors = { "#FFFFFF"}
--       text.text = "25"
--       widget.value = 1
--     else
--       local pomomin = string.match(stdout, "[ P]?[BW](%d?%d?):%d?%d?")
--       local pomosec = string.match(stdout, "[ P]?[BW]%d?%d?:(%d?%d?)")
--       local pomodoro = pomomin * 60 + pomosec
--
--       local status = string.match(stdout, "([ P]?)[BW]%d?%d?:%d?%d?")
--       local workbreak = string.match(stdout, "[ P]?([BW])%d?%d?:%d?%d?")
--       text.text = pomomin
--
--       if status == " " then -- clock ticking
--         if workbreak == "W" then
--           widget.value = tonumber(pomodoro/(25*60))
--           if tonumber(pomomin) < 5 then -- last 5 min of pomo
--             widget.colors = {"#fb4934"}
--           else
--             widget.colors = {"#83a598"}
--           end
--         elseif workbreak == "B" then -- color during pause
--           widget.colors = {"#b8bb26"}
--           widget.value = tonumber(pomodoro/(5*60))
--         end
--       elseif status == "P" then -- paused
--         if workbreak == "W" then
--           widget.colors = {"#ff8800"}
--           widget.value = tonumber(pomodoro/(25*60))
--           text.text = "PW"
--         elseif workbreak == "B" then
--           widget.colors = {"#ff8800"}
--           widget.value = tonumber(pomodoro/(5*60))
--           text.text = "PB"
--         end
--       end
--     end
-- end

-- Switch between work and break periods
function pomo:switch_period()
  if pomo.period == "work" then
    pomo.timer:stop()
    pomo.remaining_time = pomo.break_duration
    pomo.period = "break"
    pomo.timer:start()
  else
    pomo.timer:stop()
    pomo.remaining_time = pomo.work_duration
    pomo.period = "work"
    pomo.timer:start()
  end
  pomodoroarc:update_text()
end

-- Start the Pomodoro timer
function pomo:start()
  pomo.timer:start()
  pomodoroarc:update_text()
end

-- Stop the Pomodoro timer
function pomo:stop()
  pomo.timer:stop()
  pomodoroarc:update_text()
end

-- Start or stop the Pomodoro timer
function pomo:toggle()
  if pomo.timer.started then
    pomo:stop()
  else
    pomo:start()
  end
end

-- Reset the Pomodoro timer
function pomo:reset()
  pomo.timer:stop()
  pomo.remaining_time = pomo.work_duration
  pomo.period = "work"
  pomodoroarc:update_text()
end

-- Update the text of the Pomodoro widget when the timer is started or stopped
pomo.timer:connect_signal("timeout", function() pomodoroarc:update_text()end)
pomo.timer:connect_signal("start", function() pomodoroarc:update_text() end)
pomo.timer:connect_signal("stop", function() pomodoroarc:update_text() end)
pomodoroarc:connect_signal("button::press", function(_,_,_,button)
    if button == 1 then
      pomo:toggle()
      -- pomodoro:notify(string.format("START: %s for: %d min", pomodoro.period, math.floor(pomodoro.remaining_time / 60)))
    elseif button == 2 then
      pomo:switch_period()
      -- pomodoro:notify(string.format("SWITCH: %s for: %d min", pomodoro.period, math.floor(pomodoro.remaining_time / 60)))
    elseif button == 3 and pomo.timer.started then
      pomo:reset()
      -- pomodoro:notify("STOP")
    end
end)

pomodoroarc:update_text()

return pomodoroarc_widget
