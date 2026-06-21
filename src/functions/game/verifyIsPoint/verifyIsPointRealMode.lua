function verifyIsPointRealMode()
  if not ball_id or not tfm.get.room.objectList[ball_id] or not ballOnGame then return end
  local ballX = tfm.get.room.objectList[ball_id].x
  local ballY = tfm.get.room.objectList[ball_id].y

  resetQuantityTeams()

  if ballX <= 599 and isBallOnGround(ball_id) then
    if gameStats.redQuantitySpawn > 0 or gameStats.redServe then
      gameStats.aceRed = false
      teamsScores['blue'] = teamsScores['blue'] + 1
      tfm.exec.chatMessage("<bv>Team Blue scored!<n>", nil)
    else
      gameStats.aceBlue = false
      teamsScores['red'] = teamsScores['red'] + 1
      tfm.exec.chatMessage("<r>Team Red scored!<n>", nil)
    end
    tfm.exec.chatMessage("<r>Team Red<n> " .. teamsScores['red'] .. " X " .. teamsScores['blue'] .. " <bv>Team Blue<n>",
      nil)
    if teamsScores['red'] >= gameStats.winscore or teamsScores['blue'] >= gameStats.winscore then
      showTheScore()
      showMessageWinner()
      ballOnGame = false
      tfm.exec.removeObject(ball_id)
      if gameStats.redQuantitySpawn > 0 or gameStats.redServe then
        realModeWinner("blue")
      else
        realModeWinner("red")
      end
      updateRankingRealMode()
      mode = "endGame"
      gameTimeEnd = os.time() + 5000
    else
      ballOnGame = false
      if gameStats.redQuantitySpawn > 0 or gameStats.redServe then
        gameStats.canTransform = false
        local delayTeleport = addTimer(function(i)
          if i == 1 then
            choosePlayerServe("blue")
            teamServe("blue")
          end
        end, 4000, 1, "delayTeleport")

        local delaySpawnBall = addTimer(function(i)
          if i == 1 then
            spawnBallRealMode("blue")
          end
        end, 6000, 1, "delaySpawnBall")
      else
        gameStats.canTransform = false
        local delayTeleport = addTimer(function(i)
          if i == 1 then
            choosePlayerServe("red")
            teamServe("red")
          end
        end, 4000, 1, "delayTeleport")

        local delaySpawnBall = addTimer(function(i)
          if i == 1 then
            spawnBallRealMode("red")
          end
        end, 6000, 1, "delaySpawnBall")
      end
    end
    showTheScore()
    return
  elseif ballX >= gameStats.redX and ballX <= 1299 and isBallOnGround(ball_id) then
    teamsScores['blue'] = teamsScores['blue'] + 1
    gameStats.aceRed = false
    tfm.exec.chatMessage("<bv>Team Blue scored!<n>", nil)
    tfm.exec.chatMessage("<r>Team Red<n> " .. teamsScores['red'] .. " X " .. teamsScores['blue'] .. " <bv>Team Blue<n>",
      nil)
    if teamsScores['blue'] >= gameStats.winscore then
      ballOnGame = false
      tfm.exec.removeObject(ball_id)
      showTheScore()
      showMessageWinner()
      realModeWinner("blue")
      updateRankingRealMode()
      mode = "endGame"
      gameTimeEnd = os.time() + 5000
    else
      ballOnGame = false
      gameStats.canTransform = false
      local delayTeleport = addTimer(function(i)
        if i == 1 then
          choosePlayerServe("blue")
          teamServe("blue")
        end
      end, 4000, 1, "delayTeleport")

      local delaySpawnBall = addTimer(function(i)
        if i == 1 then
          spawnBallRealMode("blue")
        end
      end, 6000, 1, "delaySpawnBall")
    end
    showTheScore()
    return
  elseif ballX >= 1301 and ballX <= gameStats.blueX and isBallOnGround(ball_id) then
    teamsScores['red'] = teamsScores['red'] + 1
    gameStats.aceBlue = false
    tfm.exec.chatMessage("<r>Team Red scored!<n>", nil)
    tfm.exec.chatMessage("<r>Team Red<n> " .. teamsScores['red'] .. " X " .. teamsScores['blue'] .. " <bv>Team Blue<n>",
      nil)
    if teamsScores['red'] >= gameStats.winscore then
      showTheScore()
      showMessageWinner()
      realModeWinner("red")
      updateRankingRealMode()
      ballOnGame = false
      tfm.exec.removeObject(ball_id)
      mode = "endGame"
      gameTimeEnd = os.time() + 5000
    else
      ballOnGame = false
      gameStats.canTransform = false
      local delayTeleport = addTimer(function(i)
        if i == 1 then
          choosePlayerServe("red")
          teamServe("red")
        end
      end, 4000, 1, "delayTeleport")

      local delaySpawnBall = addTimer(function(i)
        if i == 1 then
          spawnBallRealMode("red")
        end
      end, 6000, 1, "delaySpawnBall")
    end
    showTheScore()
    return
  elseif ballX >= 2001 and isBallOnGround(ball_id) then
    if gameStats.blueQuantitySpawn > 0 or gameStats.blueServe then
      gameStats.aceBlue = false
      teamsScores['red'] = teamsScores['red'] + 1
      tfm.exec.chatMessage("<r>Team Red scored!<n>", nil)
    else
      gameStats.aceRed = false
      teamsScores['blue'] = teamsScores['blue'] + 1
      tfm.exec.chatMessage("<bv>Team Blue scored!<n>", nil)
    end

    tfm.exec.chatMessage("<r>Team Red<n> " .. teamsScores['red'] .. " X " .. teamsScores['blue'] .. " <bv>Team Blue<n>",
      nil)
    if teamsScores['blue'] >= gameStats.winscore or teamsScores['red'] >= gameStats.winscore then
      ballOnGame = false
      tfm.exec.removeObject(ball_id)
      showTheScore()
      showMessageWinner()
      if gameStats.blueQuantitySpawn > 0 or gameStats.blueServe then
        realModeWinner("red")
      else
        realModeWinner("blue")
      end
      updateRankingRealMode()
      mode = "endGame"
      gameTimeEnd = os.time() + 5000
    else
      ballOnGame = false
      if gameStats.blueQuantitySpawn > 0 or gameStats.blueServe then
        gameStats.canTransform = false
        local delayTeleport = addTimer(function(i)
          if i == 1 then
            choosePlayerServe("red")
            teamServe("red")
          end
        end, 4000, 1, "delayTeleport")

        local delaySpawnBall = addTimer(function(i)
          if i == 1 then
            spawnBallRealMode("red")
          end
        end, 6000, 1, "delaySpawnBall")
      else
        gameStats.canTransform = false
        local delayTeleport = addTimer(function(i)
          if i == 1 then
            choosePlayerServe("blue")
            teamServe("blue")
          end
        end, 4000, 1, "delayTeleport")

        local delaySpawnBall = addTimer(function(i)
          if i == 1 then
            spawnBallRealMode("blue")
          end
        end, 6000, 1, "delaySpawnBall")
      end
    end
    showTheScore()
    return
  end
end
