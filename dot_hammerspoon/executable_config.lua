--[[
Core Hammerspoon Configuration
Sets up basic system preferences and behaviors
--]]

-- CLI Installation
hs.ipc.cliInstall("/opt/homebrew/bin")
require('hs.ipc')

-- System Preferences
hs.autoLaunch(true)
hs.automaticallyCheckForUpdates(true)
hs.consoleOnTop(false)
hs.dockIcon(false)
hs.menuIcon(true)
hs.uploadCrashData(true)

-- Window Animation Settings
hs.window.animationDuration = 0
