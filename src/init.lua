do
-- Apply persistent room choices after the map request, before player resets.
local function applyLobbyMode()
  local configuredMode = true
  if roomConfig.settings.mode == "4 teams mode" then
    gameState.match.mode.teamsMode = true
    gameState.lives = { [1] = { yellow = 3 }, [2] = { red = 3 }, [3] = { blue = 3 }, [4] = { green = 3 } }
    clubhouse.refreshLobbyPlayers(true)
  elseif roomConfig.settings.mode == "3 teams mode" then
    gameState.match.mode.threeTeamsMode = true
    gameTeams.resetRoster("yellow", 4)

    gameTeams.resetRoster("green", 4)

    gameState.lives = { [1] = { yellow = 0 }, [2] = { red = 5 }, [3] = { blue = 5 }, [4] = { green = 5 } }
    clubhouse.refreshLobbyPlayers(true)
  elseif roomConfig.settings.mode == "2 teams mode" then
    gameState.match.mode.twoTeamsMode = true
  elseif roomConfig.settings.mode == "Real mode" then
    gameState.match.mode.realMode = true
  else
    configuredMode = false
  end
  if configuredMode then
    tfm.exec.chatMessage("<bv>Room Setup: The room has been configured for " .. roomConfig.settings.mode .. "<n>", nil)
  end
end

