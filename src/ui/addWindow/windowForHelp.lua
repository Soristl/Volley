function windowForHelp(name, pageOfPlayer, textNext, textPrev)
  removeUITrophies(name)
  local pageList = #trad.helpText
  ui.addWindow(24, "" .. playerLanguage[name].tr.helpTitle .. "" ..
    playerLanguage[name].tr.helpText[pageOfPlayer].text .. "", name, 125, 60, 650, 300, 1, false, true,
    playerLanguage[name].tr.closeUIText)
  if pageOfPlayer >= 1 and pageOfPlayer < pageList then
    local page = pageOfPlayer + 1
    buttonNextOrPrev(25, name, 540, 300, 200, 30, 1, "<a href='event:nextHelp" .. tostring(page) ..
      "'>" .. textNext .. "</a>")
  else
    buttonNextOrPrev(25, name, 540, 300, 200, 30, 1, "<n2>" .. textNext .. "")
  end
  if pageOfPlayer > 1 then
    local page = pageOfPlayer - 1
    buttonNextOrPrev(26, name, 160, 300, 200, 30, 1, "<a href='event:prevHelp" .. tostring(page) ..
      "'>" .. textPrev .. "</a>")
  else
    buttonNextOrPrev(26, name, 160, 300, 200, 30, 1, "<n2>" .. textPrev .. "")
  end
end
