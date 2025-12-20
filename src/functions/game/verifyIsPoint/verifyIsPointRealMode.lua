function verifyIsPointRealMode()
  local ballX = tfm.get.room.objectList[ball_id].x
  local ballY = tfm.get.room.objectList[ball_id].y
  
  resetQuantityTeams()
  
  if ballX <= 599 and ballY >= 368 then
    if gameStats.redQuantitySpawn > 0 or gameStats.redServe then
      gameStats.aceRed = false
      score_blue = score_blue + 1
      tfm.exec.chatMessage("<bv>Team Blue scored!<n>", nil)
    else
      gameStats.aceBlue = false
      score_red = score_red + 1
      tfm.exec.chatMessage("<r>Team Red scored!<n>", nil)
    end
    tfm.exec.chatMessage("<r>Team Red<n> "..score_red.." X "..score_blue.." <bv>Team Blue<n>", nil)
    if score_red >= gameStats.winscore or score_blue >= gameStats.winscore then
      showTheScore()
      showMessageWinner()
      ballOnGame = false
      tfm.exec.removeObject (ball_id)
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
  elseif ballX >= gameStats.redX and ballX <= 1299 and ballY >= 368 then
    score_blue = score_blue + 1
    gameStats.aceRed = false
    tfm.exec.chatMessage("<bv>Team Blue scored!<n>", nil)
    tfm.exec.chatMessage("<r>Team Red<n> "..score_red.." X "..score_blue.." <bv>Team Blue<n>", nil)
    if score_blue >= gameStats.winscore then
      ballOnGame = false
      tfm.exec.removeObject (ball_id)
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
  elseif ballX >= 1301 and ballX <= gameStats.blueX and ballY >= 368 then
    score_red = score_red + 1
    gameStats.aceBlue = false
    tfm.exec.chatMessage("<r>Team Red scored!<n>", nil)
    tfm.exec.chatMessage("<r>Team Red<n> "..score_red.." X "..score_blue.." <bv>Team Blue<n>", nil)
    if score_red >= gameStats.winscore then
      showTheScore()
      showMessageWinner()
      realModeWinner("red")
      updateRankingRealMode()
      ballOnGame = false
      tfm.exec.removeObject (ball_id)
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
  elseif ballX >= 2001 and ballY >= 368 then
    if gameStats.blueQuantitySpawn > 0 or gameStats.blueServe then
      gameStats.aceBlue = false
      score_red = score_red + 1
      tfm.exec.chatMessage("<r>Team Red scored!<n>", nil)
    else
      gameStats.aceRed = false
      score_blue = score_blue + 1
      tfm.exec.chatMessage("<bv>Team Blue scored!<n>", nil)
    end
    
    tfm.exec.chatMessage("<r>Team Red<n> "..score_red.." X "..score_blue.." <bv>Team Blue<n>", nil)
    if score_blue >= gameStats.winscore or score_red >= gameStats.winscore then
      ballOnGame = false
      tfm.exec.removeObject (ball_id)
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