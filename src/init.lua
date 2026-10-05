function init(staged, prepared)
  if staged then return lobbyTransition.begin() end
  if not prepared then lobbyTransition.cancel() end
  resetMatchStatistics()
  if not prepared then
    clearRoundTimers()
    gameCrowns.reset()
    clubhouse.reset()
  end
  spawnBallArea400 = {}
  spawnBallArea800 = {}
  spawnBallArea1200 = {}
  spawnBallArea1600 = {}

  lobbySpawn = {}

  playersSpawn400 = {}
  playersSpawn800 = {}
  playersSpawn1200 = {}
  playersSpawn1600 = {}

  durationDefault = 300
  duration = os.time() + durationDefault * 1000
  durationTimerPause = durationDefault

  playersOnGameHistoric = {}
  gameState.resetLobby()
  removeTimer('verifyBallCoordinates')
  playerConsumables = {}

  gameBalls.clear()
  tfm.exec.disableAllShamanSkills(true)

  playerCanTransform = {}
  playerInGame = {}

  twoTeamsPlayerRedPosition = { [1] = "", [2] = "", [3] = "", [4] = "", [5] = "", [6] = "" }
  twoTeamsPlayerBluePosition = { [1] = "", [2] = "", [3] = "", [4] = "", [5] = "", [6] = "" }

  gameTeams.resetRoster("red", 6)
  gameTeams.resetRoster("blue", 6)
  gameTeams.resetRoster("yellow", 3)

  gameTeams.resetRoster("green", 3)

  gameState.lives = { [1] = { yellow = 3 }, [2] = { red = 3 }, [3] = { blue = 3 }, [4] = { green = 3 } }

  mapsToTest = { [1] = "", [2] = "", [3] = "" }
  teamsPlayersOnGame = {}

  for i = 1, #customMaps do
    mapsVotes[i] = 0
  end

  gameStats = {
    gameMode = '',
    redX = 0,
    blueX = 0,
    yellowX = 0,
    greenX = 0,
    redX2 = 0,
    blueX2 = 0,
    setMapName = '',
    winscore = 7,
    initTimer = 0,
    isCustomMap = false,
    randomMap = false,
    customMapIndex = 0,
    totalVotes = 0,
    mapIndexSelected = 0,
    canTransform = false,
    teamsMode = false,
    canJoin = true,
    customBall = true,
    customBallId = 12,
    banCommandIsEnabled = true,
    killSpec = false,
    isGamePaused = false,
    physicObjectForce = 1,
    twoTeamsMode = false,
    enableAfkMode = false,
    realMode = false,
    redServeIndex = 1,
    blueServeIndex = 1,
    redPlayerServe = "",
    bluePlayerServe = "",
    redServe = false,
    blueServe = false,
    redQuantitySpawn = 0,
    redLimitSpawn = 3,
    blueQuantitySpawn = 0,
    blueLimitSpawn = 3,
    lastPlayerRed = "",
    lastPlayerBlue = "",
    teamWithOutAce = "",
    reduceForce = false,
    aceRed = false,
    aceBlue = false,
    twoBalls = false,
    consumables = false,
    actualMode = "",
    stopTimer = false,
    threeTeamsMode = false,
    threeBalls = false
  }

  playerCoordinates = {}
  webY = 460
  countId = 100000 -- Player grounds: separate from XML grounds and 99990..99998 map helpers.
  playerPhysicId = {}
  gameScores.reset()
  teamPointsArea1 = {}
  teamPointsArea2 = {}
  teamPointsArea3 = {}
  teamPointsArea4 = {}

  lobby_map = '@7983549'
  tfm.exec.newGame(lobby_map)

  if globalSettings.mode == "4 teams mode" then
    gameStats.teamsMode = true
    gameState.lives = { [1] = { yellow = 3 }, [2] = { red = 3 }, [3] = { blue = 3 }, [4] = { green = 3 } }
    updateLobbyTextAreas(true)
    tfm.exec.chatMessage("<bv>Room Setup: The room has been configured for " .. globalSettings.mode .. "<n>", nil)
  elseif globalSettings.mode == "3 teams mode" then
    gameStats.threeTeamsMode = true
    gameTeams.resetRoster("yellow", 4)

    gameTeams.resetRoster("green", 4)

    gameState.lives = { [1] = { yellow = 0 }, [2] = { red = 5 }, [3] = { blue = 5 }, [4] = { green = 5 } }
    updateLobbyTextAreas(true)
    tfm.exec.chatMessage("<bv>Room Setup: The room has been configured for " .. globalSettings.mode .. "<n>", nil)
  elseif globalSettings.mode == "2 teams mode" then
    gameStats.twoTeamsMode = true
    tfm.exec.chatMessage("<bv>Room Setup: The room has been configured for " .. globalSettings.mode .. "<n>", nil)
  elseif globalSettings.mode == "Real mode" then
    gameStats.realMode = true
    tfm.exec.chatMessage("<bv>Room Setup: The room has been configured for " .. globalSettings.mode .. "<n>", nil)
  end

  if globalSettings.threeBalls and gameStats.threeTeamsMode then
    gameStats.threeBalls = true
    tfm.exec.chatMessage("<bv>Room Setup: The three-ball mode has been activated", nil)
  end

  if globalSettings.twoBalls and not gameStats.realMode then
    gameStats.twoBalls = true
    tfm.exec.chatMessage("<bv>Room Setup: The two-ball mode has been activated<n>", nil)
  end

  if globalSettings.randomBall then
    gameStats.customBall = true

    tfm.exec.chatMessage("<bv>Room Setup: The random ball mode has been activated<n>", nil)

    local indexBall = math.random(1, #balls)
    gameStats.customBallId = indexBall
  end

  if not (gameStats.realMode or gameStats.teamsMode or gameStats.twoTeamsMode or gameStats.threeTeamsMode) then
    gameStats.setMapName = globalSettings.mapType or ''
  end
  local _, availableMapIndices = availableMaps()
  if globalSettings.randomMap and not gameStats.realMode and #availableMapIndices > 0 then
    gameStats.randomMap = true
    gameStats.isCustomMap = true
    local indexMap = ''

    tfm.exec.chatMessage("<bv>Room Setup: The random map mode has been activated<n>", nil)

    for name1, data in pairs(tfm.get.room.playerList) do
      if not prepared and selectMapOpen[name1] then
        selectMapUI(name1)
      end
    end

    if gameStats.twoTeamsMode or gameStats.teamsMode then
      indexMap = availableMapIndices[math.random(1, #availableMapIndices)]
      gameStats.customMapIndex = indexMap
      tfm.exec.chatMessage(
        '<bv>' ..
        customMapsFourTeamsMode[gameStats.customMapIndex][3] ..
        ' map (created by ' .. customMapsFourTeamsMode[gameStats.customMapIndex][4] .. ') selected randomly<n>', nil)
      print('<bv>' ..
        customMapsFourTeamsMode[gameStats.customMapIndex][3] ..
        ' map (created by ' .. customMapsFourTeamsMode[gameStats.customMapIndex][4] .. ') selected randomly<n>')
    elseif gameStats.threeTeamsMode then
      indexMap = availableMapIndices[math.random(1, #availableMapIndices)]
      gameStats.customMapIndex = indexMap
      tfm.exec.chatMessage(
        '<bv>' ..
        customMapsThreeTeamsMode[gameStats.customMapIndex][3] ..
        ' map (created by ' .. customMapsThreeTeamsMode[gameStats.customMapIndex][4] .. ') selected randomly<n>', nil)
    elseif not gameStats.realMode then
      indexMap = availableMapIndices[math.random(1, #availableMapIndices)]
      gameStats.customMapIndex = indexMap

      tfm.exec.chatMessage(
        '<bv>' ..
        customMaps[gameStats.customMapIndex][3] ..
        ' map (created by ' .. customMaps[gameStats.customMapIndex][4] .. ') selected randomly<n>', nil)
    end
  end

  if not gameStats.teamsMode and not gameStats.twoTeamsMode and not gameStats.realMode and not gameStats.threeTeamsMode then
    if globalSettings.consumables then
      gameStats.consumables = true

      tfm.exec.chatMessage("<bv>Room Setup: Consumables has been activated in normal mode<n>", nil)
    end

    if globalSettings.mapType ~= '' then
      gameStats.setMapName = globalSettings.mapType

      tfm.exec.chatMessage("<bv>Room Setup: The map size has been set to " .. globalSettings.mapType .. "<n>", nil)
    end
  end

  if globalSettings.minimalist then
    tfm.exec.chatMessage("<bv>Room Setup: Minimalist mode is enabled for maps (This may cause a slight delay when switching maps)<n>", nil)
  end
  

  for name, data in pairs(tfm.get.room.playerList) do
    if string.match(name, '%*') then
      playerBanHistory[name] = 'VOLLEY SYSTEM'
      playerBan[name] = true
    end

    playerLeftRight[name] = 0
    playerConsumableKey[name] = 56
    playerConsumable[name] = true
    playerConsumableItem[name] = 80
    playerForce[name] = 0
    playerCanTransform[name] = true
    playerInGame[name] = false
    playerCoordinates[name] = { x = 0, y = 0 }
    playerPhysicId[name] = 0
    playersOnGameHistoric[name] = { teams = {} }
    isPlayerDead[name] = false
    playerPressSpace[name] = false
    playerOutOfCourt[name] = false
    showOutOfCourtText[name] = false

    --[[
    for i = 1, #keys do
      system.bindKeyboard(name, keys[i], true, true)
    end
    ]]

    tfm.exec.setNameColor(name, 0xD1D5DB)
    tfm.exec.setPlayerScore(name, 0, false)
    pagesList[name] = { helpPage = 1 }
    canVote[name] = true

    if not prepared and selectMapOpen[name] then
      selectMapPage[name] = 1
      selectMapUI(name)
    end

    clubhouse.launcher(name,31)
  end

  ui.addWindow(23, "<p align='center'><font size='13px'><a href='event:menuOpen'>Menu", nil, 5, 15, 100, 30, 0.2, false,
    false, _)
  ui.addWindow(30, "<p align='center'><font size='13px'><a href='event:selectMap'>Select a map/ball", nil, 10, 370, 150, 30, 1,
    false, false, _)

  ui.removeTextArea(0)

  if not gameStats.teamsMode and not gameStats.threeTeamsMode then
    for i = 1, 3 do
      clubhouse.joinArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamRed" .. i .. "'>Join", nil, x[i],
        y[i], 150, 40, 0xE14747, 0xE14747, 1, false)
    end

    for i = 4, 6 do
      clubhouse.joinArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamBlue" .. i .. "'>Join", nil, x[i],
        y[i], 150, 40, 0x184F81, 0x184F81, 1, false)
    end

    for i = 8, 10 do
      clubhouse.joinArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamRed" .. (i - 4) .. "'>Join", nil,
        x[i - 1], y[i - 1], 150, 40, 0xE14747, 0xE14747, 1, false)
    end

    for i = 11, 13 do
      clubhouse.joinArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamBlue" .. (i - 4) .. "'>Join", nil,
        x[i - 1], y[i - 1], 150, 40, 0x184F81, 0x184F81, 1, false)
    end
  end

  afkSystem()

  gameState.lobbyDeadline = prepared and math.huge or os.time() + 25000
  if prepared then gameStats.canJoin=false end

end

clubhouse.configureCopy()
initializeRoomCreator()
init()
