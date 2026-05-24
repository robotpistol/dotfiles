--[[
Text Selection Utilities
Provides functions for working with selected text
--]]

---Gets the currently selected text from the focused element or clipboard
---@return string Selected text or empty string if nothing is selected
SelectedText = function()
  -- Try getting text from focused UI element
  local element = hs.uielement.focusedElement()
  local selection = element and element:selectedText()

  -- Fall back to clipboard method if no selection
  if not selection or selection == "" then
    hs.eventtap.keyStroke({"cmd"}, "c")
    hs.timer.usleep(20000)
    selection = hs.pasteboard.getContents()
  end

  return selection or ""
end
