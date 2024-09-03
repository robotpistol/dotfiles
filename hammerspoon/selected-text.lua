selectedText = function()
  element = hs.uielement.focusedElement()
  selection = nil
  if element then
    selection = element:selectedText()
  end

  if (not selection) or (selection == "") then
    hs.eventtap.keyStroke({"cmd"}, "c")
    hs.timer.usleep(20000)
    selection = hs.pasteboard.getContents()
  end

  print(selection)
  return selection or ""
end
