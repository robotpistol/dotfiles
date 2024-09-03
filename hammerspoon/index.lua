require 'jira'
require 'hyper'
require 'selected-text'

Hyper(hyper, {
  {key = "F", message = 'Toggle FullScreen', fn = toggleFullScreen},
  {key = "U", message = 'Unminimize Windows', fn = unminimizeWindows},
  {key = "C", message = 'Edit Config', fn = editConfig},
  {key = "R", message = 'Reload Config', fn = hs.reload},
  {key = "Y", message = 'Toggle Console', fn = hs.toggleConsole},
  {key = "L", message = 'Lock Screen', fn = hs.caffeinate.lockScreen},
  {key = "return", fn = spoon.WindowHalfsAndThirds.maximize}, -- message = 'Maximize',
  {key = "left",   fn = spoon.WindowHalfsAndThirds.leftHalf}, -- message = 'Window Left Half',
  {key = "right",  fn = spoon.WindowHalfsAndThirds.rightHalf}, -- message = 'Window Right Half',
  {key = "up",     fn = spoon.WindowHalfsAndThirds.topHalf}, -- message = 'Window Top Half',
  {key = "down",   fn = spoon.WindowHalfsAndThirds.bottomHalf}, -- message = 'Window Bottom Half',
  {key = "j", fn = openSelectedJiraTicket},
  {key = "s", fn = selectedText},

  {key = "A", message = 'Applications', modal={
    name = "applications",
    spec = {
      {key = '1', fn = focusAppFn('1Password'), message = '1Password'},
      {key = 'a', fn = focusAppFn('Arc'), message = 'Arc'},
      {key = 'c', fn = focusAppFn('Visual Studio Code'), message = 'Visual Studio Code'},
      {key = 'f', fn = focusAppFn('Finder'), message = 'Finder'},
      {key = 'h', fn = focusAppFn('Home'), message = 'Home'},
      {key = 'm', fn = focusAppFn('Messenger'), message = 'Messenger'},
      {key = 'n', fn = focusAppFn('Notion'), message = 'Notion'},
      {key = 'p', fn = focusAppFn('1Password'), message = '1Password'},
      {key = 's', fn = focusAppFn('Slack'), message = 'Slack'},
      {key = 't', fn = focusAppFn('Iterm'), message = 'Iterm'},
      {key = 'v', fn = focusAppFn('com.apple.ActivityMonitor'), message = 'ActivityMonitor'},
      {key = 'y', fn = focusAppFn('com.apple.systempreferences'), message = 'systempreferences'},
      {key = 'y', fn = focusAppFn('Spotify'), message = 'Spotify'},
      {key = 'z', fn = focusAppFn('Zoom.us'), message = 'Zoom'},
    }
  }},

  {key = "w", message = "Web", modal = {
    name = "Web",
    spec = {
      {key = "j", message = "Open Jira", fn = openJira},
    }
  }},

  {key = 'space', message = "System", modal = {
    name = "System",
    spec = {
      {key = 'left', message= "Send Current Window to Next Screen", fn = sendCurrentWindowToNextScreen},
      {key = 'right', message= "Send Current Window to Previous Screen", fn = sendCurrentWindowToNextScreen},
      {key = ',', message= "Edit Config", fn = editConfig},
      {key = 'c', message= "Toggle Console", fn = hs.toggleConsole},
    }
  }},



  -- {key = "g", message = "Selected Text", modal = {
  --   name = "selectedM",
  --   spec = {-- upcase
  --     {key ="u",  message = "Upcase Selected Text", fn = function() hs.eventtap.keyStrokes(string.upper(selectedText())) end},
  --     -- downcase
  --     {key ="d",  message = "Down Selected Text", fn = function() hs.eventtap.keyStrokes(string.lower(selectedText())) end},
  --   }
  -- }}
    -- link
    -- l: Hyper(name: 'Link', afterAction: (hyper) -> hyper.modal\exit!)\space{
    --   {key = "t",  fn = function() matte\chooseTab((tab) -> end},
    --     hs.eventtap.keyStrokes("[#{selectedText()}](#{tab["url"]})") if tab
    --   )
    --   {key ="v",  fn = function() hs.eventtap.keyStrokes("[#{selectedText()}](#{hs.pasteboard.getContents!})") end},
    -- }
  -- }
})
