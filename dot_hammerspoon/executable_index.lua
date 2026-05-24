require 'jira'
require 'hyperkey'
require 'selected-text'
require 'actions'

local hyper = {"cmd", "alt", "ctrl", "shift"}

Hyper(hyper, {
  {key = "F", message = 'Toggle FullScreen', fn = ToggleFullScreen},
  {key = "U", message = 'Unminimize Windows', fn = UnminimizeWindows},
  {key = "C", message = 'Edit Config', fn = EditConfig},
  {key = "R", message = 'Reload Config', fn = hs.reload},
  {key = "Y", message = 'Toggle Console', fn = hs.toggleConsole},
  {key = "L", message = 'Lock Screen', fn = hs.caffeinate.lockScreen},
  {key = "return", fn = spoon.WindowHalfsAndThirds.maximize}, -- message = 'Maximize',
  {key = "left",   fn = spoon.WindowHalfsAndThirds.leftHalf}, -- message = 'Window Left Half',
  {key = "right",  fn = spoon.WindowHalfsAndThirds.rightHalf}, -- message = 'Window Right Half',
  {key = "up",     fn = spoon.WindowHalfsAndThirds.topHalf}, -- message = 'Window Top Half',
  {key = "down",   fn = spoon.WindowHalfsAndThirds.bottomHalf}, -- message = 'Window Bottom Half',
  {key = "J", fn = OpenSelectedJiraTicket},
  {key = "S", fn = JiraSelector},
  {key = "Q", fn = function()
    hs.alert.show(hs.pasteboard.getContents())
  end},
  {key = "A", message = 'Applications', modal={
    name = "applications",
    spec = {
      {key = '1', fn = FocusAppFn('1Password'), message = '1Password'},
      {key = 'a', fn = FocusAppFn('Arc'), message = 'Arc'},
      {key = 'c', fn = FocusAppFn('Visual Studio Code'), message = 'Visual Studio Code'},
      {key = 'e', fn = FocusAppFn('Messenger'), message = 'Messenger'},
      {key = 'f', fn = FocusAppFn('Finder'), message = 'Finder'},
      {key = 'h', fn = FocusAppFn('Home'), message = 'Home'},
      {key = 'i', fn = FocusAppFn('claude.app'), message = 'Claude'},
      {key = 'm', fn = FocusAppFn('Messages'), message = 'Messages'},
      {key = 'n', fn = FocusAppFn('Notion'), message = 'Notion'},
      {key = 'p', fn = FocusAppFn('1Password'), message = '1Password'},
      {key = 's', fn = FocusAppFn('Slack'), message = 'Slack'},
      {key = 't', fn = FocusAppFn('Ghostty'), message = 'Ghostty'},
      {key = 'v', fn = FocusAppFn('com.apple.ActivityMonitor'), message = 'ActivityMonitor'},
      {key = 'y', fn = FocusAppFn('com.apple.systempreferences'), message = 'systempreferences'},
      -- {key = 'y', fn = FocusAppFn('Spotify'), message = 'Spotify'},
      {key = 'z', fn = FocusAppFn('Zoom.us'), message = 'Zoom'},
    }
  }},

  {key = 'space', message = "System", modal = {
    name = "System",
    spec = {
      {key = 'left', message= "Send Current Window to Next Screen", fn = SendCurrentWindowToNextScreen},
      {key = 'right', message= "Send Current Window to Previous Screen", fn = SendCurrentWindowToNextScreen},
      {key = ',', message= "Edit Config", fn = EditConfig},
      {key = 'c', message= "Toggle Console", fn = hs.toggleConsole},
    }
  }},
  {key = "g", message = "Selected Text", modal = {
    name = "selectedM",
    spec = {-- upcase
      {key ="u",  message = "Upcase Selected Text", fn = function() hs.eventtap.keyStrokes(string.upper(SelectedText())) end},
      -- downcase
      {key ="d",  message = "Down Selected Text", fn = function() hs.eventtap.keyStrokes(string.lower(SelectedText())) end},
    }
  }},

})
