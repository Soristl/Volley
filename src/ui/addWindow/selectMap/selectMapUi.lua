function selectMapUI(name)
  removeSelectUI(name)
  local maps = configSelectMap()
  local maxPage = getMaxPageMap(maps)
  local page = selectMapPage[name]
  local userLevel = USER_PERMISSIONS[name] or 1

  for i = 1, 5 do
    local index = i + ((page - 1) * 5)

    if maps[index] ~= nil then
      local textSelect = "<a href='event:setmap" .. index .. "'>Select map</a>"
      local voteText = "<a href='event:votemap" .. index .. "'>Vote map (" .. showMapVotes(maps, index) .. ")</a>"

      if index == gameStats.customMapIndex then
        textSelect = "<j>Selected map<n>"
      elseif userLevel > 1 then
        textSelect = "<n2>Select map<n>"
      end

      if not canVote[name] then
        voteText = "<n2>Vote map<n> (" .. showMapVotes(maps, index) .. ")"
      end

      ui.addTextArea("" .. tostring(99999) .. "" .. tostring(i) .. "", "", name, (142 + ((i - 1) * 125)), 115, 110, 140,
        0x142b2e, 0x8a583c, 1, true)
      ui.addTextArea("" .. tostring(999999) .. "" .. tostring(i) .. "", "", name, (147 + ((i - 1) * 125)), 120, 100, 43,
        0x142b2e, 0x2d5a61, 1, true)
      ui.addTextArea("" .. tostring(9999999) .. "" .. tostring(i) .. "",
        "<p align='center'><font size='12px'><a href='event:map" ..
        maps[index][3] .. "'>" .. formatMapName(maps[index][3]) .. "</a>", name, (147 + ((i - 1) * 125)), 165, 100, 20,
        0x142b2e, 0x2d5a61, 0, true)

      ui.addTextArea("" .. tostring(99999999) .. "" .. tostring(i) .. "",
        "<p align='center'><font size='12px'>" .. textSelect .. "", name, (147 + ((i - 1) * 125)), 190, 100, 20, 0x142b2e,
        0x2d5a61, 1, true)
      ui.addTextArea("" .. tostring(999999999) .. "" .. tostring(i) .. "",
        "<p align='center'><font size='12px'>" .. voteText .. "", name, (147 + ((i - 1) * 125)), 225, 100, 20, 0x142b2e,
        0x2d5a61, 1, true)

      table.insert(selectMapImages[name],
        tfm.exec.addImage(maps[index][6], "~999999" .. i .. "", (147 + ((i - 1) * 125)), 118, name))
    end
  end

  selectMapPointersNavigation(name, page, maxPage)

  if page == 1 then
    buttonNextOrPrev(26, name, 135, 300, 200, 30, 1, "<n2>" .. playerLanguage[name].tr.previousMessage .. "</n>")
  else
    buttonNextOrPrev(26, name, 135, 300, 200, 30, 1,
      "<a href='event:prevSelectMap" .. tostring(page - 1) .. "'>" .. playerLanguage[name].tr.previousMessage .. "</a>")
  end

  if page >= maxPage then
    buttonNextOrPrev(25, name, 560, 300, 200, 30, 1, "<n2>" .. playerLanguage[name].tr.nextMessage .. "</n>")
  else
    buttonNextOrPrev(25, name, 560, 300, 200, 30, 1,
      "<a href='event:nextSelectMap" .. tostring(page + 1) .. "'>" .. playerLanguage[name].tr.nextMessage .. "</a>")
  end
end
