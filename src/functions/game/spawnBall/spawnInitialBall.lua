do
-- Keep serve selection and delayed activation separate from court layout selection.
local function spawnRealModeBall()
  if realServe.endIfTeamEmpty() then return end
  gameBalls.deactivate(1)
  local team = realServe.chooseInitialTeam()

  print(team)
  gameState.match.real.reduceForce = true
  if not team then return end
  gameState.match.real[team .. 'LimitSpawn']=1
  timers.addRound(function()
    gameBalls.spawn(1,team=='red' and 700 or 1900,50,false)
  end,4000,1,'delaySpawnBall')

  clubhouse.showScores()

  timers.handles.verifyBall = timers.addRound(function(i)
    if i == 1 then
      gameBalls.activate(1)
    end
  end, 5000, 1, "delayToVerifyBall")
  return
end

local function spawnThreeTeamBalls()
  if gameState.match.mode.threeTeamsMode and gameState.match.court.typeMap == "large4v4" then
    local spawnBalls = { gameState.court.ballSpawns[1], gameState.court.ballSpawns[2], gameState.court.ballSpawns[3] }

    local x = { 300, 900, 1500 }

    gameBalls.spawnFromMarkers(spawnBalls, x)

    return true
  elseif gameState.match.mode.threeTeamsMode and gameState.match.court.typeMap == "large3v3" then
    local spawnBalls = { gameState.court.ballSpawns[1], gameState.court.ballSpawns[2] }
    local x = { 300, 900 }

    if gameState.match.balls.threeBalls then
      -- Keep the right-team markers assigned to the rightmost ball.
      spawnBalls = { gameState.court.ballSpawns[1], {}, gameState.court.ballSpawns[2] }
      x = { 300, 600, 900 }
    end

    gameBalls.spawnFromMarkers(spawnBalls, x)

    return true
  end
  return false
end

local function spawnTwoOrFourTeamBalls()
  if gameState.match.mode.teamsMode and gameState.match.court.typeMap == "large4v4" or gameState.match.mode.twoTeamsMode then
    local spawnBalls = { gameState.court.ballSpawns[1], gameState.court.ballSpawns[2], gameState.court.ballSpawns[3], gameState.court.ballSpawns[4] }

    local x = { 200, 600, 1000, 1400 }

    gameBalls.spawnFromMarkers(spawnBalls, x)

    return true
  elseif gameState.match.mode.teamsMode and gameState.match.court.typeMap == "large3v3" then
    local x = { 200, 600, 1000 }
    local spawnBalls = { gameState.court.ballSpawns[1], gameState.court.ballSpawns[2], gameState.court.ballSpawns[3] }

    gameBalls.spawnFromMarkers(spawnBalls, x)

    return true
  elseif gameState.match.mode.teamsMode and gameState.match.court.typeMap == "small" then
    local x = { 200, 600 }
    local spawnBalls = { gameState.court.ballSpawns[1], gameState.court.ballSpawns[2] }

    gameBalls.spawnFromMarkers(spawnBalls, x)

    return true
  end
  return false
end

function gameBalls.spawnInitial()
  local x = {}

  if spawnThreeTeamBalls() then return end
  if spawnTwoOrFourTeamBalls() then return end

  if gameState.match.mode.realMode then
    spawnRealModeBall()
    return
  end

  local spawnBalls = {}
  if gameState.match.mode.gameMode == "3v3" then
    x = { 200, 600 }
    spawnBalls = { gameState.court.ballSpawns[1], gameState.court.ballSpawns[2] }
  elseif gameState.match.mode.gameMode == "4v4" then
    x = { 400, 800 }
    spawnBalls = { gameState.court.ballSpawns[2], gameState.court.ballSpawns[4] }
  else
    gameState.match.rules.physicObjectForce = 1.2
    x = { 400, 1400 }
  end

  --print(x)

  gameBalls.spawnFromMarkers(spawnBalls, x)
end
end
