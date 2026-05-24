local jiraBaseUrl = "https://chime.atlassian.net"

require 'selected-text'

---@return string | nil
GetJiraTicketNumber = function()
  local selectedText = SelectedText()
  if selectedText == nil then
    return nil
  end
  selectedText = string.gsub(selectedText, "%[", "")
  selectedText = string.gsub(selectedText, "%]", "")
  selectedText = string.gsub(selectedText, "%s", "")
  selectedText = string.upper(selectedText)
  if selectedText:match("^[A-Z]+-[0-9]+") == nil then
    return nil
  end
  return selectedText
end

---@return string | nil
GetSelectedJiraTicketUrl = function()
  local selectedText = GetJiraTicketNumber()
  if selectedText == nil then
    return nil
  end
  return jiraBaseUrl.."/browse/" .. selectedText
end

-- JIRA-1234
CopySelectedJiraTicket = function()
  local jiraUrl = GetSelectedJiraTicketUrl()
  if jiraUrl == nil then
    return
  end
  Tprint(jiraUrl)
  hs.pasteboard.setContents(jiraUrl)
  hs.alert.show(jiraUrl)
end

OpenSelectedJiraTicket = function()
  local jiraUrl = GetSelectedJiraTicketUrl()
  if jiraUrl then
    hs.urlevent.openURL(jiraUrl)
    -- os.execute("open " .. jiraUrl)
  end
end

OpenJira = function()
  hs.urlevent.openURL(jiraBaseUrl.."/jira/software/c/projects/FINPLAT/boards/502")
end



local functionMapping = {
  ["open"] = function(url)
    os.execute("open ".. url)
  end,
}

JiraSelections = function(ticketNumber)
  return {
    {
      ["text"] = jiraBaseUrl.."/browse/"..ticketNumber,
      ["subText"] = "This is the subtext of the first choice",
      ["fnMap"] = "open"
    },
    { ["text"] = "["..ticketNumber.."]",
      ["subText"] = "I wonder what I should type here?",
    },
    {
      ["text"] = ticketNumber.. "-",
      ["subText"] = "What a lot of choosing there is going on here!",
    },
  }
end


JiraSelector = function()
  local selectedText = GetJiraTicketNumber()
  if selectedText == nil then
    Tprint("nil selected text")
    return nil
  end
  Tprint(selectedText)

  local chooser = hs.chooser.new(function(selection)
    local fn = functionMapping[selection["fnMap"]]
    if fn ~= nil then
      fn(selection["text"])
    end
    hs.pasteboard.setContents(selection["text"])
    hs.alert(selection["text"])
  end)
  chooser:choices(JiraSelections(selectedText))
  chooser:show()
end