local function applyLobbyBalls()
  if roomConfig.settings.threeBalls and gameState.match.mode.threeTeamsMode then
    gameState.match.balls.threeBalls = true
    tfm.exec.chatMessage("<bv>Room Setup: The three-ball mode has been activated", nil)
  end

  if roomConfig.settings.twoBalls and not gameState.match.mode.realMode then
    gameState.match.balls.twoBalls = true
    tfm.exec.chatMessage("<bv>Room Setup: The two-ball mode has been activated<n>", nil)
  end

  if roomConfig.settings.randomBall then
    gameState.match.balls.customBall = true

    tfm.exec.chatMessage("<bv>Room Setup: The random ball mode has been activated<n>", nil)

    local indexBall = math.random(1, #balls)
    gameState.match.balls.customBallId = indexBall
  end
end

local function applyLobbyMap(prepared)
  if not (gameState.match.mode.realMode or gameState.match.mode.teamsMode or gameState.match.mode.twoTeamsMode or gameState.match.mode.threeTeamsMode) then
    gameState.match.maps.setMapName = roomConfig.settings.mapType or ''
  end
  local _, availableMapIndices = gameMaps.availableEntries()
  if roomConfig.settings.randomMap and not gameState.match.mode.realMode and #availableMapIndices > 0 then
    gameState.match.maps.randomMap = true
    gameState.match.maps.isCustomMap = true

    tfm.exec.chatMessage("<bv>Room Setup: The random map mode has been activated<n>", nil)

    for name1, data in pairs(tfm.get.room.playerList) do
      if not prepared and uiState.selectMapOpen[name1] then
        clubhouse.mapSelector(name1)
      end
    end

    local usesFourTeamMaps = gameState.match.mode.twoTeamsMode or gameState.match.mode.teamsMode
    local maps = usesFourTeamMaps and customMapsFourTeamsMode or
      gameState.match.mode.threeTeamsMode and customMapsThreeTeamsMode or customMaps
    local indexMap = availableMapIndices[math.random(1, #availableMapIndices)]
    gameState.match.maps.customMapIndex = indexMap
    local map = maps[indexMap]
    local message = '<bv>' .. map[3] .. ' map (created by ' .. map[4] .. ') selected randomly<n>'
    tfm.exec.chatMessage(message, nil)
    if usesFourTeamMaps then print(message) end
  end
end

local function applyLobbySettings(prepared)
  applyLobbyMode()
  applyLobbyBalls()
  applyLobbyMap(prepared)

  if not gameState.match.mode.teamsMode and not gameState.match.mode.twoTeamsMode and not gameState.match.mode.realMode and not gameState.match.mode.threeTeamsMode then
    if roomConfig.settings.consumables then
      gameState.match.rules.consumables = true

      tfm.exec.chatMessage("<bv>Room Setup: Consumables has been activated in normal mode<n>", nil)
    end

    if roomConfig.settings.mapType ~= '' then
      gameState.match.maps.setMapName = roomConfig.settings.mapType

      tfm.exec.chatMessage("<bv>Room Setup: The map size has been set to " .. roomConfig.settings.mapType .. "<n>", nil)
    end
  end

  if roomConfig.settings.minimalist then
    tfm.exec.chatMessage("<bv>Room Setup: Minimalist mode is enabled for maps (This may cause a slight delay when switching maps)<n>", nil)
  end
end

-- Replace match settings before applying the persistent room choices.
function gameState.resetMatch()
  gameState.match = {
    mode = {
      gameMode = '',
      teamsMode = false,
      twoTeamsMode = false,
      realMode = false,
      actualMode = "",
      threeTeamsMode = false
    },
    rules = {
      winscore = 7,
      banCommandIsEnabled = true,
      killSpec = false,
      physicObjectForce = 1,
      enableAfkMode = false,
      consumables = false
    },
    balls = {
      customBall = true,
      customBallId = 12,
      twoBalls = false,
      threeBalls = false
    },
    maps = {
      setMapName = '',
      isCustomMap = false,
      randomMap = false,
      customMapIndex = 0,
      totalVotes = 0,
      mapIndexSelected = 0
    },
    round = {
      initTimer = 0,
      canTransform = false,
      canJoin = true,
      isGamePaused = false,
      stopTimer = false
    },
    court = {
      redX = 0,
      blueX = 0,
      yellowX = 0,
      greenX = 0,
      redX2 = 0,
      blueX2 = 0
    },
    real = {
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
      aceBlue = false
    }
  }
end

-- Keep round cleanup and state replacement in their established order.
local function resetRoundState()
  gameState.resetCourtSpawns()

  gameRound.resetClock()

  sessionRanking.resetHistory()
  gameState.resetLobby()
  timers.remove('verifyBallCoordinates')
  playerState.consumables.objects = {}

  gameBalls.clear()
  tfm.exec.disableAllShamanSkills(true)

  playerState.canTransform = {}
  playerState.inGame = {}

  gameState.teamLayout.roles.red = { [1] = "", [2] = "", [3] = "", [4] = "", [5] = "", [6] = "" }
  gameState.teamLayout.roles.blue = { [1] = "", [2] = "", [3] = "", [4] = "", [5] = "", [6] = "" }

  gameTeams.resetRoster("red", 6)
  gameTeams.resetRoster("blue", 6)
  gameTeams.resetRoster("yellow", 3)

  gameTeams.resetRoster("green", 3)

  gameState.lives = { [1] = { yellow = 3 }, [2] = { red = 3 }, [3] = { blue = 3 }, [4] = { green = 3 } }

  gameMaps.clearTestMaps()
  gameState.teamLayout.remaining = {}

  for i = 1, #customMaps do
    gameState.voting.counts[i] = 0
  end

  gameState.resetMatch()

  playerState.coordinates = {}
  gameState.court.webY = 460
  playerState.nextGroundId = 100000 -- Player grounds: separate from XML grounds and 99990..99998 map helpers.
  playerState.physicId = {}
  gameScores.reset()
  gameState.resetCourtPointAreas()
end

-- Reset one player after room settings; staged returns defer selector rendering.
local function resetPlayerForLobby(name, prepared)
  if string.match(name, '%*') then
    playerState.banHistory[name] = 'VOLLEY SYSTEM'
    playerState.ban[name] = true
  end

  playerState.lastDirection[name] = 0
  playerState.consumables.key[name] = 56
  playerState.consumables.ready[name] = true
  playerState.consumables.item[name] = 80
  playerState.force[name] = 0
  playerState.canTransform[name] = true
  playerState.inGame[name] = false
  playerState.coordinates[name] = { x = 0, y = 0 }
  playerState.physicId[name] = 0
  sessionRanking.resetPlayerHistory(name)
  playerState.dead[name] = false
  playerState.pressSpace[name] = false
  playerState.outOfCourt[name] = false
  playerState.outOfCourtText[name] = false

  --[[
  for i = 1, #keys do
    system.bindKeyboard(name, keys[i], true, true)
  end
  ]]

  tfm.exec.setNameColor(name, 0xD1D5DB)
  tfm.exec.setPlayerScore(name, 0, false)
  uiState.pagesList[name] = { helpPage = 1 }
  gameState.voting.eligible[name] = true

  if not prepared and uiState.selectMapOpen[name] then
    uiState.selectMapPage[name] = 1
    clubhouse.mapSelector(name)
  end

  clubhouse.launcher(name,31)
end

-- Clear the two-team seat layout after player controls have been refreshed.
local function resetLobbySeats()
  if not gameState.match.mode.teamsMode and not gameState.match.mode.threeTeamsMode then
    for i = 1, 3 do
      clubhouse.teamSeat("Red", i, "")
    end

    for i = 4, 6 do
      clubhouse.teamSeat("Blue", i - 3, "")
    end

    for i = 8, 10 do
      clubhouse.teamSeat("Red", i - 4, "")
    end

    for i = 11, 13 do
      clubhouse.teamSeat("Blue", i - 7, "")
    end
  end
end

function matchLifecycle.resetLobby(staged, prepared)
  if staged then return lobbyTransition.begin() end
  if not prepared then lobbyTransition.cancel() end
  sessionRanking.resetMatch()
  if not prepared then
    timers.clearRound()
    gameCrowns.reset()
    clubhouse.reset()
  end
  resetRoundState()

  roomConfig.lobbyMap = '@7983549'
  tfm.exec.newGame(roomConfig.lobbyMap)

  applyLobbySettings(prepared)

  for name, data in pairs(tfm.get.room.playerList) do
    resetPlayerForLobby(name, prepared)
  end

  clubhouse.launcher(nil,23)
  clubhouse.launcher(nil,30)

  ui.removeTextArea(0)

  resetLobbySeats()

  playerRuntime.evictInactivePlayers()

  gameState.lobbyDeadline = prepared and math.huge or os.time() + 25000
  if prepared then gameState.match.round.canJoin=false end

end

end

clubhouse.configureCopy()
roomConfig.initializeCreator()
matchLifecycle.resetLobby()
