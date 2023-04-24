local wibox = require("wibox")
local gears = require("gears")
local naughty = require("naughty")

local pomodoro = {}

-- Set the work duration in seconds (default is 25 minutes)
pomodoro.work_duration = 2 * 60

-- Set the break duration in seconds (default is 5 minutes)
pomodoro.break_duration = 1 * 60

-- Initialize the remaining time to the work duration
pomodoro.remaining_time = pomodoro.work_duration

-- Default period
pomodoro.period = "work"

-- Initialize the timer object
pomodoro.timer = gears.timer {
  timeout = 1,
  autostart = false,
  callback = function()
    pomodoro.remaining_time = pomodoro.remaining_time - 1
    if pomodoro.remaining_time <= 0 then
      pomodoro:switch_period()
    end
  end
}

-- Update the text of the Pomodoro widget
function pomodoro:update_text()
  local status = self.timer.started and "Running" or "Stopped"
  local time_remaining = self.timer.started and self.remaining_time or 0
  local minutes = math.floor(time_remaining / 60)
  local seconds = time_remaining - minutes * 60
  local time_remaining_string = string.format("%02d:%02d", minutes, seconds)
  local text = string.format("<b>Pomodoro: (%s %s)</b>: %s", status, self.period,time_remaining_string)
  self.widget:set_markup(text)
end

-- Initialize the Pomodoro widget
pomodoro.widget = wibox.widget.textbox()
pomodoro:update_text()

-- Update the text of the Pomodoro widget when the timer is started or stopped
pomodoro.timer:connect_signal("timeout", function() pomodoro:update_text()end)
pomodoro.timer:connect_signal("start", function() pomodoro:update_text() end)
pomodoro.timer:connect_signal("stop", function() pomodoro:update_text() end)
pomodoro.widget:connect_signal("button::press", function(_,_,_,button)
    if button == 1 then
      pomodoro:toggle()
      pomodoro:notify(string.format("START: %s for: %d min", pomodoro.period, math.floor(pomodoro.remaining_time / 60)))
    elseif button == 2 then
      pomodoro:switch_period()
      pomodoro:notify(string.format("SWITCH: %s for: %d min", pomodoro.period, math.floor(pomodoro.remaining_time / 60)))
    elseif button == 3 and pomodoro.timer.started then
      pomodoro:stop()
      pomodoro:notify("STOP")
    end
end)

function pomodoro:notify(text)
  naughty.notify({
    title = "Pomodoro",
    text = text,
    timeout = 10,
    width = 200
  })
end

-- Switch between work and break periods
function pomodoro:switch_period()
  if self.period == "work" then
    self.timer:stop()
    self.remaining_time = self.break_duration
    self.period = "break"
    self.timer:start()
  else
    self.timer:stop()
    self.remaining_time = self.work_duration
    self.period = "work"
    self.timer:start()
  end
  self:update_text()
end

-- Start the Pomodoro timer
function pomodoro:start()
  self.timer:start()
  self:update_text()
end

-- Stop the Pomodoro timer
function pomodoro:stop()
  self.timer:stop()
  self:update_text()
end

-- Start or stop the Pomodoro timer
function pomodoro:toggle()
  if pomodoro.timer.started then
    pomodoro:stop()
  else
    pomodoro:start()
  end
end

return pomodoro
