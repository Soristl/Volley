function pointsTwoTeamsMode(ballX, ballY, index)
  for i = 1, #teamPointsArea1 do
    local x1 = teamPointsArea1[i][1]
    local x2 = teamPointsArea1[i][2]
    local y1 = teamPointsArea1[i][3]
    local y2 = teamPointsArea1[i][4]

    if x1 ~= nil and x2 ~= nil and y1 ~= nil and y2 ~= nil then
      if ballX >= x1 and ballX <= x2 and ballY >= y1 and ballY <= y2 then
        teamsScores['red'] = teamsScores['red'] + 1
        tfm.exec.chatMessage("<r>Team Red scored!<n>", nil)
        tfm.exec.chatMessage("<r>Team Red<n> "..teamsScores['red'].." X "..teamsScores['blue'].." <bv>Team Blue<n>", nil)
        if teamsScores['red'] >= gameStats.winscore then
          showTheScore()
          showMessageWinner()
          ballOnGame = false
          ballOnGame2 = false
          updateTwoBallOnGame()
          twoTeamsModeWinner("red")
          updateRankingTwoTeamsMode()
          tfm.exec.removeObject (ballsId[index])
          mode = "endGame"
          gameTimeEnd = os.time() + 5000
        else
          if #spawnBallArea800 ~= 0 then
            randomIndex = math.random(1, #spawnBallArea800)
            ballSpawnX = spawnBallArea800[randomIndex].x
            ballSpawnY = spawnBallArea800[randomIndex].y
            spawnBall(ballSpawnX, index, ballSpawnY)
          else
            spawnBall(600, index)
          end
        end
        showTheScore()
      end
    end
  end

  for i = 1, #teamPointsArea2 do
    local x1 = teamPointsArea2[i][1]
    local x2 = teamPointsArea2[i][2]
    local y1 = teamPointsArea2[i][3]
    local y2 = teamPointsArea2[i][4]

    if x1 ~= nil and x2 ~= nil and y1 ~= nil and y2 ~= nil then
      if ballX >= x1 and ballX <= x2 and ballY >= y1 and ballY <= y2 then
        teamsScores['blue'] = teamsScores['blue'] + 1
        tfm.exec.chatMessage("<bv>Team Blue scored!<n>", nil)
        tfm.exec.chatMessage("<r>Team Red<n> "..teamsScores['red'].." X "..teamsScores['blue'].." <bv>Team Blue<n>", nil)
        if teamsScores['blue'] >= gameStats.winscore then
          ballOnGame = false
          ballOnGame2 = false
          updateTwoBallOnGame()
          twoTeamsModeWinner("blue")
          updateRankingTwoTeamsMode()
          tfm.exec.removeObject (ballsId[index])
          showTheScore()
          showMessageWinner()
          mode = "endGame"
          gameTimeEnd = os.time() + 5000
        else
          if #spawnBallArea400 ~= 0 then
            randomIndex = math.random(1, #spawnBallArea400)
            ballSpawnX = spawnBallArea400[randomIndex].x
            ballSpawnY = spawnBallArea400[randomIndex].y
            spawnBall(ballSpawnX, index, ballSpawnY)
          else
            spawnBall(200, index)
          end
        end
        showTheScore()
      end
    end
  end

  for i = 1, #teamPointsArea3 do
    local x1 = teamPointsArea3[i][1]
    local x2 = teamPointsArea3[i][2]
    local y1 = teamPointsArea3[i][3]
    local y2 = teamPointsArea3[i][4]

    if x1 ~= nil and x2 ~= nil and y1 ~= nil and y2 ~= nil then
      if ballX >= x1 and ballX <= x2 and ballY >= y1 and ballY <= y2 then
        teamsScores['red'] = teamsScores['red'] + 1
        tfm.exec.chatMessage("<r>Team Red scored!<n>", nil)
        tfm.exec.chatMessage("<r>Team Red<n> "..teamsScores['red'].." X "..teamsScores['blue'].." <bv>Team Blue<n>", nil)
        if teamsScores['red'] >= gameStats.winscore then
          showTheScore()
          showMessageWinner()
          ballOnGame = false
          ballOnGame2 = false
          updateTwoBallOnGame()
          twoTeamsModeWinner("red")
          updateRankingTwoTeamsMode()
          tfm.exec.removeObject (ballsId[index])
          mode = "endGame"
          gameTimeEnd = os.time() + 5000
        else
          if #spawnBallArea1600 ~= 0 then
            randomIndex = math.random(1, #spawnBallArea1600)
            ballSpawnX = spawnBallArea1600[randomIndex].x
            ballSpawnY = spawnBallArea1600[randomIndex].y
            spawnBall(ballSpawnX, index, ballSpawnY)
          else
            spawnBall(1400, index)
          end
        end
        showTheScore()
      end
    end
  end

  for i = 1, #teamPointsArea4 do
    local x1 = teamPointsArea4[i][1]
    local x2 = teamPointsArea4[i][2]
    local y1 = teamPointsArea4[i][3]
    local y2 = teamPointsArea4[i][4]

    if x1 ~= nil and x2 ~= nil and y1 ~= nil and y2 ~= nil then
      if ballX >= x1 and ballX <= x2 and ballY >= y1 and ballY <= y2 then
        teamsScores['blue'] = teamsScores['blue'] + 1
        tfm.exec.chatMessage("<bv>Team Blue scored!<n>", nil)
        tfm.exec.chatMessage("<r>Team Red<n> "..teamsScores['red'].." X "..teamsScores['blue'].." <bv>Team Blue<n>", nil)
        if teamsScores['blue'] >= gameStats.winscore then
          ballOnGame = false
          ballOnGame2 = false
          updateTwoBallOnGame()
          twoTeamsModeWinner("blue")
          updateRankingTwoTeamsMode()
          tfm.exec.removeObject (ballsId[index])
          showTheScore()
          showMessageWinner()
          mode = "endGame"
          gameTimeEnd = os.time() + 5000
        else
          if #spawnBallArea1200 ~= 0 then
            randomIndex = math.random(1, #spawnBallArea1200)
            ballSpawnX = spawnBallArea1200[randomIndex].x
            ballSpawnY = spawnBallArea1200[randomIndex].y
            spawnBall(ballSpawnX, index, ballSpawnY)
          else
            spawnBall(1000, index)
          end
        end
        showTheScore()
      end
    end
  end
end