function eventNewGame()
  clubhouse.newGame()
  if firstRun then
    print('first run')
    initUsersPermissions()
    lobbyMapConfig()
    print(USER_PERMISSIONS)
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

  if mode == "gameStart" then
    if globalSettings.minimalist and globalSettings.minimalistToggleMap then
      globalSettings.minimalistToggleMap = false

      tfm.exec.chatMessage("<ch>Minimalist mode is enabled, reloading the map to complete the settings.<n>", nil)

      addTimer(function(i) 
        tfm.exec.newGame(tfm.get.room.xmlMapInfo.xml)

        tfm.exec.addPhysicObject (99999, 800, webY, 
        {
          type = 15,
          width = 3000,
          height = 100,
          miceCollision = false,
          groundCollision = false   
        })
      end, 3000, 1)

      return
    end
    showTheScore()
    if gameStats.teamsMode or gameStats.twoTeamsMode then
      if gameStats.isCustomMap and gameStats.customMapIndex >= 1 then
        ui.setMapName("<j>" .. customMapsFourTeamsMode[gameStats.customMapIndex][4] .. "<n>")
      end

      if gameStats.totalVotes >= 2 and not gameStats.isCustomMap then
        ui.setMapName("<j>" .. customMapsFourTeamsMode[gameStats.mapIndexSelected][4] .. "<n>")
      end

      ui.setMapName("<j>Refletz#6472<n>")
    end

    if gameStats.threeTeamsMode then
      if gameStats.isCustomMap and gameStats.customMapIndex >= 1 then
        ui.setMapName("<j>" .. customMapsThreeTeamsMode[gameStats.customMapIndex][4] .. "<n>")
      end

      if gameStats.totalVotes >= 2 and not gameStats.isCustomMap then
        ui.setMapName("<j>" .. customMapsThreeTeamsMode[gameStats.mapIndexSelected][4] .. "<n>")
      end

      ui.setMapName("<j>Refletz#6472<n>")
    end

    if gameStats.isCustomMap and gameStats.customMapIndex >= 1 then
      ui.setMapName("<j>" .. customMaps[gameStats.customMapIndex][4] .. "<n>")
    end

    if gameStats.totalVotes >= 2 then
      ui.setMapName("<j>" .. customMaps[gameStats.mapIndexSelected][4] .. "<n>")
    end

    ui.setMapName("<j>Refletz#6472<n>")

    foundBallSpawnsOnMap(configMap.mapSelected,  configMap.isLargeMap)
    foundMiceSpawnsOnMap(configMap.mapSelected,  configMap.isLargeMap)

    updateBoundariesFromMap()

    if gameStats.teamsMode or gameStats.threeTeamsMode then
      if gameStats.typeMap == "large3v3" then
        teleportPlayersWithTypeMap(true)
      elseif gameStats.typeMap == "small" then
        teleportPlayersWithTypeMap(false)
      else
        teleportPlayers()
      end
    else
      teleportPlayers()
    end

    verifyIsPoint()
    showCrownToAllPlayers()

    tfm.exec.addPhysicObject (99999, 800, webY, 
    {
      type = 15,
      width = 3000,
      height = 100,
      miceCollision = false,
      groundCollision = false   
    })

    showTheScore()

    addTimer(function(i) 
      spawnInitialBall()
      gameStats.canTransform = true
    end, 1500, 1)
  end
end
