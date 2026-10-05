do
-- Team layout and colors are shared by join and leave; the guard owns validation.
local function applyTeamCallback(name, request)
  if messagePlayerIsBanned(name) then return end
  local joining = request.action == "join"
  local team, index = request.team, request.index
  local id, px, py, color, callbackIndex = nil, nil, nil, nil, index
  if gameStats.threeTeamsMode and team ~= "Yellow" then
    local offset = team == "Red" and 0 or team == "Blue" and 4 or 8
    id, px, py = threeTeamsMode.id[index+offset], threeTeamsMode.x[index+offset], threeTeamsMode.y[index+offset]
  else
    local position
    if team == "Red" then
      id = index > 3 and index+4 or index
      position = index > 3 and index+3 or index
    elseif team == "Blue" then
      id = index > 3 and index+7 or index+3
      position = index > 3 and index+6 or index+3
      callbackIndex = index+3
    elseif team == "Yellow" then id,position = index+7,index+6
    else id,position = index+10,index+9 end
    px,py = x[position],y[position]
  end
  if team == "Red" then color = joining and 0x871F1F or 0xE14747
  elseif team == "Blue" then color = joining and 0x0B3356 or 0x184F81
  elseif team == "Yellow" then color = joining and 0xB57200 or 0xF59E0B
  else color = joining and 0x0C6346 or 0x109267 end
  playerInGame[name] = joining
  request.slot.name = joining and name or ""
  local nextAction = joining and "leave" or "join"
  clubhouse.joinArea(id,"<p align='center'><font size='14px'><a href='event:" .. nextAction .. "Team" .. team .. callbackIndex .. "'>" .. (joining and name or "Join"),
    nil,px,py,150,40,color,color,1,false)
end

-- 2s anti-spam cooldown per panel-opening button (closing stays instant)
local panelOpening = {menuOpen=true,howToPlay=true,credits=true,realmode=true,
  selectMap=true,selectBall=true,settings=true}
local function panelOpenBlocked(name, panel)
  local times = panelOpenTime[name]
  local lastOpen = times and times[panel]
  return lastOpen and os.time() - lastOpen < 2000
end

