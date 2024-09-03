local jiraBaseUrl = "https://chime.atlassian.net"

require 'selected-text'

getSelectedJiraTicketUrl = function()
  selectedText = selectedText()
  if selectedText == nil then
    return nil
  end
  selectedText = selectedText
  selectedText = string.gsub(selectedText, "%[", "")
  selectedText = string.gsub(selectedText, "%]", "")
  selectedText = string.gsub(selectedText, "s%", "")
  selectedText = string.upper(selectedText)
  if selectedText:match("^[A-Z]+-[0-9]+") == nil then
    return nil
  end
  return jiraBaseUrl.."/browse/" .. selectedText
end

-- JIRA-1234
copySelectedJiraTicket = function()
  jiraUrl = getSelectedJiraTicketUrl()
  if jiraUrl == nil then
    return
  end
  tprint(jiraUrl)
  hs.pasteboard.setContents(jiraUrl)
  hs.alert.show(jiraUrl)
end

openSelectedJiraTicket = function()
  jiraUrl = getSelectedJiraTicketUrl()
  if jiraUrl then
    os.execute("open " .. jiraUrl)
  end
end

openJira = function()
  os.execute("open ".. jiraBaseUrl.."/jira/software/c/projects/FINPLAT/boards/502")
end
