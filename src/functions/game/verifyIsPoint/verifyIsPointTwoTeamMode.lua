function verifyIsPointTwoTeamsMode()
  
  local quantityBalls = 1
  
  if gameStats.twoBalls then
    quantityBalls = 2
  end
  
  for j = 1, quantityBalls do
    if ballOnGameTwoBalls[j] and ballsId[j] ~= nil then
      if tfm.get.room.objectList[ballsId[j]].x <= gameStats.blueX and tfm.get.room.objectList[ballsId[j]].y >= 368 then
        score_red = score_red + 1
        tfm.exec.chatMessage("<r>Team Red scored!<n>", nil)
        tfm.exec.chatMessage("<r>Team Red<n> "..score_red.." X "..score_blue.." <bv>Team Blue<n>", nil)
        if score_red >= gameStats.winscore then
          showTheScore()
          showMessageWinner()
          ballOnGame = false
          ballOnGame2 = false
          updateTwoBallOnGame()
          twoTeamsModeWinner("red")
          updateRankingTwoTeamsMode()
          tfm.exec.removeObject (ballsId[j])
          mode = "endGame"
          gameTimeEnd = os.time() + 5000
        else
          if #spawnBallArea800 ~= 0 then
            randomIndex = math.random(1, #spawnBallArea800)
            ballSpawnX = spawnBallArea800[randomIndex].x
            ballSpawnY = spawnBallArea800[randomIndex].y
            spawnBall(ballSpawnX, j, ballSpawnY)
          else
            spawnBall(600, j)
          end
        end
        showTheScore()
      elseif tfm.get.room.objectList[ballsId[j]].x <= gameStats.redX and tfm.get.room.objectList[ballsId[j]].y >= 368 then
        score_blue = score_blue + 1
        tfm.exec.chatMessage("<bv>Team Blue scored!<n>", nil)
        tfm.exec.chatMessage("<r>Team Red<n> "..score_red.." X "..score_blue.." <bv>Team Blue<n>", nil)
        if score_blue >= gameStats.winscore then
          ballOnGame = false
          ballOnGame2 = false
          updateTwoBallOnGame()
          twoTeamsModeWinner("blue")
          updateRankingTwoTeamsMode()
          tfm.exec.removeObject (ballsId[j])
          showTheScore()
          showMessageWinner()
          mode = "endGame"
          gameTimeEnd = os.time() + 5000
        else
          if #spawnBallArea400 ~= 0 then
            randomIndex = math.random(1, #spawnBallArea400)
            ballSpawnX = spawnBallArea400[randomIndex].x
            ballSpawnY = spawnBallArea400[randomIndex].y
            spawnBall(ballSpawnX, j, ballSpawnY)
          else
            spawnBall(200, j)
          end
        end
        showTheScore()
      elseif tfm.get.room.objectList[ballsId[j]].x <= gameStats.blueX2 and tfm.get.room.objectList[ballsId[j]].y >= 368 then
        score_red = score_red + 1
        tfm.exec.chatMessage("<r>Team Red scored!<n>", nil)
        tfm.exec.chatMessage("<r>Team Red<n> "..score_red.." X "..score_blue.." <bv>Team Blue<n>", nil)
        if score_red >= gameStats.winscore then
          showTheScore()
          showMessageWinner()
          ballOnGame = false
          ballOnGame2 = false
          updateTwoBallOnGame()
          twoTeamsModeWinner("red")
          updateRankingTwoTeamsMode()
          tfm.exec.removeObject (ballsId[j])
          mode = "endGame"
          gameTimeEnd = os.time() + 5000
        else
          if #spawnBallArea1600 ~= 0 then
            randomIndex = math.random(1, #spawnBallArea1600)
            ballSpawnX = spawnBallArea1600[randomIndex].x
            ballSpawnY = spawnBallArea1600[randomIndex].y
            spawnBall(ballSpawnX, j, ballSpawnY)
          else
            spawnBall(1400, j)
          end
        end
        showTheScore()
      elseif tfm.get.room.objectList[ballsId[j]].x >= gameStats.redX2 and tfm.get.room.objectList[ballsId[j]].y >= 368 then
        score_blue = score_blue + 1
        tfm.exec.chatMessage("<bv>Team Blue scored!<n>", nil)
        tfm.exec.chatMessage("<r>Team Red<n> "..score_red.." X "..score_blue.." <bv>Team Blue<n>", nil)
        if score_blue >= gameStats.winscore then
          ballOnGame = false
          ballOnGame2 = false
          updateTwoBallOnGame()
          twoTeamsModeWinner("blue")
          updateRankingTwoTeamsMode()
          tfm.exec.removeObject (ballsId[j])
          showTheScore()
          showMessageWinner()
          mode = "endGame"
          gameTimeEnd = os.time() + 5000
        else
          if #spawnBallArea1200 ~= 0 then
            randomIndex = math.random(1, #spawnBallArea1200)
            ballSpawnX = spawnBallArea1200[randomIndex].x
            ballSpawnY = spawnBallArea1200[randomIndex].y
            spawnBall(ballSpawnX, j, ballSpawnY)
          else
            spawnBall(1000, j)
          end
        end
        showTheScore()
      end
    end
  end
end