function eventTextAreaCallback(id, name, c)
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
        ui.addTextArea(threeTeamsMode.id[index], "<p align='center'><font size='14px'><a href='event:leaveTeamRed"..index.."'>"..name.."", nil, threeTeamsMode.x[index], threeTeamsMode.y[index], 150, 40, 0x871F1F, 0x871F1F, 1, false)

        return
      end

      if index > 3 then
        ui.addTextArea(index + 4, "<p align='center'><font size='14px'><a href='event:leaveTeamRed"..index.."'>"..name.."", nil, x[index + 3], y[index + 3], 150, 40, 0x871F1F, 0x871F1F, 1, false)
      else
        ui.addTextArea(index, "<p align='center'><font size='14px'><a href='event:leaveTeamRed"..index.."'>"..name.."", nil, x[index], y[index], 150, 40, 0x871F1F, 0x871F1F, 1, false)
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
        ui.addTextArea(threeTeamsMode.id[index], "<p align='center'><font size='14px'><a href='event:joinTeamRed"..index.."'>Join", nil, threeTeamsMode.x[index], threeTeamsMode.y[index], 150, 40, 0xE14747, 0xE14747, 1, false)

        return
      end

      if index > 3 then
        ui.addTextArea(index + 4, "<p align='center'><font size='14px'><a href='event:joinTeamRed"..index.."'>Join", nil, x[index + 3], y[index + 3], 150, 40, 0xE14747, 0xE14747, 1, false)
      else
        ui.addTextArea(index, "<p align='center'><font size='14px'><a href='event:joinTeamRed"..index.."'>Join", nil, x[index], y[index], 150, 40, 0xE14747, 0xE14747, 1, false)
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
        ui.addTextArea(threeTeamsMode.id[index + 4], "<p align='center'><font size='14px'><a href='event:leaveTeamBlue"..(index).."'>"..name.."", nil, threeTeamsMode.x[index + 4], threeTeamsMode.y[index + 4], 150, 40, 0x0B3356, 0x0B3356, 1, false)

        return
      end

      if index > 3 then
        ui.addTextArea(index + 7, "<p align='center'><font size='14px'><a href='event:leaveTeamBlue"..(index + 3).."'>"..name.."", nil, x[index + 6], y[index + 6], 150, 40, 0x0B3356, 0x0B3356, 1, false)
      else
        ui.addTextArea(index + 3, "<p align='center'><font size='14px'><a href='event:leaveTeamBlue"..(index + 3).."'>"..name.."", nil, x[index + 3], y[index + 3], 150, 40, 0x0B3356, 0x0B3356, 1, false)
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

        ui.addTextArea(threeTeamsMode.id[index + 4], "<p align='center'><font size='14px'><a href='event:joinTeamBlue"..(index).."'>Join", nil, threeTeamsMode.x[index + 4], threeTeamsMode.y[index + 4], 150, 40, 0x184F81, 0x184F81, 1, false)

        return
      end

      if index > 3 then
        ui.addTextArea(index + 7, "<p align='center'><font size='14px'><a href='event:joinTeamBlue"..(index + 3).."'>Join", nil, x[index + 6], y[index + 6], 150, 40, 0x184F81, 0x184F81, 1, false)
      else
        ui.addTextArea(index + 3, "<p align='center'><font size='14px'><a href='event:joinTeamBlue"..(index + 3).."'>Join", nil, x[index + 3], y[index + 3], 150, 40, 0x184F81, 0x184F81, 1, false)
      end
    elseif string.sub(c, 1, 14) == "joinTeamYellow" and playerInGame[name] == false and playersYellow[tonumber(string.sub(c, 15))].name == '' then
      local isPlayerBanned = messagePlayerIsBanned(name)
      if isPlayerBanned then
        return
      end

      local index = tonumber(string.sub(c, 15))
      playerInGame[name] = true
      playersYellow[index].name = name

      ui.addTextArea(index + 7, "<p align='center'><font size='14px'><a href='event:leaveTeamYellow"..index.."'>"..name.."", nil, x[index + 6], y[index + 6], 150, 40, 0xB57200, 0xB57200, 1, false)
    elseif string.sub(c, 1, 15) == "leaveTeamYellow" and playersYellow[tonumber(string.sub(c, 16))].name == name then
      local isPlayerBanned = messagePlayerIsBanned(name)
      if isPlayerBanned then
        return
      end

      local index = tonumber(string.sub(c, 16))
      playerInGame[name] = false
      playersYellow[index].name = ''

      ui.addTextArea(index + 7, "<p align='center'><font size='14px'><a href='event:joinTeamYellow"..index.."'>Join", nil, x[index + 6], y[index + 6], 150, 40, 0xF59E0B, 0xF59E0B, 1, false)
    elseif string.sub(c, 1, 13) == "joinTeamGreen" and playerInGame[name] == false and playersGreen[tonumber(string.sub(c, 14))].name == '' then
      local isPlayerBanned = messagePlayerIsBanned(name)
      if isPlayerBanned then
        return
      end

      local index = tonumber(string.sub(c, 14))
      playerInGame[name] = true
      playersGreen[index].name = name

      if gameStats.threeTeamsMode then
        ui.addTextArea(threeTeamsMode.id[index + 8], "<p align='center'><font size='14px'><a href='event:leaveTeamGreen"..index.."'>"..name.."", nil, threeTeamsMode.x[index + 8], threeTeamsMode.y[index + 8], 150, 40, 0x0C6346, 0x0C6346, 1, false)

        return
      end

      ui.addTextArea(index + 10, "<p align='center'><font size='14px'><a href='event:leaveTeamGreen"..index.."'>"..name.."", nil, x[index + 9], y[index + 9], 150, 40, 0x0C6346, 0x0C6346, 1, false)
    elseif string.sub(c, 1, 14) == "leaveTeamGreen" and playersGreen[tonumber(string.sub(c, 15))].name == name then
      local isPlayerBanned = messagePlayerIsBanned(name)
      if isPlayerBanned then
        return
      end

      local index = tonumber(string.sub(c, 15))
      playerInGame[name] = false
      playersGreen[index].name = ''

      if gameStats.threeTeamsMode then
        ui.addTextArea(threeTeamsMode.id[index + 8], "<p align='center'><font size='14px'><a href='event:joinTeamGreen"..index.."'>Join", nil, threeTeamsMode.x[index + 8], threeTeamsMode.y[index + 8], 150, 40, 0x109267, 0x109267, 1, false)

        return
      end

      ui.addTextArea(index + 10, "<p align='center'><font size='14px'><a href='event:joinTeamGreen"..index.."'>Join", nil, x[index + 9], y[index + 9], 150, 40, 0x109267, 0x109267, 1, false)
    end
  end

  if c == "menuOpen" then
    ui.addWindow(23, "<p align='center'><font size='13px'><a href='event:menuClose'>Menu</a>"..playerLanguage[name].tr.menuOpenText, name, 5, 15, 200, 120, 0.2, false, false, _)
  elseif c == "menuClose" then
    ui.addWindow(23, "<p align='center'><font size='13px'><a href='event:menuOpen'>Menu", name, 5, 15, 100, 30, 0.2, false, false, _)
  elseif c == "howToPlay" then
    removeUITrophies(name)
    openRank[name] = false
    closeRankingUI(name)
    pagesList[name].helpPage = 1
    windowForHelp(name, pagesList[name].helpPage, playerLanguage[name].tr.nextMessage, playerLanguage[name].tr.previousMessage)
  elseif string.sub(c, 1, 8) == "nextHelp" then
    pagesList[name].helpPage = tonumber(string.sub(c, 9))
    windowForHelp(name, pagesList[name].helpPage, playerLanguage[name].tr.nextMessage, playerLanguage[name].tr.previousMessage)
  elseif string.sub(c, 1, 8) == "prevHelp" then
    pagesList[name].helpPage = tonumber(string.sub(c, 9))
    windowForHelp(name, pagesList[name].helpPage, playerLanguage[name].tr.nextMessage, playerLanguage[name].tr.previousMessage)
  elseif c == "credits" then
    removeUITrophies(name)
    openRank[name] = false
    closeRankingUI(name)
    ui.addWindow(24, ""..playerLanguage[name].tr.creditsTitle..""..playerLanguage[name].tr.creditsText.."", name, 125, 60, 650, 300, 1, false, true, playerLanguage[name].tr.closeUIText)
  elseif c == "realmode" then
    removeUITrophies(name)
    openRank[name] = false
    closeRankingUI(name)
    ui.addWindow(266, ""..playerLanguage[name].tr.realModeRules.."", name, 125, 60, 650, 300, 1, false, true, playerLanguage[name].tr.closeUIText)
  elseif c == "closeWindow" then
    closeAllWindows(name)
  elseif c == "getAdmin" then
    admins[name] = true
    messageLog("<bv>"..name.." was faster to click and is now an admin!<n>")
    closeWindow(20, nil)
  elseif c == "roomadmin" then
    tfm.exec.chatMessage("<rose>/room *#volley0"..name.."<n>", name)
  elseif string.sub(c, 1, 4) == "sync" then
    local playerSync = string.sub(c, 5)

    print(playerLeft[name])

    if playerLeft[playerSync] then
      tfm.exec.chatMessage("<bv>Player not found, choose another player<n>", name)
      windowUISync(name)
    else
      closeWindow(24, name)
      tfm.exec.setPlayerSync(playerSync)
      tfm.exec.chatMessage("<bv>Set new player sync: "..playerSync.."<n>", nil)
    end
  elseif c == "openMode" and admins[name] then
    settingsMode[name] = true
    local modes = getActionsModes()
    local str = ''
    for i = 1, #modes do
      str = ""..str..""..modes[i].."<br>"
    end
    ui.addWindow(25, "<p align='center'><font size='11px'><a href='event:closeMode'>Select a mode</a><br><br>"..str.."", name, 665, 100, 100, 110, 1, false, false)
  elseif c:sub(1, 7) == "setMode" then
    local modes = getModesText()
    local index = tonumber(c:sub(8))

    globalSettings.mode = modes[index]
    messageLog("<bv>The room has been set to "..modes[index]..", selected by the admin "..name.."<n>")
    updateSettingsUI()
  elseif c == "closeMode" then
    settingsMode[name] = false
    ui.addWindow(25, "<p align='center'><font size='11px'><a href='event:openMode'>Select a mode</a>", name, 665, 100, 100, 30, 1, false, false)
  elseif c == "twoballs" and admins[name] then
    if globalSettings.twoBalls then
      globalSettings.twoBalls = false
      messageLog("<bv>The two balls command was disabled globally in the room, selected by the admin "..name.."<n>")
    else
      globalSettings.twoBalls = true
      messageLog("<bv>The two balls command was enabled globally in the room, selected by the admin "..name.."<n>")
      print("<bv>The two balls command was enabled globally in the room, selected by the admin "..name.."<n>")
    end
    updateSettingsUI()
  elseif c == "threeballs" and admins[name] then
    if globalSettings.threeBalls then
      globalSettings.threeBalls = false
      messageLog("<bv>The three balls on 3 teams mode command was disabled globally in the room, selected by the admin "..name.."<n>")
    else
      globalSettings.threeBalls = true
      messageLog("<bv>The three balls on 3 teams mode command was enabled globally in the room, selected by the admin "..name.."<n>")
      print("<bv>The three balls on 3 teams mode command was enabled globally in the room, selected by the admin "..name.."<n>")
    end
    updateSettingsUI()
  elseif c == "randomball" and admins[name] then
    if globalSettings.randomBall then
      globalSettings.randomBall = false
      messageLog("<bv>The random ball command was disabled globally in the room, selected by the admin "..name.."<n>")
    else
      globalSettings.randomBall = true
      print("<bv>The random ball command was enabled globally in the room, selected by the admin "..name.."<n>")
      messageLog("<bv>The random ball command was enabled globally in the room, selected by the admin "..name.."<n>")
    end
    updateSettingsUI()
  elseif c == "openMapType" and admins[name] then
    settingsMode[name] = true
    local modes = getMapTypesActions()
    local str = ''
    for i = 1, #modes do
      str = ""..str..""..modes[i].."<br>"
    end
    ui.addWindow(25, "<p align='center'><font size='11px'><a href='event:closeMapType'>Select map</a><br><br>"..str.."", name, 665, 100, 100, 100, 1, false, false)
  elseif c:sub(1, 10) == "setMapType" and not gameStats.teamsMode and not gameStats.twoTeamsMode and not gameStats.realMode then
    local modes = getMapTypesText()
    local index = tonumber(c:sub(11))

    globalSettings.mapType = string.lower(modes[index])
    messageLog("<bv>The map size in normal mode was set by "..modes[index].." by the admin "..name.."<n>")
    updateSettingsUI()
  elseif c == "closeMapType" then
    settingsMode[name] = false
    ui.addWindow(25, "<p align='center'><font size='11px'><a href='event:openMapType'>Select map</a>", name, 665, 100, 100, 30, 1, false, false)
  elseif string.sub(c, 1, 12) == 'nextSettings' then
    local page = tonumber(string.sub(c, 13))
    pagePlayerSettings[name] = page

    updateSettingsUI(name)
  elseif string.sub(c, 1, 12) == 'prevSettings' then
    local page = tonumber(string.sub(c, 13))
    pagePlayerSettings[name] = page

    updateSettingsUI(name)
  elseif c == "ranking" then
    removeUITrophies(name)
    openRank[name] = true
    ui.addWindow(24, "<p align='center'><font size='16px'>", name, 125, 60, 650, 300, 1, false, true, playerLanguage[name].tr.closeUIText)
    ui.addTextArea(9999543, "<p align='center'>Room Ranking", name, 17, 168, 100, 20, 0x142b2e, 0x8a583c, 1, true)
    ui.addTextArea(9999544, "<p align='center'><n2>Global Ranking<n>", name, 17, 268, 100, 18, 0x142b2e, 0x8a583c, 1, true)
    showMode(playerRankingMode[name], name)
  elseif c == "Normal mode" then
    playerRankingMode[name] = "Normal mode"

    showMode(playerRankingMode[name], name)
  elseif c == "4 teams mode" then
    playerRankingMode[name] = "4 teams mode"

    showMode(playerRankingMode[name], name)
  elseif c == "3 teams mode" then
    playerRankingMode[name] = "3 teams mode"

    showMode(playerRankingMode[name], name)
  elseif c == "2 teams mode" then
    playerRankingMode[name] = "2 teams mode"

    showMode(playerRankingMode[name], name)
  elseif c == "Real mode" then
    playerRankingMode[name] = "Real mode"

    showMode(playerRankingMode[name], name)
  elseif string.sub(c, 1, 8) == "prevRank" then
    local index = tonumber(string.sub(c, 9))

    if playerRankingMode[name] == "Normal mode" then
      pageNormalMode[name] = index
      showMode(playerRankingMode[name], name)
    elseif playerRankingMode[name] == "4 teams mode" then
      pageFourTeamsMode[name] = index
      showMode(playerRankingMode[name], name)
    elseif playerRankingMode[name] == "2 teams mode" then
      pageTwoTeamsMode[name] = index
      showMode(playerRankingMode[name], name)
    elseif playerRankingMode[name] == "Real mode" then
      pageRealMode[name] = index
      showMode(playerRankingMode[name], name)
    end
  elseif string.sub(c, 1, 8) == "nextRank" then
    local index = tonumber(string.sub(c, 9))

    if playerRankingMode[name] == "Normal mode" then
      pageNormalMode[name] = index
      showMode(playerRankingMode[name], name)
    elseif playerRankingMode[name] == "4 teams mode" then
      pageFourTeamsMode[name] = index
      showMode(playerRankingMode[name], name)
    elseif playerRankingMode[name] == "2 teams mode" then
      pageTwoTeamsMode[name] = index
      showMode(playerRankingMode[name], name)
    elseif playerRankingMode[name] == "Real mode" then
      pageRealMode[name] = index
      showMode(playerRankingMode[name], name)
    end
  elseif string.sub(c, 1, 7) == "trophie" then
    local index = tonumber(string.sub(c, 8))

    tfm.exec.chatMessage("<ce>"..playerLanguage[name].tr.msgsTrophies[index].."<n>", name)
    print("<ce>"..playerLanguage[name].tr.msgsTrophies[index].."<n>")

    if playerAchievements[name][index].quantity >= 1 then
      removePlayerTrophy(name)
      closeAllWindows(name)
      playerTrophyImage[name] = tfm.exec.addImage(playerAchievements[name][index].image, "$"..name, -20, -105, nil)
      tfm.exec.playEmote(name, 0)
      removePlayerTrophyImage(name)
    end
  elseif c == "selectMap" then
    closeAllWindows(name)
    ui.addWindow(24, "<p align='center'><font size='16px'>"..playerLanguage[name].tr.mapSelect.."", name, 125, 60, 650, 300, 1, false, true, playerLanguage[name].tr.closeUIText)
    selectMapOpen[name] = true
    selectMapPage[name] = 1
    selectMapUI(name)
  elseif string.sub(c, 1, 13) == "nextSelectMap" or string.sub(c, 1, 13) == "prevSelectMap" then
    local index = tonumber(string.sub(c, 14))
    selectMapPage[name] = index
    selectMapUI(name)
  elseif string.sub(c, 1, 3) == "map" then
    tfm.exec.chatMessage('<bv>'..string.sub(c, 4)..'<n>', name)
  elseif string.sub(c, 1, 7) == "votemap" and canVote[name] and not gameStats.realMode and mode == "startGame" then
    local index = tonumber(string.sub(c, 8))
    local maps = configSelectMap()

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

    tfm.exec.chatMessage("<bv>"..name.." voted for the "..maps[index][3].." map ("..tostring(mapsVotes[index]).." votes), type !maps to see the maps list and to vote !votemap (number)<n>", nil)
  elseif string.sub(c, 1, 9) == "randommap" and not gameStats.realMode and admins[name] then
    if globalSettings.randomMap then
      globalSettings.randomMap = false
      print("<bv>The random map command was disabled globally in the room, selected by the admin "..name.."<n>")
      messageLog("<bv>The random map command was disabled globally in the room, selected by the admin "..name.."<n>")
    else
      globalSettings.randomMap = true
      print("<bv>The random map command was enabled globally in the room, selected by the admin "..name.."<n>")
      messageLog("<bv>The random map command was enabled globally in the room, selected by the admin "..name.."<n>")
    end

    updateSettingsUI()
  elseif c == "consumables" then
    if globalSettings.consumables then
      globalSettings.consumables = false

      messageLog("<bv>The consumables command has been disabled globally by the admin "..name.."<n>")
    else
      globalSettings.consumables = true

      messageLog("<bv>The consumables command has been enabled globally by the admin "..name.."<n>")
    end

    updateSettingsUI()
  elseif string.sub(c, 1, 6)  == "setmap" and customMapCommand[name] and not gameStats.realMode and mode == "startGame" and admins[name] then
    local index = tonumber(string.sub(c, 7))
    local maps = configSelectMap()

    customMapCommand[name] = false

    customMapCommandDelay = addTimer(function(i)
      if i == 1 then
        customMapCommand[name] = true
      end
    end, 2000, 1, "customMapCommandDelay")

    gameStats.isCustomMap = true
    gameStats.customMapIndex = index

    tfm.exec.chatMessage('<bv>'..maps[gameStats.customMapIndex][3]..' map (created by '..maps[gameStats.customMapIndex][4]..') selected by admin '..name..'<n>', nil)
    print('<bv>'..maps[gameStats.customMapIndex][3]..' map (created by '..maps[gameStats.customMapIndex][4]..') selected by admin '..name..'<n>')

    for name1, data in pairs(tfm.get.room.playerList) do
      if selectMapOpen[name1] then
        selectMapUI(name1)
      end
    end
  elseif c == "settings" and admins[name] then
    closeRankingUI(name)
    removeUITrophies(name)
    settings[name] = true

    updateSettingsUI(name)
  end
end