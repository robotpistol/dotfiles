initialize = function()
  require 'config'
  require 'reloader'
  require 'spoons'
  require 'logger'
  loadSpoons({
    "ModalMgr",
    "WindowHalfsAndThirds",
  })

  require 'index'
end

status, err = pcall(initialize)
if err then
  hs.alert.show("ERROR reloading config")
  print(err)
else
  hs.alert.show("Hammerspoon Configuration reloaded")
end
