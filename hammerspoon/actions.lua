sendCurrentWindowToNextScreen =  function()
  currWindow = hs.window.focusedWindow()
  if currWindow then
    nextScreen = currWindow:screen():next()
    mvFn = function() return currWindow:moveToScreen(nextScreen, true, true, 0) end
    restore = function() return currWindow:maximize() and currWindow:raise() and currWindow:focus() end
    switchScreen = function() return mvFn() and restore() end
    if currWindow:isFullscreen() then
      currWindow:setFullScreen(false)
      hs.timer.waitUntil(function() return not currWindow:isFullscreen() end, switchScreen)
    else
      switchScreen()
    end
  end
end

toggleFullScreen = function()
  currWindow = hs.window.focusedWindow()
  if currWindow then
    currWindow:setFullScreen(not currWindow:isFullscreen())
  end
end

unminimizeWindows = function()
  for k,v in pairs(hs.window.minimizedWindows()) do
    v:unminimize()
  end
  hs.fnutils.map(hs.window.minimizedWindows(), function(x)  x:unminimize() end)
end

editConfig = function()
  hs.execute('code  ~/.hammerspoon')
end
