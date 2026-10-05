-- Phase transitions own lobby readiness and startup layout. eventLoop only
-- dispatches the current phase and advances timers in the established order.
gameRound = {}

do
  local profiles = {
    real = { minimum=2, teams={'red','blue'}, rank=function() return rankRealMode end },
    three = { minimum=1, teams={'red','blue','green'}, rank=function() return rankThreeTeamsMode end,
      label='3 teams mode', positions={redX=599,blueX=1199,greenX=1201} },
    four = { minimum=1, teams={'red','blue','yellow','green'}, rank=function() return rankFourTeamsMode end,
      label='4 teams mode', positions={yellowX=399,redX=799,blueX=1199,greenX=1201} },
    two = { minimum=2, teams={'red','blue'}, rank=function() return rankTwoTeamsMode end,
      positions={blueX=399,redX=799,blueX2=1199,redX2=1201} },
    normal = { minimum=1, teams={'red','blue'}, rank=function() return rankNormalMode end }
  }

  local function lobbyMode()
    if gameStats.realMode then return 'real' end
    if gameStats.threeTeamsMode then return 'three' end
    if gameStats.teamsMode then return 'four' end
    if gameStats.twoTeamsMode then return 'two' end
    return 'normal'
  end

  local function enoughPlayers(profile, counts)
    for _, key in ipairs(profile.teams) do
      if counts[key] < profile.minimum then return false end
    end
    return true
  end

  local function showRealRules()
    gameState.setPhase('showRules')
    for name in pairs(tfm.get.room.playerList) do
      ui.addWindow(266, '' .. playerLanguage[name].tr.realModeRules .. '', name,
        125, 60, 650, 300, 1, false, true, playerLanguage[name].tr.closeUIText)
    end
    removeWindowsOnBottom()
  end

  local function configureCourt(mode, profile, counts)
    if mode == 'normal' then
      -- Either team reaching four selects the larger automatic court.
      if counts.red <= 3 or counts.blue <= 3 then
        gameStats.gameMode, gameStats.redX, gameStats.blueX = '3v3', 399, 401
      end
      if counts.red >= 4 or counts.blue >= 4 then
        gameStats.gameMode, gameStats.redX, gameStats.blueX = '4v4', 599, 601
      end
    else
      for key, value in pairs(profile.positions) do gameStats[key] = value end
    end
  end

  -- True asks eventLoop to end this tick before advancing timers.
  function gameRound.lobby()
    if lobbyTransition.active then return true end
    local seconds = math.ceil((gameState.lobbyDeadline - os.time()) / 1000)
    if gameStats.stopTimer then return false end
    gameStats.initTimer = math.max(0, seconds)
    clubhouse.lobbyTimer()
    if seconds > 0 then return false end

    local mode, counts = lobbyMode(), quantityPlayers()
    local profile = profiles[mode]
    if not enoughPlayers(profile, counts) then
      gameState.lobbyDeadline = os.time() + 25000
      return mode ~= 'normal'
    end

    if mode == 'real' then
      rankCrown = profile.rank()
      showRealRules()
      return true
    end
    if profile.label then gameStats.actualMode = profile.label end
    -- Preserve the existing UI cleanup and rank selection order.
    if mode ~= 'normal' then rankCrown = profile.rank() end
    if mode == 'three' then configureCourt(mode, profile, counts) end
    removeTextAreasOfLobby()
    removeWindowsOnBottom()
    if mode == 'normal' then rankCrown = profile.rank() end
    if mode ~= 'three' then configureCourt(mode, profile, counts) end
    if mode ~= 'normal' then gameStats.typeMap = 'large4v4' end
    startGame()
    return mode ~= 'normal'
  end

  function gameRound.rules()
    -- Departures during the rules screen must not start an unplayable match.
    if gameTeams.count(gameState.teams.red, true) < 2 or
        gameTeams.count(gameState.teams.blue, true) < 2 then
      closeWindow(266, nil)
      gameState.resetLobby()
      gameStats.initTimer = 25
      eventNewGameShowLobbyTexts()
      for name in pairs(tfm.get.room.playerList) do clubhouse.refresh(name) end
      tfm.exec.chatMessage('<j>Real Mode needs at least two players in each team. Waiting in the lobby.<n>', nil)
      return true
    end
    if math.ceil((gameState.rulesDeadline - os.time()) / 1000) <= 0 then
      gameStats.redX, gameStats.blueX = 601, 1999
      closeWindow(266, nil)
      startGame()
    end
    return false
  end

  function gameRound.ending()
    if lobbyTransition.active then return end
    if math.ceil((gameState.endDeadline - os.time()) / 1000) <= 0 then
      countMatches = countMatches + 1
      ui.removeTextArea(899899)
      ui.removeTextArea(8998991)
      removeTimer('verifyBallCoordinates')
      init(true)
    end
  end
end
