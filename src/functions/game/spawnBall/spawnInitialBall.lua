function spawnInitialBall()
  local x = {}

  if gameStats.threeTeamsMode and gameStats.typeMap == "large4v4" then
    local spawnBalls = { spawnBallArea400, spawnBallArea800, spawnBallArea1200 }

    x = {300, 900, 1500}

    spawnBallConfig(spawnBalls, x)

    return
  elseif gameStats.threeTeamsMode and gameStats.typeMap == "large3v3" then
    local spawnBalls = { spawnBallArea400, spawnBallArea800 }

    x = {300, 600, 900}

    spawnBallConfig(spawnBalls, x)

    return
  end

  if gameStats.teamsMode and gameStats.typeMap == "large4v4" or gameStats.twoTeamsMode then
    local spawnBalls = { spawnBallArea400, spawnBallArea800, spawnBallArea1200, spawnBallArea1600 }

    x = {200, 600, 1000, 1400}

    spawnBallConfig(spawnBalls, x)

    return
  elseif gameStats.teamsMode and gameStats.typeMap == "large3v3" then
    x = {200, 600, 1000}
    local spawnBalls = { spawnBallArea400, spawnBallArea800, spawnBallArea1200 }

    spawnBallConfig(spawnBalls, x)

    return
  elseif gameStats.teamsMode and gameStats.typeMap == "small" then
    x = {200, 600}
    local spawnBalls = { spawnBallArea400, spawnBallArea800 }

    spawnBallConfig(spawnBalls, x)

    return
  end

  if gameStats.realMode then
    ballOnGame = false
    local team = chooseInitialPlayer()

    print(team)
    gameStats.reduceForce = true
    if team == "red" then
      gameStats.aceRed = true
      gameStats.redLimitSpawn = 1
      local delaySpawnBall = addTimer(function(i)
        if i == 1 then
          if gameStats.customBall then
            ball_id = tfm.exec.addShamanObject(balls[gameStats.customBallId].id, 700, 50, 0, 0, -5, true)
            if balls[gameStats.customBallId].isImage then
              tfm.exec.addImage(balls[gameStats.customBallId].image, "#"..ball_id, -15, -15, nil, 1, 1, _, 10)
            end
          else
            ball_id = tfm.exec.addShamanObject(6, 700, 50, 0, 0, -5, true)
          end
        end
      end, 4000, 1, "delaySpawnBall")
    elseif team == "blue" then
      gameStats.aceBlue = true
      gameStats.blueLimitSpawn = 1
      local delaySpawnBall = addTimer(function(i)
        if i == 1 then
          if gameStats.customBall then
            ball_id = tfm.exec.addShamanObject(balls[gameStats.customBallId].id, 1900, 50, 0, 0, -5, true)
            if balls[gameStats.customBallId].isImage then
              tfm.exec.addImage(balls[gameStats.customBallId].image, "#"..ball_id, -15, -15, nil, 1, 1, _, 10)
            end
          else
            ball_id = tfm.exec.addShamanObject(6, 1900, 50, 0, 0, -5, true)
          end
        end
      end, 4000, 1, "delaySpawnBall")
    end

    showTheScore()

    delayToVerifyBall = addTimer(function(i)
      if i == 1 then
        ballOnGame = true
      end
    end, 2000, 1, "delayToVerifyBall")
    return
  end

  local spawnBalls = {}
  if gameStats.gameMode == "3v3" then
    x = {200, 600}
    spawnBalls = {spawnBallArea400, spawnBallArea800}
  elseif gameStats.gameMode == "4v4" then
    x = {400, 800}
    spawnBalls = {spawnBallArea800, spawnBallArea1600}
  else
    gameStats.psyhicObjectForce = 1.2
    x = {400, 1400}
  end

  --print(x)

  spawnBallConfig(spawnBalls, x)
  ballOnGame = true
  updateTwoBallOnGame()
end