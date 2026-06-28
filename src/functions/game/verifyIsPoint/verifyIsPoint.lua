function verifyIsPoint()
  verifyBallCoordinates = addTimer(function(i)
    if gameStats.teamsMode then
      setLostLife()
      return
    end

    if gameStats.threeTeamsMode then
      verifyIsPointThreeTeamsMode()
      return
    end

    if gameStats.twoTeamsMode then
      verifyIsPointTwoTeamsMode()
      return
    end

    if gameStats.realMode then
      verifyIsPointRealMode()
      return
    end

    local quantityBalls = 1

    if gameStats.twoBalls then
      quantityBalls = 2
    end

    for j = 1, quantityBalls do
      local ballStats = tfm.get.room.objectList[ballsId[j]]

      if ballOnGameTwoBalls[j] and ballsId[j] ~= nil and ballOnGame then
        if #teamPointsArea1 > 0 or #teamPointsArea2 > 0 then
          pointsNormalMode(ballStats.x, ballStats.y, j)
        else
          if ballStats.x <= gameStats.redX and isBallOnGround(ballsId[j]) then
            teamsScores['blue'] = teamsScores['blue'] + 1
            tfm.exec.chatMessage("<bv>Team Blue scored!<n>", nil)
            tfm.exec.chatMessage("<r>Team Red<n> "..teamsScores['red'].." X "..teamsScores['blue'].." <bv>Team Blue<n>", nil)
            if teamsScores['blue'] >= gameStats.winscore then
              ballOnGame = false
              ballOnGame2 = false
              updateTwoBallOnGame()
              tfm.exec.removeObject(ballsId[j])
              showTheScore()
              showMessageWinner()
              normalModeTeamWinner("blue")
              updateRankingNormalMode()
              mode = "endGame"
              gameTimeEnd = os.time() + 5000
            else
              if gameStats.gameMode == "3v3" then
                if #spawnBallArea800 ~= 0 then
                  randomIndex = math.random(1, #spawnBallArea800)
                  ballSpawnX = spawnBallArea800[randomIndex].x
                  ballSpawnY = spawnBallArea800[randomIndex].y
                  spawnBall(ballSpawnX, j, ballSpawnY)
                else
                  spawnBall(600, j)
                end
              elseif gameStats.gameMode == "4v4" then
                if #spawnBallArea1600 ~= 0 then
                  randomIndex = math.random(1, #spawnBallArea1600)
                  ballSpawnX = spawnBallArea1600[randomIndex].x
                  ballSpawnY = spawnBallArea1600[randomIndex].y
                  spawnBall(ballSpawnX, j, ballSpawnY)
                else
                  spawnBall(800, j)
                end
              else
                spawnBall(1400, j)
              end
            end
          elseif ballStats.x >= gameStats.blueX and isBallOnGround(ballsId[j]) then
            teamsScores['red'] = teamsScores['red'] + 1
            tfm.exec.chatMessage("<r>Team Red scored!<n>", nil)
            tfm.exec.chatMessage("<r>Team Red<n> "..teamsScores['red'].." X "..teamsScores['blue'].." <bv>Team Blue<n>", nil)
            if teamsScores['red'] >= gameStats.winscore then
              showTheScore()
              showMessageWinner()
              ballOnGame = false
              ballOnGame2 = false
              updateTwoBallOnGame()
              tfm.exec.removeObject(ballsId[j])
              normalModeTeamWinner("red")
              updateRankingNormalMode()
              mode = "endGame"
              gameTimeEnd = os.time() + 5000
            else
              if gameStats.gameMode == "3v3" then
                if #spawnBallArea400 ~= 0 then
                  randomIndex = math.random(1, #spawnBallArea400)
                  ballSpawnX = spawnBallArea400[randomIndex].x
                  ballSpawnY = spawnBallArea400[randomIndex].y
                  spawnBall(ballSpawnX, j, ballSpawnY)
                else
                  spawnBall(200, j)
                end
              elseif gameStats.gameMode == "4v4" then
                if #spawnBallArea800 ~= 0 then
                  randomIndex = math.random(1, #spawnBallArea800)
                  ballSpawnX = spawnBallArea800[randomIndex].x
                  ballSpawnY = spawnBallArea800[randomIndex].y
                  spawnBall(ballSpawnX, j, ballSpawnY)
                else
                  spawnBall(400, j)
                end
              else
                spawnBall(400, j)
              end
            end
          end
        end
      end
    end
  end, 3000, 0, "verifyBallCoordinates")
end
