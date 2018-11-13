exec st &
exec autorun.sh &
setxkbmap -layout us,ru,ua -variant winkeys -option grp:alt_shift_toggle &
exec ck-launch-session dbus-launch --sh-syntax --exit-with-session dwm