function eventTextAreaCallback(id, name, c)
  if type(name) ~= "string" or not tfm.get.room.playerList[name] or playerBan[name] or playerLeft[name] then return end
  local blocked, teamRequest = clubhouse.guardCallback(name,c)
  if blocked then return end
  if c:sub(1,10)=="pageInput:" then clubhouse.pageInputCallback(name,c);return end
  local closing=c=="closeWindow" or c=="menuClose" or c=="profileClose" or c=="rankingClose" or c=="ballCategoriesClose"
  -- Check both personal delays before recording an accepted opening.
  -- A rejected retry must not postpone this player's next permitted click.
  if panelOpening[c] and panelOpenBlocked(name,c) then return end
  if not clubhouse.allowInput(name,closing,c) then return end
  if panelOpening[c] then
    panelOpenTime[name] = panelOpenTime[name] or {}
    panelOpenTime[name][c] = os.time()
  end
  if teamRequest then applyTeamCallback(name,teamRequest);return end
  if c=="chooseDefaultMap" or c=="clearDefaultMap" or c=="returnDefaultSettings" or c:match("^setDefaultMap:") then clubhouse.defaultMapCallback(name,c);return end
  if c=='toggleMapBackground' or c=='toggleCourtIndicator' then
    if not settings[name] or pagePlayerSettings[name]~=3 or not (clubhouse.views[name] and clubhouse.views[name].settings) then return end
    if c=='toggleMapBackground' then mapBackgrounds.toggleHidden(name)
    else mapBackgrounds.toggleBorders(name) end
    clubhouse.personalDisplayOptions(name)
    return
  end
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
  if c == "menuOpen" then
    if profileState[name] then removeUITrophies(name) end
    closeRankingUI(name)
    clubhouse.menu(name)
  elseif c == "menuClose" then
    clubhouse.clear(name,"menu")
    clubhouse.launcher(name,23)
    clubhouse.restoreLobbyControls(name)
  elseif c == "howToPlay" then
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
    removeUITrophies(name)
    openRank[name] = false
    closeRankingUI(name)
    clubhouse.document(name,"credits")
  elseif c == "realmode" then
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
      if not requestPlayerSync(playerSync, name) then return end
      closeAllWindows(name)
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
    if gameState.phase == 'startGame' and not gameStats.threeTeamsMode then
      gameStats.setMapName = globalSettings.mapType
      refreshMapSizeSelection()
    end
    messageLog("<bv>The map size in normal mode was set by " .. modes[index] .. " by the admin " .. name .. "<n>")
    updateSettingsUI()
  elseif c == "closeMapType" then
    settingsMode[name] = false
    clubhouse.settings(name)
  elseif string.sub(c, 1, 12) == 'nextSettings' then
    local page = tonumber(string.sub(c, 13))
    if page ~= 1 and page ~= 2 and page ~= 3 and page ~= 4 then return end
    if (USER_PERMISSIONS[name] or 1)<2 and page~=3 then return end
    settingsMode[name] = false
    pagePlayerSettings[name] = page

    updateSettingsUI(name)
  elseif string.sub(c, 1, 12) == 'prevSettings' then
    local page = tonumber(string.sub(c, 13))
    if page ~= 1 and page ~= 2 and page ~= 3 and page ~= 4 then return end
    if (USER_PERMISSIONS[name] or 1)<2 and page~=3 then return end
    settingsMode[name] = false
    pagePlayerSettings[name] = page

    updateSettingsUI(name)
  elseif c == "ranking" then
    openRankingUI(name)
  elseif string.sub(c, 1, 7) == "trophie" then
    local index = tonumber(string.sub(c, 8))
    showProfileTrophy(name, index)
  elseif c == "selectMap" then
    closeAllWindows(name, true)
    selectMapOpen[name] = true
    selectBallOpen[name] = false
    selectMapPage[name] = 1
    selectMapUI(name)
  elseif c == "selectBall" then
    closeAllWindows(name, true)
    selectBallOpen[name] = true
    selectMapOpen[name] = false
    local category=clubhouse.ballCategory(name)
    selectBallPage[name] = category.pages[category.selected] or 1
    selectBallUI(name)
  elseif string.sub(c, 1, 14) == "nextSelectBall" or string.sub(c, 1, 14) == "prevSelectBall" then
    local index = tonumber(string.sub(c, 15))
    selectBallPage[name] = index
    selectBallUI(name)
  elseif string.sub(c, 1, 7) == "setball" and customMapCommand[name] and not gameStats.realMode and gameState.phase == "startGame" and USER_PERMISSIONS[name] and USER_PERMISSIONS[name] > 1 then
    local index = tonumber(string.sub(c, 8))

    if index and balls[index] then
      clubhouse.selectionCooldown(name)

      gameStats.customBall = true
      gameStats.customBallId = index

      tfm.exec.chatMessage(" <bv>Ball: " .. balls[index].name ..
        " selected by " .. name .. " <n> ", nil)

      clubhouse.refreshSelectorActions(true)
    end
  elseif string.sub(c, 1, 13) == "nextSelectMap" or string.sub(c, 1, 13) == "prevSelectMap" then
    local index = tonumber(string.sub(c, 14))
    selectMapPage[name] = index
    selectMapUI(name)
  elseif string.sub(c, 1, 3) == "map" then
    tfm.exec.chatMessage('<bv>' .. string.sub(c, 4) .. '<n>', name)
  elseif string.sub(c, 1, 7) == "votemap" and canVote[name] and not gameStats.realMode and gameState.phase == "startGame" then
    local index = tonumber(string.sub(c, 8))
    local maps = configSelectMap()

    if not index or not maps[index] or not isMapAvailable(index) then return end
    if mapsVotes[index] == nil then
      mapsVotes[index] = 0
    end

    mapsVotes[index] = mapsVotes[index] + 1
    canVote[name] = false
    gameStats.totalVotes = gameStats.totalVotes + 1
    verifyMostMapVoted()

    clubhouse.refreshMapVotes(index,name)

    tfm.exec.chatMessage(
      "<bv>" ..
      name ..
      " voted for the " ..
      maps[index][3] ..
      " map (" ..
      tostring(mapsVotes[index]) .. " votes), type !maps to see the maps list and to vote !votemap (number)<n>",
      nil)
  elseif c == "randommap" and not gameStats.realMode and USER_PERMISSIONS[name] and USER_PERMISSIONS[name] > 1 then
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
  elseif string.sub(c, 1, 6) == "setmap" and customMapCommand[name] and not gameStats.realMode and gameState.phase == "startGame" and USER_PERMISSIONS[name] and USER_PERMISSIONS[name] > 1 then
    local index = tonumber(string.sub(c, 7))
    local maps = configSelectMap()
    if not index or not maps[index] or not isMapAvailable(index) then return end

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

    clubhouse.refreshSelectorActions(false)
  elseif c == "settings" then
    closeAllWindows(name, true)
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
end
