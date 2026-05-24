-- Require dependencies
require 'actions'

local _taps = {}

local function bindHighPriority(mod, key, fn)
  local modSet = {}
  for _, m in ipairs(mod) do modSet[m:lower()] = true end

  return hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    local flags = event:getFlags()
    local mappedKey = hs.keycodes.map[event:getKeyCode()]

    if mappedKey ~= key:lower() then return false end
    for m, _ in pairs(modSet) do
      if not flags[m] then return false end
    end

    fn()
    return true
  end):start()
end

--[[
Application Focus Utilities
These functions handle focusing and launching applications
--]]

function FocusAppFn(appNameOrID)
  return function()
    FocusApp(appNameOrID)
  end
end

function FocusApp(appNameOrID)
  local located_name = hs.application.nameForBundleID(appNameOrID)
  if located_name then
    hs.application.launchOrFocusByBundleID(appNameOrID)
  else
    hs.application.launchOrFocus(appNameOrID)
  end
end

--[[
Modal Management
Creates and manages modal key binding interfaces with timeout and visual feedback
--]]

function Modal(mod, modalName, key, spec, options)
  -- Initialize configuration
  options = options or {}
  local timeout = options.timeout or 5
  local color = options.color or "#FFBD2E"
  local countdown = nil
  local startTime = 0


  -- Create new modal
  spoon.ModalMgr:new(modalName)
  local modal = spoon.ModalMgr.modal_list[modalName]
  modal.name = modalName
  modal.active = false

  -- Timer management
  function modal.resetTimer()
    if modal.timer then
      modal.timer:stop()
      startTime = hs.timer.secondsSinceEpoch()
      modal.timer:start()
    end
  end

  -- Visual countdown management
  local function createCountdownDisplay()
    local countdownText = hs.styledtext.new(string.format("%.1f", timeout), {
      font = { size = 24 },
      color = { hex = "#000000" },
      paragraphStyle = { alignment = "center" }
    })

    countdown = hs.canvas.new({ x = 20, y = 20, w = 60, h = 30 })
    countdown:appendElements({
      type = "rectangle",
      action = "fill",
      fillColor = { hex = "#FFFFFF", alpha = 0.8 },
      roundedRectRadii = { xRadius = 5, yRadius = 5 },
    }, {
      type = "text",
      text = countdownText,
      frame = { x = "0%", y = "0%", h = "100%", w = "100%" }
    })
    countdown:show()
  end

  local function updateCountdownDisplay(remaining)
    countdown:elementAttribute(2, "text", hs.styledtext.new(string.format("%.1f", remaining), {
      font = { size = 24 },
      color = { hex = "#000000" },
      paragraphStyle = { alignment = "center" }
    }))
  end

  -- Modal state management
  function modal.exitHyper(method)
    if modal.active then
      if countdown then
        countdown:hide()
        countdown = nil
      end
      spoon.ModalMgr:deactivate({modal.name})
      modal.active = false
      modal.timer:stop()

      if method == "timer" then
        hs.alert.show("Modal timed out", 1)
      end
    end
  end

  function modal.enterHyper()
    if not modal.active then
      spoon.ModalMgr:activate({modal.name}, color, true)

      -- Setup visual countdown
      if countdown then countdown:delete() end
      createCountdownDisplay()

      -- Setup timer
      startTime = hs.timer.secondsSinceEpoch()
      modal.timer = hs.timer.new(0.1, function()
        local elapsed = hs.timer.secondsSinceEpoch() - startTime
        local remaining = timeout - elapsed

        if remaining <= 0 then
          modal.exitHyper("timer")
        else
          updateCountdownDisplay(remaining)
        end
      end)
      modal.timer:start()

      modal.active = true
    end
  end

  -- Bind modal keys
  modal:bind('', 'escape', 'Exit Modal', function() modal.exitHyper() end)
  modal:bind('', 'Q', 'Exit Modal', function() modal.exitHyper() end)
  modal:bind('', 'tab', 'Show Keybindings', function() spoon.ModalMgr:toggleCheatsheet() end)

  -- Bind custom keys
  for _, binding in pairs(spec) do
    modal:bind('', binding.key, binding.message or "",
      function() modal.resetTimer() end,  -- On press
      function()                          -- On release
        modal.exitHyper()
        binding.fn()
      end
    )
  end

  -- Bind activation hotkey
  if type(mod) == "string" then mod = {mod} end
  table.insert(_taps, bindHighPriority(mod, key, function() modal.enterHyper() end))

  return modal
end

--[[
Hyper Key Configuration
Sets up global hotkeys and modal interfaces
--]]

function Hyper(mod, spec)
  for _, binding in pairs(spec) do
    -- Validate configuration
    if not binding.key then
      error("Missing required 'key' field in spec")
    end

    if binding.fn then
      -- Setup direct hotkey
      if type(binding.fn) ~= "function" then
        error("'fn' must be a function")
      end
      if type(mod) == "string" then mod = {mod} end
      table.insert(_taps, bindHighPriority(mod, binding.key, binding.fn))

    elseif binding.modal then
      -- Setup modal interface
      if not binding.modal.name then
        error("Modal requires a name")
      end
      if not binding.modal.spec then
        error("Modal requires a spec")
      end
      Modal(mod, binding.modal.name, binding.key, binding.modal.spec)
    end
  end
end

