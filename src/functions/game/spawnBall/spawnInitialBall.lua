do
-- Keep serve selection and delayed activation separate from court layout selection.
local function spawnRealModeBall()
  if realServe.endIfTeamEmpty() then return end
  gameBalls.deactivate(1)
  local team = realServe.chooseInitialTeam()

  print(team)
  gameStats.reduceForce = true
  if not team then return end
  gameStats[team .. 'LimitSpawn']=1
  addRoundTimer(function()
    gameBalls.spawn(1,team=='red' and 700 or 1900,50,false)
  end,4000,1,'delaySpawnBall')

  clubhouse.showScores()

  delayToVerifyBall = addRoundTimer(function(i)
    if i == 1 then
      gameBalls.activate(1)
    end
  end, 5000, 1, "delayToVerifyBall")
  return
end

local function spawnThreeTeamBalls()
  if gameStats.threeTeamsMode and gameStats.typeMap == "large4v4" then
    local spawnBalls = { gameState.court.ballSpawns[1], gameState.court.ballSpawns[2], gameState.court.ballSpawns[3] }

    local x = { 300, 900, 1500 }

    gameBalls.spawnFromMarkers(spawnBalls, x)

    return true
  elseif gameStats.threeTeamsMode and gameStats.typeMap == "large3v3" then
    local spawnBalls = { gameState.court.ballSpawns[1], gameState.court.ballSpawns[2] }
    local x = { 300, 900 }

    if gameStats.threeBalls then
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
  if gameStats.teamsMode and gameStats.typeMap == "large4v4" or gameStats.twoTeamsMode then
    local spawnBalls = { gameState.court.ballSpawns[1], gameState.court.ballSpawns[2], gameState.court.ballSpawns[3], gameState.court.ballSpawns[4] }

    local x = { 200, 600, 1000, 1400 }

    gameBalls.spawnFromMarkers(spawnBalls, x)

    return true
  elseif gameStats.teamsMode and gameStats.typeMap == "large3v3" then
    local x = { 200, 600, 1000 }
    local spawnBalls = { gameState.court.ballSpawns[1], gameState.court.ballSpawns[2], gameState.court.ballSpawns[3] }

    gameBalls.spawnFromMarkers(spawnBalls, x)

    return true
  elseif gameStats.teamsMode and gameStats.typeMap == "small" then
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

  if gameStats.realMode then
    spawnRealModeBall()
    return
  end

  local spawnBalls = {}
  if gameStats.gameMode == "3v3" then
    x = { 200, 600 }
    spawnBalls = { gameState.court.ballSpawns[1], gameState.court.ballSpawns[2] }
  elseif gameStats.gameMode == "4v4" then
    x = { 400, 800 }
    spawnBalls = { gameState.court.ballSpawns[2], gameState.court.ballSpawns[4] }
  else
    gameStats.physicObjectForce = 1.2
    x = { 400, 1400 }
  end

  --print(x)

  gameBalls.spawnFromMarkers(spawnBalls, x)
end
end
