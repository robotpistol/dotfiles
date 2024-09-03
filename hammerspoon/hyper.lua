hyper = {"cmd", "alt", "ctrl", "shift"}
require 'actions'


focusAppFn = function(appNameOrID)
  return function()
    focusApp(appNameOrID)
  end
end

focusApp = function(appNameOrID)
  local located_name = hs.application.nameForBundleID(appNameOrID)
  if located_name then
    hs.application.launchOrFocusByBundleID(appNameOrID)
  else
    hs.application.launchOrFocus(appNameOrID)
  end
end

Modal = function(modalName, key, spec)
  spoon.ModalMgr:new(modalName)

  local modal = spoon.ModalMgr.modal_list[modalName]

  modal:bind('', 'escape', 'Deactivate appM', function() spoon.ModalMgr:deactivate({modalName}) end)
  modal:bind('', 'Q', 'Deactivate appM', function() spoon.ModalMgr:deactivate({modalName}) end)
  modal:bind('', 'tab', 'Toggle Cheatsheet', function() spoon.ModalMgr:toggleCheatsheet() end)

  for _, spec in pairs(spec) do
    modal:bind('', spec.key, spec.message, function()
      spoon.ModalMgr:deactivate(modalName)
      spec.fn()
    end)
  end

  hs.hotkey.bind(hyper, key, function()
    spoon.ModalMgr:activate({modalName}, "#FFBD2E", true)
    hs.timer.delayed.new(5, function() spoon.ModalMgr:deactivate({modalName}) end).start()
  end)
  return modal
end

Hyper = function(mod, spec)
  for _, spec in pairs(spec) do
    if spec.fn then
      hs.hotkey.bind(mod, spec.key, spec.message, spec.fn)
    else
      if spec.modal then
        Modal(spec.modal.name, spec.key, spec.modal.spec)
      end
    end
  end
end

