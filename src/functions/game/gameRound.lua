-- Phase transitions own lobby readiness and startup layout. eventLoop only
-- dispatches the current phase and advances timers in the established order.
gameRound = {}

do
  -- Match timing stays private; phase and lobby deadlines retain their own lifetimes.
  local roundClock = {}

  function gameRound.resetClock()
    roundClock.defaultDuration = 300
    roundClock.deadline = os.time() + roundClock.defaultDuration * 1000
    roundClock.remaining = roundClock.defaultDuration
  end

  function gameRound.defaultDuration()
    return roundClock.defaultDuration
  end

  function gameRound.setDuration(durationSec)
    roundClock.deadline = os.time() + durationSec * 1000
    roundClock.remaining = durationSec
    tfm.exec.setGameTime(roundClock.remaining, true)
  end

  function gameRound.capturePausedTime()
    roundClock.remaining = math.max(0, math.ceil((roundClock.deadline - os.time()) / 1000))
  end

  function gameRound.resumeClock()
    roundClock.deadline = os.time() + roundClock.remaining * 1000
    tfm.exec.setGameTime(roundClock.remaining, true)
  end

  function gameRound.showPausedTime()
    tfm.exec.setGameTime(roundClock.remaining, true)
  end

  function gameRound.startClock()
    roundClock.deadline = os.time() + roundClock.remaining * 1000

    local _timer = math.ceil((roundClock.deadline - os.time()) / 1000)

    tfm.exec.setGameTime(_timer, true)
  end

  local profiles = {
    real = { minimum=2, teams={'red','blue'}, rank=function() return sessionRanking.ranks.real end },
    three = { minimum=1, teams={'red','blue','green'}, rank=function() return sessionRanking.ranks.three end,
      label='3 teams mode', positions={redX=599,blueX=1199,greenX=1201} },
    four = { minimum=1, teams={'red','blue','yellow','green'}, rank=function() return sessionRanking.ranks.four end,
      label='4 teams mode', positions={yellowX=399,redX=799,blueX=1199,greenX=1201} },
    two = { minimum=2, teams={'red','blue'}, rank=function() return sessionRanking.ranks.two end,
      positions={blueX=399,redX=799,blueX2=1199,redX2=1201} },
    normal = { minimum=1, teams={'red','blue'}, rank=function() return sessionRanking.ranks.normal end }
  }

  local function lobbyMode()
    if gameState.match.mode.realMode then return 'real' end
    if gameState.match.mode.threeTeamsMode then return 'three' end
    if gameState.match.mode.teamsMode then return 'four' end
    if gameState.match.mode.twoTeamsMode then return 'two' end
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
      ui.addWindow(266, '' .. playerState.language[name].tr.realModeRules .. '', name,
        125, 60, 650, 300, 1, false, true, playerState.language[name].tr.closeUIText)
    end
    clubhouse.removeBottomWindows()
  end

  local function configureCourt(mode, profile, counts)
    if mode == 'normal' then
      -- Either team reaching four selects the larger automatic court.
      if counts.red <= 3 or counts.blue <= 3 then
        gameState.match.mode.gameMode, gameState.match.court.redX, gameState.match.court.blueX = '3v3', 399, 401
      end
      if counts.red >= 4 or counts.blue >= 4 then
        gameState.match.mode.gameMode, gameState.match.court.redX, gameState.match.court.blueX = '4v4', 599, 601
      end
    else
      for key, value in pairs(profile.positions) do gameState.match.court[key] = value end
    end
  end

  -- True asks eventLoop to end this tick before advancing timers.
  function gameRound.lobby()
    if lobbyTransition.active then return true end
    local seconds = math.ceil((gameState.lobbyDeadline - os.time()) / 1000)
    if gameState.match.round.stopTimer then return false end
    gameState.match.round.initTimer = math.max(0, seconds)
    clubhouse.lobbyTimer()
    if seconds > 0 then return false end

    local mode, counts = lobbyMode(), gameTeams.countsByTeam()
    local profile = profiles[mode]
    if not enoughPlayers(profile, counts) then
      gameState.lobbyDeadline = os.time() + 25000
      return mode ~= 'normal'
    end

    if mode == 'real' then
      sessionRanking.crown = profile.rank()
      showRealRules()
      return true
    end
    if profile.label then gameState.match.mode.actualMode = profile.label end
    -- Preserve the existing UI cleanup and rank selection order.
    if mode ~= 'normal' then sessionRanking.crown = profile.rank() end
    if mode == 'three' then configureCourt(mode, profile, counts) end
    clubhouse.removeLobbyTextAreas()
    clubhouse.removeBottomWindows()
    if mode == 'normal' then sessionRanking.crown = profile.rank() end
    if mode ~= 'three' then configureCourt(mode, profile, counts) end
    if mode ~= 'normal' then gameState.match.court.typeMap = 'large4v4' end
    gameRound.start()
    return mode ~= 'normal'
  end

  function gameRound.rules()
    -- Departures during the rules screen must not start an unplayable match.
    if gameTeams.count(gameState.teams.red, true) < 2 or
        gameTeams.count(gameState.teams.blue, true) < 2 then
      clubhouse.closeLegacyWindow(266, nil)
      gameState.resetLobby()
      gameState.match.round.initTimer = 25
      clubhouse.renderLobby()
      for name in pairs(tfm.get.room.playerList) do clubhouse.refresh(name) end
      tfm.exec.chatMessage('<j>Real Mode needs at least two players in each team. Waiting in the lobby.<n>', nil)
      return true
    end
    if math.ceil((gameState.rulesDeadline - os.time()) / 1000) <= 0 then
      gameState.match.court.redX, gameState.match.court.blueX = 601, 1999
      clubhouse.closeLegacyWindow(266, nil)
      gameRound.start()
    end
    return false
  end

  function gameRound.ending()
    if lobbyTransition.active then return end
    if math.ceil((gameState.endDeadline - os.time()) / 1000) <= 0 then
      sessionRanking.advanceMatch()
      ui.removeTextArea(899899)
      ui.removeTextArea(8998991)
      timers.remove('verifyBallCoordinates')
      matchLifecycle.resetLobby(true)
    end
  end
end
