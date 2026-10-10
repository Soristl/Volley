function spawnInitialBall()
  local x = {}

  if gameStats.threeTeamsMode and gameStats.typeMap == "large4v4" then
    local spawnBalls = { spawnBallArea400, spawnBallArea800, spawnBallArea1200 }

    x = { 300, 900, 1500 }

    spawnBallConfig(spawnBalls, x)

    return
  elseif gameStats.threeTeamsMode and gameStats.typeMap == "large3v3" then
    local spawnBalls = { spawnBallArea400, spawnBallArea800 }
    x = { 300, 900 }

    if gameStats.threeBalls then
      -- Keep the right-team markers assigned to the rightmost ball.
      spawnBalls = { spawnBallArea400, {}, spawnBallArea800 }
      x = { 300, 600, 900 }
    end

    spawnBallConfig(spawnBalls, x)

    return
  end

  if gameStats.teamsMode and gameStats.typeMap == "large4v4" or gameStats.twoTeamsMode then
    local spawnBalls = { spawnBallArea400, spawnBallArea800, spawnBallArea1200, spawnBallArea1600 }

    x = { 200, 600, 1000, 1400 }

    spawnBallConfig(spawnBalls, x)

    return
  elseif gameStats.teamsMode and gameStats.typeMap == "large3v3" then
    x = { 200, 600, 1000 }
    local spawnBalls = { spawnBallArea400, spawnBallArea800, spawnBallArea1200 }

    spawnBallConfig(spawnBalls, x)

    return
  elseif gameStats.teamsMode and gameStats.typeMap == "small" then
    x = { 200, 600 }
    local spawnBalls = { spawnBallArea400, spawnBallArea800 }

    spawnBallConfig(spawnBalls, x)

    return
  end

  if gameStats.realMode then
    if endRealMatchIfTeamEmpty() then return end
    gameBalls.deactivate(1)
    local team = chooseInitialPlayer()

    print(team)
    gameStats.reduceForce = true
    if not team then return end
    gameStats[team .. 'LimitSpawn']=1
    addRoundTimer(function()
      gameBalls.spawn(1,team=='red' and 700 or 1900,50,false)
    end,4000,1,'delaySpawnBall')

    showTheScore()

    delayToVerifyBall = addRoundTimer(function(i)
      if i == 1 then
        gameBalls.activate(1)
      end
    end, 5000, 1, "delayToVerifyBall")
    return
  end

  local spawnBalls = {}
  if gameStats.gameMode == "3v3" then
    x = { 200, 600 }
    spawnBalls = { spawnBallArea400, spawnBallArea800 }
  elseif gameStats.gameMode == "4v4" then
    x = { 400, 800 }
    spawnBalls = { spawnBallArea800, spawnBallArea1600 }
  else
    gameStats.physicObjectForce = 1.2
    x = { 400, 1400 }
  end

  --print(x)

  spawnBallConfig(spawnBalls, x)
end
