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
    if gameStats.teamsMode or gameStats.twoTeamsMode then
      if gameStats.isCustomMap and gameStats.customMapIndex >= 1 then
        ui.setMapName("<j>" .. customMapsFourTeamsMode[gameStats.customMapIndex][4] .. "<n>")

        return
      end

      if gameStats.totalVotes >= 2 then
        ui.setMapName("<j>" .. customMapsFourTeamsMode[gameStats.mapIndexSelected][4] .. "<n>")

        return
      end

      ui.setMapName("<j>Refletz#6472<n>")

      return
    end

    if gameStats.threeTeamsMode then
      if gameStats.isCustomMap and gameStats.customMapIndex >= 1 then
        ui.setMapName("<j>" .. customMapsThreeTeamsMode[gameStats.customMapIndex][4] .. "<n>")

        return
      end

      if gameStats.totalVotes >= 2 then
        ui.setMapName("<j>" .. customMapsThreeTeamsMode[gameStats.mapIndexSelected][4] .. "<n>")

        return
      end

      ui.setMapName("<j>Refletz#6472<n>")

      return
    end

    if gameStats.isCustomMap and gameStats.customMapIndex >= 1 then
      ui.setMapName("<j>" .. customMaps[gameStats.customMapIndex][4] .. "<n>")

      return
    end

    if gameStats.totalVotes >= 2 then
      ui.setMapName("<j>" .. customMaps[gameStats.mapIndexSelected][4] .. "<n>")

      return
    end

    ui.setMapName("<j>Refletz#6472<n>")
  end
end
