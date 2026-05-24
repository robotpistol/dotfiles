--[[
Hammerspoon Configuration Entry Point
Initializes spoons and loads all required modules
--]]

local function initialize()
  -- Load core configuration
  require 'config'
  require 'logger'
  require 'spoons'

  -- Initialize required spoons
  LoadSpoons({
    "EmmyLua",
    "ModalMgr",
    "WindowHalfsAndThirds",
  })

  -- Load user configuration
  require 'reloader'
  require 'index'
end

-- Safe initialization with error handling
local status, err = pcall(initialize)
if status then
  hs.alert.show("Hammerspoon Configuration loaded")
else
  hs.alert.show("Error loading configuration")
  print(err)
end
