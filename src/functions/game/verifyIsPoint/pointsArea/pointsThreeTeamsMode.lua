function pointsThreeTeamsMode(ballX, ballY, index, typeMap, teamIndex)
  local onCondition = false
  local lostLife = false

  if typeMap == "large4v4" then
    for i = 1, #teamPointsArea1 do
      local x1 = teamPointsArea1[i][1]
      local x2 = teamPointsArea1[i][2]
      local y1 = teamPointsArea1[i][3]
      local y2 = teamPointsArea1[i][4]

      if x1 ~= nil and x2 ~= nil and y1 ~= nil and y2 ~= nil then
        if ballX >= x1 and ballX <= x2 and ballY >= y1 and ballY <= y2 and teamsLifes[2].red >= 1 and not onCondition and not lostLife then
          lostLife = true
          onCondition = true
          teamsLifes[2].red = teamsLifes[2].red - 1
          if teamsLifes[2].red == 0 then
            ballOnGame = false
            ballOnGame2 = false
            ballOnGame3 = false
            updateTwoBallOnGame()
            for i = 1, #playersRed do
              tfm.exec.setNameColor(playersRed[i].name, 0xD1D5DB)
              tfm.exec.movePlayer(playersRed[i].name, 391, 74)
              playerInGame[playersRed[i].name] = false
              playersRed[i].name = ''
            end
            tfm.exec.chatMessage("<r>Red team lost all their lives<n>", nil)
            toggleMapType()
            updateTeamsColors(1)
            gameStats.canTransform = false
            disablePlayersCanTransform(4000)
            delayToToggleMap = addTimer(function(i)
              if i == 1 then
                toggleMap()
              end
            end, 3000, 1, "delayToToggleMap")
            return
          end
          local ballSpawnX = 0
          local ballSpawnY = 0
          
          tfm.exec.chatMessage("<r>Red team lost a life<n>", nil)
          tfm.exec.chatMessage("<r>Team Red<n> "..teamsLifes[2].red.." | <bv>Team Blue<n> "..teamsLifes[3].blue.." | <vp>Team Green<n> "..teamsLifes[4].green.."", nil)
          print("<r>Team Red<n> "..teamsLifes[2].red.." | <bv>Team Blue<n> "..teamsLifes[3].blue.." | <vp>Team Green<n> "..teamsLifes[4].green.."")
          if #spawnBallArea400 ~= 0 then
            randomIndex = math.random(1, #spawnBallArea400)
            ballSpawnX = spawnBallArea400[randomIndex].x
            ballSpawnY = spawnBallArea400[randomIndex].y
            spawnBall(ballSpawnX, index, ballSpawnY)
          else
            spawnBall(300, index)
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
        if ballX >= x1 and ballX <= x2 and ballY >= y1 and ballY <= y2 and teamsLifes[3].blue >= 1 and not onCondition and not lostLife then
          lostLife = true
          onCondition = true
          teamsLifes[3].blue = teamsLifes[3].blue - 1
          if teamsLifes[3].blue == 0 then
            ballOnGame = false
            ballOnGame2 = false
            ballOnGame3 = false
            updateTwoBallOnGame()
            for i = 1, #playersBlue do
              tfm.exec.setNameColor(playersBlue[i].name, 0xD1D5DB)
              tfm.exec.movePlayer(playersBlue[i].name, 391, 74)
              playerInGame[playersBlue[i].name] = false
              playersBlue[i].name = ''
            end
            tfm.exec.chatMessage("<bv>Blue team lost all their lives<n>", nil)
            toggleMapType()
            updateTeamsColors(2)
            gameStats.canTransform = false
            disablePlayersCanTransform(4000)
            delayToToggleMap = addTimer(function(i)
              if i == 1 then
                toggleMap()
              end
            end, 3000, 1, "delayToToggleMap")
            return
          end
          tfm.exec.chatMessage("<bv>Blue team lost a life<n>", nil)
          tfm.exec.chatMessage("<r>Team Red<n> "..teamsLifes[2].red.." | <bv>Team Blue<n> "..teamsLifes[3].blue.." | <vp>Team Green<n> "..teamsLifes[4].green.."", nil)
          print("<r>Team Red<n> "..teamsLifes[2].red.." | <bv>Team Blue<n> "..teamsLifes[3].blue.." | <vp>Team Green<n> "..teamsLifes[4].green.."")
          local ballSpawnX = 0
          local ballSpawnY = 0
          if #spawnBallArea800 ~= 0 then
            randomIndex = math.random(1, #spawnBallArea800)
            ballSpawnX = spawnBallArea800[randomIndex].x
            ballSpawnY = spawnBallArea800[randomIndex].y
            spawnBall(ballSpawnX, index, ballSpawnY)
          else
            spawnBall(900, index)
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
        if ballX >= x1 and ballX <= x2 and ballY >= y1 and ballY <= y2 and teamsLifes[4].green >= 1 and not onCondition and not lostLife then
          lostLife = true
          onCondition = true
          teamsLifes[4].green = teamsLifes[4].green - 1
          if teamsLifes[4].green == 0 then
            ballOnGame = false
            ballOnGame2 = false
            ballOnGame3 = false
            updateTwoBallOnGame()
            for i = 1, #playersGreen do
              tfm.exec.setNameColor(playersGreen[i].name, 0xD1D5DB)
              tfm.exec.movePlayer(playersGreen[i].name, 391, 74)
              playerInGame[playersGreen[i].name] = false
              playersGreen[i].name = ''
            end
            tfm.exec.chatMessage("<vp>Green team lost all their lives<n>", nil)
            toggleMapType()
            updateTeamsColors(3)
            gameStats.canTransform = false
            disablePlayersCanTransform(4000)
            delayToToggleMap = addTimer(function(i)
              if i == 1 then
                toggleMap()
              end
            end, 3000, 1, "delayToToggleMap")
            return
          end
          local ballSpawnX = 0
          local ballSpawnY = 0
          
          tfm.exec.chatMessage("<vp>Green team lost a life<n>", nil)
          tfm.exec.chatMessage("<r>Team Red<n> "..teamsLifes[2].red.." | <bv>Team Blue<n> "..teamsLifes[3].blue.." | <vp>Team Green<n> "..teamsLifes[4].green.."", nil)
          print("<r>Team Red<n> "..teamsLifes[2].red.." | <bv>Team Blue<n> "..teamsLifes[3].blue.." | <vp>Team Green<n> "..teamsLifes[4].green.."")
          if #spawnBallArea1200 ~= 0 then
            randomIndex = math.random(1, #spawnBallArea1200)
            ballSpawnX = spawnBallArea1200[randomIndex].x
            ballSpawnY = spawnBallArea1200[randomIndex].y
            spawnBall(ballSpawnX, index, ballSpawnY)
          else
            spawnBall(1500, index)
          end
          showTheScore()
        end
      end
    end
  elseif typeMap == "large3v3" then
    for i = 1, #teamPointsArea1 do
      local x1 = teamPointsArea1[i][1]
      local x2 = teamPointsArea1[i][2]
      local y1 = teamPointsArea1[i][3]
      local y2 = teamPointsArea1[i][4]

      if x1 ~= nil and x2 ~= nil and y1 ~= nil and y2 ~= nil then
        if ballX >= x1 and ballX <= x2 and ballY >= y1 and ballY <= y2 and getTeamsLifes[1] >= 1 and teamIndex == 1 and not lostLife then
          lostLife = true
          getTeamsLifes[1] = getTeamsLifes[1] - 1
          if getTeamsLifes[1] == 0 then
            for j = 1, #teamsPlayersOnGame[teamIndex] do
              tfm.exec.setNameColor(teamsPlayersOnGame[teamIndex][j].name, 0xD1D5DB)
              tfm.exec.movePlayer(teamsPlayersOnGame[teamIndex][j].name, 391, 74)
              playerInGame[teamsPlayersOnGame[teamIndex][j].name] = false
              teamsPlayersOnGame[teamIndex][j].name = ''
            end
            print(teamsPlayersOnGame)
            print(messageTeamsLifes[1])
            tfm.exec.chatMessage(messageTeamsLifes[1], nil)
            showTheScore()
            updateTeamsColors(1)
            showMessageWinner()
            ballOnGame = false
            ballOnGame2 = false
            ballOnGame3 = false
            threeTeamsModeWinner(messageTeamsLifes[1], teamsPlayersOnGame[1])
            updateRankingThreeTeamsMode()
            updateTwoBallOnGame()
            
            tfm.exec.removeObject (ballsId[index])
            mode = "endGame"
            gameTimeEnd = os.time() + 5000
            return
          end
          tfm.exec.chatMessage(messageTeamsLostOneLife[1], nil)
          print(messageTeamsLostOneLife[1])
          tfm.exec.chatMessage(""..messageTeamsLifesTextChat[1].." "..getTeamsLifes[1].." | "..messageTeamsLifesTextChat[2].." "..getTeamsLifes[2].."", nil)
          print(""..messageTeamsLifesTextChat[1].." "..getTeamsLifes[1].." | "..messageTeamsLifesTextChat[2].." "..getTeamsLifes[2].."")
          
          local ballSpawnX = 0
          local ballSpawnY = 0
          
          if #spawnBallArea400 ~= 0 then
            randomIndex = math.random(1, #spawnBallArea400)
            ballSpawnX = spawnBallArea400[randomIndex].x
            ballSpawnY = spawnBallArea400[randomIndex].y
            spawnBall(ballSpawnX, index, ballSpawnY)
          else
            spawnBall(300, index)
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
        if ballX >= x1 and ballX <= x2 and ballY >= y1 and ballY <= y2 and getTeamsLifes[2] >= 1 and teamIndex == 2 and not lostLife then
          lostLife = true
          getTeamsLifes[2] = getTeamsLifes[2] - 1
          if getTeamsLifes[2] == 0 then
            for j = 1, #teamsPlayersOnGame[teamIndex] do
              tfm.exec.setNameColor(teamsPlayersOnGame[teamIndex][j].name, 0xD1D5DB)
              tfm.exec.movePlayer(teamsPlayersOnGame[teamIndex][j].name, 391, 74)
              playerInGame[teamsPlayersOnGame[teamIndex][j].name] = false
              teamsPlayersOnGame[teamIndex][j].name = ''
            end
            tfm.exec.chatMessage(messageTeamsLifes[2], nil)
            print(messageTeamsLifes[2])
            showTheScore()
            updateTeamsColors(2)
            showMessageWinner()
            ballOnGame = false
            ballOnGame2 = false
            ballOnGame3 = false
            threeTeamsModeWinner(messageTeamsLifes[1], teamsPlayersOnGame[1])
            updateRankingThreeTeamsMode()
            updateTwoBallOnGame()
            tfm.exec.removeObject (ballsId[j])
            mode = "endGame"
            gameTimeEnd = os.time() + 5000
            return
          end
          tfm.exec.chatMessage(messageTeamsLostOneLife[2], nil)
          print(messageTeamsLostOneLife[2])
          tfm.exec.chatMessage(""..messageTeamsLifesTextChat[1].." "..getTeamsLifes[1].." | "..messageTeamsLifesTextChat[2].." "..getTeamsLifes[2].."", nil)
          print(""..messageTeamsLifesTextChat[1].." "..getTeamsLifes[1].." | "..messageTeamsLifesTextChat[2].." "..getTeamsLifes[2].."")
          
          local ballSpawnX = 0
          local ballSpawnY = 0
          
          if #spawnBallArea800 ~= 0 then
            randomIndex = math.random(1, #spawnBallArea800)
            ballSpawnX = spawnBallArea800[randomIndex].x
            ballSpawnY = spawnBallArea800[randomIndex].y
            spawnBall(ballSpawnX, j, ballSpawnY)
          else
            spawnBall(900, j)
          end
          showTheScore()
        end
      end
    end
  end
end
