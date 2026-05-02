#!/bin/bash

osascript 2>/dev/null <<'APPLESCRIPT'
tell application "System Events"
  tell process "ControlCenter"
    set frontmost to true
    delay 0.1
    
    try
      click menu bar item "Control Center" of menu bar 1
    on error
      click menu bar item 1 of menu bar 1 where description is "Control Center"
    end try
    
    delay 0.5
    
    try
      click button "Focus" of group 1 of window "Control Center"
      delay 0.4
      
      try
        click checkbox "Do Not Disturb" of group 1 of group 1 of window "Control Center"
      on error
        try
          click button "Do Not Disturb" of group 1 of group 1 of window "Control Center"
        on error
          click button "Do Not Disturb" of group 1 of window "Control Center"
        end try
      end try
      
    on error errMsg
      try
        click button "Do Not Disturb" of group 1 of window "Control Center"
      on error errMsg2
        set allButtons to buttons of group 1 of window "Control Center"
        repeat with aButton in allButtons
          if name of aButton contains "Do Not Disturb" or description of aButton contains "Do Not Disturb" then
            click aButton
            exit repeat
          end if
        end repeat
      end try
    end try
    
    delay 0.3
    key code 53
  end tell
end tell
APPLESCRIPT

if [ $? -eq 0 ]; then
  sleep 0.5
  sketchybar --trigger forced_update
else
  open "x-apple.systempreferences:com.apple.preference.notifications?Focus"
fi
