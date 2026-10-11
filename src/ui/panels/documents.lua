function clubhouse.document(name, key, page)
  if not (clubhouse.views[name] and clubhouse.views[name][key]) then clubhouse.closeWindows(name)
  else clubhouse.closePageInput(name) end
  clubhouse.panel(name, key)
  clubhouse.closeLabel(name, key)
  if key == "help" then
    local pages = clubhouse.documentPages
    page = math.max(1, math.min(#pages, math.floor(tonumber(page) or 1)))
    uiState.pagesList[name].helpPage = page
    clubhouse.helpDocument(name, page)
    clubhouse.navigation(name, key, page, #pages, "prevHelp" .. (page-1), "nextHelp" .. (page+1))
  elseif key == "credits" then
    clubhouse.creditsDocument(name)
  elseif key == "real_rules" then
    clubhouse.realDocument(name)
  end
  clubhouse.endUpdate(name, key)
end

-- Document navigation and its panel state stay together; the event applies guards first.
function clubhouse.documentCallback(name, c)
  if c == "howToPlay" then
    clubhouse.closeProfile(name)
    uiState.openRank[name] = false
    clubhouse.closeRanking(name)
    uiState.pagesList[name].helpPage = 1
    clubhouse.helpWindow(name, uiState.pagesList[name].helpPage, playerState.language[name].tr.nextMessage,
      playerState.language[name].tr.previousMessage)
  elseif string.sub(c, 1, 8) == "nextHelp" or string.sub(c, 1, 8) == "prevHelp" then
    uiState.pagesList[name].helpPage = tonumber(string.sub(c, 9))
    clubhouse.helpWindow(name, uiState.pagesList[name].helpPage, playerState.language[name].tr.nextMessage,
      playerState.language[name].tr.previousMessage)
  elseif c == "credits" then
    clubhouse.closeProfile(name)
    uiState.openRank[name] = false
    clubhouse.closeRanking(name)
    clubhouse.document(name,"credits")
  elseif c == "realmode" then
    clubhouse.closeProfile(name)
    uiState.openRank[name] = false
    clubhouse.closeRanking(name)
    ui.addWindow(266, "" .. playerState.language[name].tr.realModeRules .. "", name, 125, 60, 650, 300, 1, false, true,
      playerState.language[name].tr.closeUIText)
  else
    return false
  end
  return true
end
