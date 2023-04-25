local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")

local text = wibox.widget {
    id = "txt",
    font = "FiraCode Nerd Font 6",
    widget = wibox.widget.textbox
}

local pomo = {}

-- Set the work duration in seconds (default is 25 minutes)
pomo.work_duration = 25 * 60

-- Set the break duration in seconds (default is 5 minutes)
pomo.break_duration = 5 * 60

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
mirrored_text.right = 4

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
  pomo.color = "#dddddd"
  pomodoroarc.colors = { pomo.color }
  mirrored_text.right = 7
  text.markup = "<span foreground='#ff9999'></span>"
  pomodoroarc.value = tonumber(1)
  else
    mirrored_text.right = 4
    if minutes < 1 then
      text.text = string.format("%02d", seconds)
    else
      text.text = string.format("%02d", minutes)
    end
    if pomo.period == "work" then
      pomodoroarc.value = tonumber(time_remaining/pomo.work_duration)
      if tonumber(minutes) < 5 then
        pomo.color = "#fb4934"
        pomodoroarc.colors = { pomo.color }
      else
        pomo.color = "#83a598"
        pomodoroarc.colors = { pomo.color }
      end
    elseif pomo.period == "break" then
      pomodoroarc.value = tonumber(time_remaining/pomo.break_duration)
      pomo.color = "#b8bb26"
      pomodoroarc.colors = { pomo.color }
    end
  end
end

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
  pomo:notify(string.format("Started %s for %d minutes", pomo.period, math.floor(pomo.remaining_time/60)))
  pomo:sound()
end

-- Start the Pomodoro timer
function pomo:start()
  pomo.timer:start()
  pomodoroarc:update_text()
  pomo:notify(string.format("Started %s for %d minutes", pomo.period, math.floor(pomo.remaining_time/60)))
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
  pomo:sound()
end

function pomo:notify(msg)
  naughty.notify({
    title = "Pomodoro",
    text = msg,
    position = "top_middle",
    fg = "#111111",
    bg = pomo.color,
    replaces_id = 1,
    timeout = 5,
    max_width = 600
  })
end

function pomo:sound()
  local sound_file = awful.util.getdir("config") .."/pomodoro/timer.mp3"
  awful.spawn("paplay " .. sound_file)
end

-- Update the text of the Pomodoro widget when the timer is started or stopped
pomo.timer:connect_signal("timeout", function() pomodoroarc:update_text()end)
pomo.timer:connect_signal("start", function() pomodoroarc:update_text() end)
pomo.timer:connect_signal("stop", function() pomodoroarc:update_text() end)
pomodoroarc:connect_signal("button::press", function(_,_,_,button)
    if button == 1 then
      pomo:toggle()
    elseif button == 2 then
      pomo:switch_period()
    elseif button == 3 and pomo.timer.started then
      pomo:reset()
    end
end)

pomodoroarc:update_text()

return pomodoroarc_widget
