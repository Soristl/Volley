-- 2s anti-spam cooldown per panel-opening button (closing stays instant)
local function panelOpenCooldown(name, panel)
  panelOpenTime[name] = panelOpenTime[name] or {}
  local lastOpen = panelOpenTime[name][panel]
  if lastOpen and os.time() - lastOpen < 2000 then
    return true
  end
  panelOpenTime[name][panel] = os.time()
  return false
end

function eventTextAreaCallback(id, name, c)
  if playerBan[name] then return end
  if clubhouse.guardCallback(name,c) then return end
  if c:sub(1,10)=="pageInput:" then clubhouse.pageInputCallback(name,c);return end
  local closing=c=="closeWindow" or c=="menuClose" or c=="profileClose" or c=="rankingClose" or c=="ballCategoriesClose"
  if not clubhouse.allowInput(name,closing) then return end
  if c=="ballCategoriesOpen" or c=="ballCategoriesClose" or c:match("^ballCategory:") then clubhouse.ballCategoryCallback(name,c);return end
  if c:sub(1,11)=="choosePage:" then clubhouse.choosePage(name,c:sub(12));return end
  if c:sub(1, 7) == "ranking" and c ~= "ranking" then
    rankingCallback(name, c)
    return
  end
  if c == "profileClose" then
    if profileState[name] then removeUITrophies(name) end
    return
  elseif c:sub(1, 11) == "profileMode" then
    updateProfileMode(name, tonumber(c:sub(12)))
    return
  elseif c == "profileEquipTrophy" then
    equipProfileTrophy(name)
    return
  end
  if gameStats.initTimer > 2 and gameStats.canJoin then
    if string.sub(c, 1, 11) == "joinTeamRed" and playerInGame[name] == false and playersRed[tonumber(string.sub(c, 12))].name == '' then
      local isPlayerBanned = messagePlayerIsBanned(name)
      if isPlayerBanned then
        return
      end

      local index = tonumber(string.sub(c, 12))
      playerInGame[name] = true
      playersRed[index].name = name

      if gameStats.threeTeamsMode then
        clubhouse.joinArea(threeTeamsMode.id[index],
          "<p align='center'><font size='14px'><a href='event:leaveTeamRed" .. index .. "'>" .. name .. "", nil,
          threeTeamsMode.x[index], threeTeamsMode.y[index], 150, 40, 0x871F1F, 0x871F1F, 1, false)

        return
      end

      if index > 3 then
        clubhouse.joinArea(index + 4,
          "<p align='center'><font size='14px'><a href='event:leaveTeamRed" .. index .. "'>" .. name .. "", nil,
          x[index + 3], y[index + 3], 150, 40, 0x871F1F, 0x871F1F, 1, false)
      else
        clubhouse.joinArea(index, "<p align='center'><font size='14px'><a href='event:leaveTeamRed" .. index ..
          "'>" .. name .. "", nil, x[index], y[index], 150, 40, 0x871F1F, 0x871F1F, 1, false)
      end
    elseif string.sub(c, 1, 12) == "leaveTeamRed" and playersRed[tonumber(string.sub(c, 13))].name == name then
      local isPlayerBanned = messagePlayerIsBanned(name)
      if isPlayerBanned then
        return
      end

      local index = tonumber(string.sub(c, 13))
      playerInGame[name] = false
      playersRed[index].name = ''

      if gameStats.threeTeamsMode then
        clubhouse.joinArea(threeTeamsMode.id[index],
          "<p align='center'><font size='14px'><a href='event:joinTeamRed" .. index .. "'>Join", nil,
          threeTeamsMode.x[index], threeTeamsMode.y[index], 150, 40, 0xE14747, 0xE14747, 1, false)

        return
      end

      if index > 3 then
        clubhouse.joinArea(index + 4, "<p align='center'><font size='14px'><a href='event:joinTeamRed" .. index .. "'>Join",
          nil, x[index + 3], y[index + 3], 150, 40, 0xE14747, 0xE14747, 1, false)
      else
        clubhouse.joinArea(index, "<p align='center'><font size='14px'><a href='event:joinTeamRed" .. index .. "'>Join", nil,
          x[index], y[index], 150, 40, 0xE14747, 0xE14747, 1, false)
      end
    elseif string.sub(c, 1, 12) == "joinTeamBlue" and playerInGame[name] == false and playersBlue[teamBlueIndex(tonumber(string.sub(c, 13)))].name == '' then
      local isPlayerBanned = messagePlayerIsBanned(name)
      if isPlayerBanned then
        return
      end

      local index = teamBlueIndex(tonumber(string.sub(c, 13)))
      playerInGame[name] = true
      playersBlue[index].name = name

      if gameStats.threeTeamsMode then
        clubhouse.joinArea(threeTeamsMode.id[index + 4],
          "<p align='center'><font size='14px'><a href='event:leaveTeamBlue" .. (index) .. "'>" .. name .. "", nil,
          threeTeamsMode.x[index + 4], threeTeamsMode.y[index + 4], 150, 40, 0x0B3356, 0x0B3356, 1, false)

        return
      end

      if index > 3 then
        clubhouse.joinArea(index + 7,
          "<p align='center'><font size='14px'><a href='event:leaveTeamBlue" .. (index + 3) .. "'>" .. name .. "", nil,
          x[index + 6], y[index + 6], 150, 40, 0x0B3356, 0x0B3356, 1, false)
      else
        clubhouse.joinArea(index + 3,
          "<p align='center'><font size='14px'><a href='event:leaveTeamBlue" .. (index + 3) .. "'>" .. name .. "", nil,
          x[index + 3], y[index + 3], 150, 40, 0x0B3356, 0x0B3356, 1, false)
      end
    elseif string.sub(c, 1, 13) == "leaveTeamBlue" and playersBlue[teamBlueIndex(tonumber(string.sub(c, 14)))].name == name then
      local isPlayerBanned = messagePlayerIsBanned(name)
      if isPlayerBanned then
        return
      end

      local index = teamBlueIndex(tonumber(string.sub(c, 14)))
      playerInGame[name] = false
      playersBlue[index].name = ''

      if gameStats.threeTeamsMode then
        clubhouse.joinArea(threeTeamsMode.id[index + 4],
          "<p align='center'><font size='14px'><a href='event:joinTeamBlue" .. (index) .. "'>Join", nil,
          threeTeamsMode.x[index + 4], threeTeamsMode.y[index + 4], 150, 40, 0x184F81, 0x184F81, 1, false)

        return
      end

      if index > 3 then
        clubhouse.joinArea(index + 7,
          "<p align='center'><font size='14px'><a href='event:joinTeamBlue" .. (index + 3) .. "'>Join", nil, x
          [index + 6], y[index + 6], 150, 40, 0x184F81, 0x184F81, 1, false)
      else
        clubhouse.joinArea(index + 3,
          "<p align='center'><font size='14px'><a href='event:joinTeamBlue" .. (index + 3) .. "'>Join", nil, x
          [index + 3], y[index + 3], 150, 40, 0x184F81, 0x184F81, 1, false)
      end
    elseif string.sub(c, 1, 14) == "joinTeamYellow" and playerInGame[name] == false and playersYellow[tonumber(string.sub(c, 15))].name == '' then
      local isPlayerBanned = messagePlayerIsBanned(name)
      if isPlayerBanned then
        return
      end

      local index = tonumber(string.sub(c, 15))
      playerInGame[name] = true
      playersYellow[index].name = name

      clubhouse.joinArea(index + 7,
        "<p align='center'><font size='14px'><a href='event:leaveTeamYellow" .. index .. "'>" .. name .. "", nil,
        x[index + 6], y[index + 6], 150, 40, 0xB57200, 0xB57200, 1, false)
    elseif string.sub(c, 1, 15) == "leaveTeamYellow" and playersYellow[tonumber(string.sub(c, 16))].name == name then
      local isPlayerBanned = messagePlayerIsBanned(name)
      if isPlayerBanned then
        return
      end

      local index = tonumber(string.sub(c, 16))
      playerInGame[name] = false
      playersYellow[index].name = ''

      clubhouse.joinArea(index + 7, "<p align='center'><font size='14px'><a href='event:joinTeamYellow" .. index .. "'>Join",
        nil, x[index + 6], y[index + 6], 150, 40, 0xF59E0B, 0xF59E0B, 1, false)
    elseif string.sub(c, 1, 13) == "joinTeamGreen" and playerInGame[name] == false and playersGreen[tonumber(string.sub(c, 14))].name == '' then
      local isPlayerBanned = messagePlayerIsBanned(name)
      if isPlayerBanned then
        return
      end

      local index = tonumber(string.sub(c, 14))
      playerInGame[name] = true
      playersGreen[index].name = name

      if gameStats.threeTeamsMode then
        clubhouse.joinArea(threeTeamsMode.id[index + 8],
          "<p align='center'><font size='14px'><a href='event:leaveTeamGreen" .. index .. "'>" .. name .. "", nil,
          threeTeamsMode.x[index + 8], threeTeamsMode.y[index + 8], 150, 40, 0x0C6346, 0x0C6346, 1, false)

        return
      end

      clubhouse.joinArea(index + 10,
        "<p align='center'><font size='14px'><a href='event:leaveTeamGreen" .. index .. "'>" .. name .. "", nil,
        x[index + 9], y[index + 9], 150, 40, 0x0C6346, 0x0C6346, 1, false)
    elseif string.sub(c, 1, 14) == "leaveTeamGreen" and playersGreen[tonumber(string.sub(c, 15))].name == name then
      local isPlayerBanned = messagePlayerIsBanned(name)
      if isPlayerBanned then
        return
      end

      local index = tonumber(string.sub(c, 15))
      playerInGame[name] = false
      playersGreen[index].name = ''

      if gameStats.threeTeamsMode then
        clubhouse.joinArea(threeTeamsMode.id[index + 8],
          "<p align='center'><font size='14px'><a href='event:joinTeamGreen" .. index .. "'>Join", nil,
          threeTeamsMode.x[index + 8], threeTeamsMode.y[index + 8], 150, 40, 0x109267, 0x109267, 1, false)

        return
      end

      clubhouse.joinArea(index + 10, "<p align='center'><font size='14px'><a href='event:joinTeamGreen" .. index .. "'>Join",
        nil, x[index + 9], y[index + 9], 150, 40, 0x109267, 0x109267, 1, false)
    end
  end

  if c == "menuOpen" then
    if panelOpenCooldown(name, c) then return end
    if profileState[name] then removeUITrophies(name) end
    closeRankingUI(name)
    clubhouse.menu(name)
  elseif c == "menuClose" then
    clubhouse.clear(name,"menu")
    clubhouse.launcher(name,23)
    clubhouse.restoreLobbyControls(name)
  elseif c == "howToPlay" then
    if panelOpenCooldown(name, c) then return end
    removeUITrophies(name)
    openRank[name] = false
    closeRankingUI(name)
    pagesList[name].helpPage = 1
    windowForHelp(name, pagesList[name].helpPage, playerLanguage[name].tr.nextMessage,
      playerLanguage[name].tr.previousMessage)
  elseif string.sub(c, 1, 8) == "nextHelp" then
    pagesList[name].helpPage = tonumber(string.sub(c, 9))
    windowForHelp(name, pagesList[name].helpPage, playerLanguage[name].tr.nextMessage,
      playerLanguage[name].tr.previousMessage)
  elseif string.sub(c, 1, 8) == "prevHelp" then
    pagesList[name].helpPage = tonumber(string.sub(c, 9))
    windowForHelp(name, pagesList[name].helpPage, playerLanguage[name].tr.nextMessage,
      playerLanguage[name].tr.previousMessage)
  elseif c == "credits" then
    if panelOpenCooldown(name, c) then return end
    removeUITrophies(name)
    openRank[name] = false
    closeRankingUI(name)
    clubhouse.document(name,"credits")
  elseif c == "realmode" then
    if panelOpenCooldown(name, c) then return end
    removeUITrophies(name)
    openRank[name] = false
    closeRankingUI(name)
    ui.addWindow(266, "" .. playerLanguage[name].tr.realModeRules .. "", name, 125, 60, 650, 300, 1, false, true,
      playerLanguage[name].tr.closeUIText)
  elseif c == "closeWindow" then
    closeAllWindows(name)
  elseif c == "roomadmin" then
    tfm.exec.chatMessage("<rose>/room *#volley0" .. name .. "<n>", name)
  elseif string.sub(c, 1, 4) == "sync" and USER_PERMISSIONS[name] and USER_PERMISSIONS[name] > 2 then
    local playerSync = string.sub(c, 5)

    if not tfm.get.room.playerList[playerSync] or playerSync:find("*",1,true) then
      tfm.exec.chatMessage("<bv>" .. clubhouse.escape(clubhouse.text(name,"sync.missing")) .. "<n>", name)
      windowUISync({ name })
    else
      closeAllWindows(name)
      tfm.exec.setPlayerSync(playerSync)
      tfm.exec.chatMessage("<bv>Set new player sync: " .. playerSync .. " selected by admin "..name.."<n>", nil)
    end
  elseif c == "openMode" and USER_PERMISSIONS[name] and USER_PERMISSIONS[name] > 1 then
    settingsMode[name] = true
    clubhouse.settings(name)
  elseif c:sub(1, 7) == "setMode" then
    local modes = getModesText()
    local index = tonumber(c:sub(8))

    if not index or not modes[index] then return end
    settingsMode[name] = false
    globalSettings.mode = modes[index]
    messageLog("<bv>The room has been set to " .. modes[index] .. ", selected by the admin " .. name .. "<n>")
    updateSettingsUI()
  elseif c == "closeMode" then
    settingsMode[name] = false
    clubhouse.settings(name)
  elseif c == "twoballs" and USER_PERMISSIONS[name] and USER_PERMISSIONS[name] > 1 then
    if globalSettings.twoBalls then
      globalSettings.twoBalls = false
      messageLog("<bv>The two balls command was disabled globally in the room, selected by the admin " .. name .. "<n>")
    else
      globalSettings.twoBalls = true
      messageLog("<bv>The two balls command was enabled globally in the room, selected by the admin " .. name .. "<n>")
      print("<bv>The two balls command was enabled globally in the room, selected by the admin " .. name .. "<n>")
    end
    updateSettingsUI()
  elseif c == "threeballs" and USER_PERMISSIONS[name] and USER_PERMISSIONS[name] > 1 then
    if globalSettings.threeBalls then
      globalSettings.threeBalls = false
      messageLog("<bv>The three balls on 3 teams mode command was disabled globally in the room, selected by the admin " ..
        name .. "<n>")
    else
      globalSettings.threeBalls = true
      messageLog("<bv>The three balls on 3 teams mode command was enabled globally in the room, selected by the admin " ..
        name .. "<n>")
      print("<bv>The three balls on 3 teams mode command was enabled globally in the room, selected by the admin " ..
        name .. "<n>")
    end
    updateSettingsUI()
  elseif c == "randomball" and USER_PERMISSIONS[name] and USER_PERMISSIONS[name] > 1 then
    if globalSettings.randomBall then
      globalSettings.randomBall = false
      messageLog("<bv>The random ball command was disabled globally in the room, selected by the admin " .. name .. "<n>")
    else
      globalSettings.randomBall = true
      print("<bv>The random ball command was enabled globally in the room, selected by the admin " .. name .. "<n>")
      messageLog("<bv>The random ball command was enabled globally in the room, selected by the admin " .. name .. "<n>")
    end
    updateSettingsUI()
  elseif c == "openMapType" and USER_PERMISSIONS[name] and USER_PERMISSIONS[name] > 1 then
    settingsMode[name] = true
    clubhouse.settings(name)
  elseif c:sub(1, 10) == "setMapType" and not gameStats.teamsMode and not gameStats.twoTeamsMode and not gameStats.realMode then
    local modes = getMapTypesText()
    local index = tonumber(c:sub(11))

    if not index or not modes[index] then return end
    settingsMode[name] = false
    globalSettings.mapType = string.lower(modes[index])
    messageLog("<bv>The map size in normal mode was set by " .. modes[index] .. " by the admin " .. name .. "<n>")
    updateSettingsUI()
  elseif c == "closeMapType" then
    settingsMode[name] = false
    clubhouse.settings(name)
  elseif string.sub(c, 1, 12) == 'nextSettings' then
    local page = tonumber(string.sub(c, 13))
    if page ~= 1 and page ~= 2 then return end
    settingsMode[name] = false
    pagePlayerSettings[name] = page

    updateSettingsUI(name)
  elseif string.sub(c, 1, 12) == 'prevSettings' then
    local page = tonumber(string.sub(c, 13))
    if page ~= 1 and page ~= 2 then return end
    settingsMode[name] = false
    pagePlayerSettings[name] = page

    updateSettingsUI(name)
  elseif c == "ranking" then
    openRankingUI(name)
  elseif string.sub(c, 1, 7) == "trophie" then
    local index = tonumber(string.sub(c, 8))
    showProfileTrophy(name, index)
  elseif c == "selectMap" then
    if panelOpenCooldown(name, c) then return end
    closeAllWindows(name)
    selectMapOpen[name] = true
    selectBallOpen[name] = false
    selectMapPage[name] = 1
    selectMapUI(name)
  elseif c == "selectBall" then
    if panelOpenCooldown(name, c) then return end
    closeAllWindows(name)
    selectBallOpen[name] = true
    selectMapOpen[name] = false
    local category=clubhouse.ballCategory(name)
    selectBallPage[name] = category.pages[category.selected] or 1
    selectBallUI(name)
  elseif string.sub(c, 1, 14) == "nextSelectBall" or string.sub(c, 1, 14) == "prevSelectBall" then
    local index = tonumber(string.sub(c, 15))
    selectBallPage[name] = index
    selectBallUI(name)
  elseif string.sub(c, 1, 7) == "setball" and customMapCommand[name] and not gameStats.realMode and mode == "startGame" and USER_PERMISSIONS[name] and USER_PERMISSIONS[name] > 1 then
    local index = tonumber(string.sub(c, 8))

    if index and balls[index] then
      clubhouse.selectionCooldown(name)

      gameStats.customBall = true
      gameStats.customBallId = index

      tfm.exec.chatMessage(" <bv>Ball: " .. balls[index].name ..
        " selected by " .. name .. " <n> ", nil)

      for name1, data in pairs(tfm.get.room.playerList) do
        if selectBallOpen[name1] then
          selectBallUI(name1)
        end
      end
    end
  elseif string.sub(c, 1, 13) == "nextSelectMap" or string.sub(c, 1, 13) == "prevSelectMap" then
    local index = tonumber(string.sub(c, 14))
    selectMapPage[name] = index
    selectMapUI(name)
  elseif string.sub(c, 1, 3) == "map" then
    tfm.exec.chatMessage('<bv>' .. string.sub(c, 4) .. '<n>', name)
  elseif string.sub(c, 1, 7) == "votemap" and canVote[name] and not gameStats.realMode and mode == "startGame" then
    local index = tonumber(string.sub(c, 8))
    local maps = configSelectMap()

    if not index or not maps[index] then return end
    if mapsVotes[index] == nil then
      mapsVotes[index] = 0
    end

    mapsVotes[index] = mapsVotes[index] + 1
    canVote[name] = false
    gameStats.totalVotes = gameStats.totalVotes + 1
    verifyMostMapVoted()

    for name1, data in pairs(tfm.get.room.playerList) do
      if selectMapPage[name] == selectMapPage[name1] and selectMapOpen[name1] then
        selectMapUI(name1)
      end
    end

    tfm.exec.chatMessage(
      "<bv>" ..
      name ..
      " voted for the " ..
      maps[index][3] ..
      " map (" ..
      tostring(mapsVotes[index]) .. " votes), type !maps to see the maps list and to vote !votemap (number)<n>",
      nil)
  elseif string.sub(c, 1, 9) == "randommap" and not gameStats.realMode and USER_PERMISSIONS[name] and USER_PERMISSIONS[name] > 1 then
    if globalSettings.randomMap then
      globalSettings.randomMap = false
      print("<bv>The random map command was disabled globally in the room, selected by the admin " .. name .. "<n>")
      messageLog("<bv>The random map command was disabled globally in the room, selected by the admin " .. name .. "<n>")
    else
      globalSettings.randomMap = true
      print("<bv>The random map command was enabled globally in the room, selected by the admin " .. name .. "<n>")
      messageLog("<bv>The random map command was enabled globally in the room, selected by the admin " .. name .. "<n>")
    end

    updateSettingsUI()
  elseif c == "consumables" then
    if globalSettings.consumables then
      globalSettings.consumables = false

      messageLog("<bv>The consumables command has been disabled globally by the admin " .. name .. "<n>")
    else
      globalSettings.consumables = true

      messageLog("<bv>The consumables command has been enabled globally by the admin " .. name .. "<n>")
    end

    updateSettingsUI()
  elseif string.sub(c, 1, 6) == "setmap" and customMapCommand[name] and not gameStats.realMode and mode == "startGame" and USER_PERMISSIONS[name] and USER_PERMISSIONS[name] > 1 then
    local index = tonumber(string.sub(c, 7))
    local maps = configSelectMap()
    if not index or not maps[index] then return end

    clubhouse.selectionCooldown(name)

    gameStats.isCustomMap = true
    gameStats.customMapIndex = index

    tfm.exec.chatMessage(
      '<bv>' ..
      maps[gameStats.customMapIndex][3] ..
      ' map (created by ' .. maps[gameStats.customMapIndex][4] .. ') selected by admin ' .. name .. '<n>', nil)
    print('<bv>' ..
      maps[gameStats.customMapIndex][3] ..
      ' map (created by ' .. maps[gameStats.customMapIndex][4] .. ') selected by admin ' .. name .. '<n>')

    for name1, data in pairs(tfm.get.room.playerList) do
      if selectMapOpen[name1] then
        selectMapUI(name1)
      end
    end
  elseif c == "settings" and USER_PERMISSIONS[name] and USER_PERMISSIONS[name] > 1 then
    if panelOpenCooldown(name, c) then return end
    closeRankingUI(name)
    removeUITrophies(name)
    closeAllWindows(name)
    settings[name] = true

    updateSettingsUI(name)
  elseif c == "minimalist" then
    if globalSettings.minimalist then
      globalSettings.minimalist = false

      tfm.exec.chatMessage('<bv>Minimalist mode for maps disabled by admin '..name..'<n>', nil)
      print('<bv>Minimalist mode for maps disabled by admin '..name..'<n>')
    else
      globalSettings.minimalist = true

      tfm.exec.chatMessage('<bv>Minimalist mode for maps enabled by admin '..name..'<n>', nil)
      print('<bv>Minimalist mode for maps enabled by admin '..name..'<n>')
    end

    updateSettingsUI(name)
  elseif string.sub(c, 1, 10) == "setkeybind" then
    local key = string.sub(c, 12, 13)
    local bind = string.sub(c, 14)
    -- bind new key, unbind previous
    system.bindKeyboard(name, key, true, true)

    system.bindKeyboard(name, key, true, true)
    return 1
  end
end
