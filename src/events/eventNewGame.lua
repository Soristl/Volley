function eventNewGame()
  if lobbyTransition.blocksInput() then lobbyTransition.onMapLoaded();return end
  groundProfile.reset()
  mapBackgrounds.newGame()
  gameBalls.forget()
  showCrownToAllPlayers()
  clubhouse.ballSkins.reset()
  clubhouse.newGame()
  if firstRun then
    local config, reason = readLobbyConfig()
    if not config then
      tfm.exec.chatMessage("<r>Lobby configuration error: " .. reason .. ". Waiting for valid XML.<n>", nil)
      return
    end
    initUsersPermissions(config)
    lobbyMapConfig(config)
    firstRun = false
    if roomCreator.pendingName then
      local pendingName = roomCreator.pendingName
      roomCreator.pendingName = nil
      assignRoomCreator(pendingName)
    end
    if not roomCreator.name then
      initializeRoomCreator()
    end
  end

  if autosync then refletzSyncSystem() end

  if gameState.phase == "gameStart" then
    if gameplayMapMatches() then
      if not (globalSettings.minimalist and globalSettings.minimalistToggleMap) then
        if mapBackgrounds.prepare() then return end
        finishGameplayMapLoad()
      end
    else
      return
    end
    if globalSettings.minimalist and globalSettings.minimalistToggleMap then
      globalSettings.minimalistToggleMap = false

      tfm.exec.chatMessage("<ch>Minimalist mode is enabled, reloading the map to complete the settings.<n>", nil)

      local loadedXML = tfm.get.room.xmlMapInfo.xml
      local sourceTarget = gameState.map.sourceTarget
      addMapLoadTimer(function(i)
        loadGameplayMap(loadedXML, sourceTarget)
      end, 3000, 1)
    end
    showTheScore()
    local maps = (gameStats.teamsMode or gameStats.twoTeamsMode) and customMapsFourTeamsMode
      or gameStats.threeTeamsMode and customMapsThreeTeamsMode or customMaps
    if gameStats.isCustomMap and gameStats.customMapIndex >= 1 then
      ui.setMapName("<j>" .. maps[gameStats.customMapIndex][4] .. "<n>")
    elseif gameStats.totalVotes >= 2 then
      ui.setMapName("<j>" .. maps[gameStats.mapIndexSelected][4] .. "<n>")
    else
      ui.setMapName("<j>Refletz#6472<n>")
    end
  end
end
