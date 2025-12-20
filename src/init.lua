function init()
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
  mode = "startGame"
  removeTimer('verifyBallCoordinates')
  playerConsumables = {}
  
  ballOnGame = false
  ballOnGame2 = false
  ballOnGame3 = false
  ballOnGameTwoBalls = {ballOnGame, ballOnGame2, ballOnGame3}
  ballsId = {nil, nil, nil}
  tfm.exec.disableAllShamanSkills(true)
  
  playerCanTransform = {}
  playerInGame = {}
  
  twoTeamsPlayerRedPosition = { [1] = "", [2] = "", [3] = "", [4] = "", [5] = "", [6] = "" }
  twoTeamsPlayerBluePosition = { [1] = "", [2] = "", [3] = "", [4] = "", [5] = "", [6] = "" }
  
  playersRed = {
    [1] = {name = ''},
    [2] = {name = ''},
    [3] = {name = ''},
    [4] = {name = ''},
    [5] = {name = ''},
    [6] = {name = ''}
  }
  playersBlue = {
    [1] = {name = ''},
    [2] = {name = ''},
    [3] = {name = ''},
    [4] = {name = ''},
    [5] = {name = ''},
    [6] = {name = ''} 
  }
  playersYellow = {
    [1] = {name = ''},
    [2] = {name = ''},
    [3] = {name = ''}
  }

  playersGreen = {
    [1] = {name = ''},
    [2] = {name = ''},
    [3] = {name = ''}
  }

  teamsLifes = { [1] = {yellow = 3}, [2] = {red = 3}, [3] = {blue = 3}, [4] = {green = 3} }

  mapsToTest = { [1] = "", [2] = "", [3] = "" }

  getTeamsLifes = {}

  getTeamsColors = {}
  teamsPlayersOnGame = {}

  messageTeamsLifes = {}
  messageTeamsLostOneLife = {}
  messageTeamsLifesTextChat = {}
  messageWinners = {}
  
  getTeamsColorsName = {0xF59E0B, 0xEF4444, 0x3B82F6, 0x109267}

  for i = 1, #customMaps do
    mapsVotes[i] = 0
  end

  gameStats = {
    gameMode = '', redX = 0, blueX = 0, yellowX = 0, greenX = 0, redX2 = 0, blueX2 = 0,
    setMapName = '', winscore = 7, initTimer = 0,
    isCustomMap = false, randomMap = false, customMapIndex = 0, totalVotes = 0,
    mapIndexSelected = 0, canTransform = false, teamsMode = false, canJoin = true,
    customBall = true, customBallId = 12,
    banCommandIsEnabled = true, killSpec = false, isGamePaused = false,
    psyhicObjectForce = 1, twoTeamsMode = false, enableAfkMode = false,
    realMode = false, redServeIndex = 1, blueServeIndex = 1, redPlayerServe = "",
    bluePlayerServe = "", redServe = false, blueServe = false,
    redQuantitySpawn = 0, redLimitSpawn = 3, blueQuantitySpawn = 0, blueLimitSpawn = 3,
    lastPlayerRed = "", lastPlayerBlue = "", teamWithOutAce = "",
    reduceForce = false, aceRed = false, aceBlue = false,
    twoBalls = false, consumables = false, actualMode = "", stopTimer = false, threeTeamsMode = false,
    threeBalls = false, admins = ""
  }

  playerCoordinates = {}
  countId = 1
  playerPhysicId = {}
  score_red = 0
  score_blue = 0
  ball_id = 0
  lobby_map = '<C><P/><Z><S><S T="6" X="400" Y="385" L="800" H="50" P="0,0,0.3,0.2,0,0,0,0"/><S T="12" X="-5" Y="205" L="10" H="410" P="0,0,0,0.2,0,0,0,0" o="FF0000" m=""/><S T="12" X="805" Y="205" L="10" H="410" P="0,0,0,0.2,0,0,0,0" o="FF0000" m=""/><S T="12" X="400" Y="5" L="810" H="10" P="0,0,0,0.2,0,0,0,0" o="FF0000" m=""/><S T="12" X="445" Y="95" L="710" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FF0000" m=""/><S T="9" X="45" Y="225" L="90" H="270" P="0,0,0,0,0,0,0,0" m=""/></S><D><P X="217" Y="359" T="6" P="0,0"/><P X="580" Y="363" T="4" P="0,0"/><P X="319" Y="360" T="5" P="0,0"/><P X="0" Y="0" T="257" P="0,0"/><DS X="400" Y="349"/></D><O/><L/></Z></C>'
  
  tfm.exec.newGame(lobby_map)

  if globalSettings.mode == "4 teams mode" then
    gameStats.teamsMode = true
    getTeamsColorsName = {0xF59E0B, 0xEF4444, 0x3B82F6, 0x109267}
    teamsLifes = { [1] = {yellow = 3}, [2] = {red = 3}, [3] = {blue = 3}, [4] = {green = 3} }
    updateLobbyTextAreas()
    tfm.exec.chatMessage("<bv>Room Setup: The room has been configured for "..globalSettings.mode.."<n>", nil)
  elseif globalSettings.mode == "3 teams mode" then
    gameStats.threeTeamsMode = true
    getTeamsColorsName = {0xEF4444, 0x3B82F6, 0x109267}
    playersYellow = {
      [1] = {name = ''},
      [2] = {name = ''},
      [3] = {name = ''},
      [4] = {name = ''}
    }

    playersGreen = {
      [1] = {name = ''},
      [2] = {name = ''},
      [3] = {name = ''},
      [4] = {name = ''}
    }

    teamsLifes = { [1] = {yellow = 5}, [2] = {red = 5}, [3] = {blue = 5}, [4] = {green = 5} }
    updateLobbyTextAreas()
    tfm.exec.chatMessage("<bv>Room Setup: The room has been configured for "..globalSettings.mode.."<n>", nil)
  elseif globalSettings.mode == "2 teams mode" then
    gameStats.twoTeamsMode = true
    tfm.exec.chatMessage("<bv>Room Setup: The room has been configured for "..globalSettings.mode.."<n>", nil)
  elseif globalSettings.mode == "Real mode" then
    gameStats.realMode = true
    tfm.exec.chatMessage("<bv>Room Setup: The room has been configured for "..globalSettings.mode.."<n>", nil)
  end

  if globalSettings.threeBalls then
    gameStats.threeBalls = true
    tfm.exec.chatMessage("<bv>Room Setup: The three-ball mode has been activated", nil)
  end

  if globalSettings.twoBalls then
    gameStats.twoBalls = true
    tfm.exec.chatMessage("<bv>Room Setup: The two-ball mode has been activated<n>", nil)
  end

  if globalSettings.randomBall then
    gameStats.customBall = true

    tfm.exec.chatMessage("<bv>Room Setup: The random ball mode has been activated<n>", nil)
    
    local indexBall= math.random(1, #balls)
    gameStats.customBallId = indexBall
    
  end

  if globalSettings.randomMap then
    gameStats.randomMap = true
    gameStats.isCustomMap = true
    local indexMap = ''
    
    tfm.exec.chatMessage("<bv>Room Setup: The random map mode has been activated<n>", nil)
    
    for name1, data in pairs(tfm.get.room.playerList) do
      if selectMapOpen[name1] then
        selectMapUI(name1)
      end
    end
    
    if gameStats.twoTeamsMode or gameStats.teamsMode then
      indexMap = math.random(1, #customMapsFourTeamsMode)
      gameStats.customMapIndex = indexMap
      tfm.exec.chatMessage('<bv>'..customMapsFourTeamsMode[gameStats.customMapIndex][3]..' map (created by '..customMapsFourTeamsMode[gameStats.customMapIndex][4]..') selected randomly<n>', nil)
      print('<bv>'..customMapsFourTeamsMode[gameStats.customMapIndex][3]..' map (created by '..customMapsFourTeamsMode[gameStats.customMapIndex][4]..') selected randomly<n>')
    elseif gameStats.threeTeamsMode then
      indexMap = math.random(1, #customMapsThreeTeamsMode)
      gameStats.customMapIndex = indexMap
      tfm.exec.chatMessage('<bv>'..customMapsFourTeamsMode[gameStats.customMapIndex][3]..' map (created by '..customMapsFourTeamsMode[gameStats.customMapIndex][4]..') selected randomly<n>', nil)
      
    elseif not gameStats.realMode then
      indexMap = math.random(1, #customMaps)
      gameStats.customMapIndex = indexMap
      
      tfm.exec.chatMessage('<bv>'..customMaps[gameStats.customMapIndex][3]..' map (created by '..customMaps[gameStats.customMapIndex][4]..') selected randomly<n>', nil)
    end
  end

  if not gameStats.teamsMode and not gameStats.twoTeamsMode and not gameStats.realmode then
    if globalSettings.consumables then
      gameStats.consumables = true

      tfm.exec.chatMessage("<bv>Room Setup: Consumables has been activated in normal mode<n>", nil)
    end

    if globalSettings.mapType ~= '' then
      gameStats.setMapName = globalSettings.mapType

      tfm.exec.chatMessage("<bv>Room Setup: The map size has been set to "..globalSettings.mapType.."<n>", nil)
    end
  end

  for name, data in pairs(tfm.get.room.playerList) do
    playerLeftRight[name] = 0
    playerConsumableKey[name] = 56
    playerConsumable[name] = true
    playerConsumableItem[name] = 80
    playerForce[name] = 0
    playerCanTransform[name] = true
    playerInGame[name] = false
    playerCoordinates[name] = {x = 0, y = 0}
    playerPhysicId[name] = 0
    playersOnGameHistoric[name] = { teams = {} }

    for i = 1, #keys do
      system.bindKeyboard(name, keys[i], true, true)
    end

    tfm.exec.setNameColor(name, 0xD1D5DB)
    tfm.exec.setPlayerScore(name, 0, false)
    pagesList[name] = {helpPage = 1}
    canVote[name] = true
    
    if selectMapOpen[name] then
      selectMapPage[name] = 1
      selectMapUI(name)
    end
    
    if admins[name] then
      ui.addWindow(31, "<p align='center'><font size='13px'><a href='event:settings'>Room settings", name, 180, 370, 150, 30, 1, false, false, _)
    end
  end

  ui.addWindow(23, "<p align='center'><font size='13px'><a href='event:menuOpen'>Menu", nil, 5, 15, 100, 30, 0.2, false, false, _)
  ui.addWindow(30, "<p align='center'><font size='13px'><a href='event:selectMap'>Select a map", nil, 10, 370, 150, 30, 1, false, false, _)
  
  ui.removeTextArea(0)
  ui.addTextArea(7, "<p align='center'>", nil, 375, 50, 30, 20, 0x161616, 0x161616, 1, false)

  if not gameStats.teamsMode then
    for i = 1, 3 do
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamRed"..i.."'>Join", nil, x[i], y[i], 150, 40, 0xE14747, 0xE14747, 1, false)
    end
    
    for i = 4, 6 do
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamBlue"..i.."'>Join", nil, x[i], y[i], 150, 40, 0x184F81, 0x184F81, 1, false)
    end
    
    for i = 8, 10 do
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamRed"..(i - 4).."'>Join", nil, x[i - 1], y[i - 1], 150, 40, 0xE14747, 0xE14747, 1, false)
    end
    
    for i = 11, 13 do
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamBlue"..(i - 4).."'>Join", nil, x[i - 1], y[i - 1], 150, 40, 0x184F81, 0x184F81, 1, false)
    end
  end

  afkSystem() 

  initGame = os.time() + 25000

  if not checkRoomkAdmins() then
    spawnGetAdminButton()
  end
end

init()