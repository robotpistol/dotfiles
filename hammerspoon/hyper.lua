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
  modal.name = modalName
  modal.active = false

  modal.enterHyper = function()
    if not modal.active then
      spoon.ModalMgr:activate({modal.name}, "#FFBD2E", true)
      modal.timer = hs.timer.delayed.new(5, function() exitHyper(modal, "timer") end)
      modal.timer.start()
      modal.active = true
      tprint("set to active")
    end
  end

  modal.exitHyper = function(method)
    tprint("closing", modal.name, modal.active, method, timer)
    if modal.active then
      spoon.ModalMgr:deactivate({modal.name})
      modal.active = false
      modal.timer.stop()
    else
      tprint(modal.name, "already closed!")
    end
  end

  modal:bind('', 'escape', 'Deactivate appM', function() modal.exitHyper() end)
  modal:bind('', 'Q', 'Deactivate appM', function() modal.exitHyper() end)
  modal:bind('', 'tab', 'Toggle Cheatsheet', function() spoon.ModalMgr:toggleCheatsheet() end)

  for _, spec in pairs(spec) do
    modal:bind('', spec.key, spec.message, function()
      modal.exitHyper()
      spec.fn()
    end)
  end

  hs.hotkey.bind(hyper, key, function() modal.enterHyper() end)
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
