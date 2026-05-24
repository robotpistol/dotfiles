SendCurrentWindowToNextScreen =  function()
  local currWindow = hs.window.focusedWindow()
  if currWindow then
    local nextScreen = currWindow:screen():next()
    local mvFn = function() return currWindow:moveToScreen(nextScreen, true, true, 0) end
    local restore = function() return currWindow:maximize() and currWindow:raise() and currWindow:focus() end
    local switchScreen = function() return mvFn() and restore() end
    if currWindow:isFullscreen() then
      currWindow:setFullScreen(false)
      hs.timer.waitUntil(function() return not currWindow:isFullscreen() end, switchScreen)
    else
      switchScreen()
    end
  end
end

ToggleFullScreen = function()
  local currWindow = hs.window.focusedWindow()
  if currWindow then
    currWindow:setFullScreen(not currWindow:isFullscreen())
  end
end

UnminimizeWindows = function()
  hs.fnutils.map(hs.window.minimizedWindows(), function(x)  x:unminimize() end)
end

EditConfig = function()
  hs.task.new("/usr/local/bin/code", nil, {"--new-window", os.getenv("HOME") .. "/.hammerspoon"}):start()
end
