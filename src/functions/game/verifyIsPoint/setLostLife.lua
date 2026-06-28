function setLostLife()
  local quantityBalls = 1

  if gameStats.twoBalls then
    quantityBalls = 2
  end

  for j = 1, quantityBalls do
    local onCondition = false
    local lostLife = false
    local ballStats = tfm.get.room.objectList[ballsId[j]]

    if gameStats.typeMap == "large4v4" and ballStats ~= nil and ballOnGameTwoBalls[j] and ballsId[j] ~= nil and ballOnGame then
      if #teamPointsArea1 > 0 or #teamPointsArea2 > 0 or #teamPointsArea3 > 0 or #teamPointsArea4 > 0 then
        pointsFourTeamsMode(ballStats.x, ballStats.y, j, "large4v4", nil)
      else
        if ballStats.x <= gameStats.yellowX and isBallOnGround(ballsId[j]) and teamsLifes[1].yellow >= 1 and not lostLife then
          lostLife = true
          onCondition = true
          teamsLifes[1].yellow = teamsLifes[1].yellow - 1
          if teamsLifes[1].yellow == 0 then
            ballOnGame = false
            ballOnGame2 = false
            updateTwoBallOnGame()
            
            for i = 1, #playersYellow do
              tfm.exec.setNameColor(playersYellow[i].name, 0xD1D5DB)
              tfm.exec.movePlayer(playersYellow[i].name, 391, 74)
              playerInGame[playersYellow[i].name] = false
              playersYellow[i].name = ''
            end
            tfm.exec.chatMessage("<j>Yellow team lost all their lives<n>", nil)
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
          tfm.exec.chatMessage("<j>Yellow team lost a life<n>", nil)
          tfm.exec.chatMessage("<j>Team Yellow<n> "..teamsLifes[1].yellow.." | <r>Team Red<n> "..teamsLifes[2].red.." | <bv>Team Blue<n> "..teamsLifes[3].blue.." | <vp>Team Green<n> "..teamsLifes[4].green.."", nil)
          print("<j>Team Yellow<n> "..teamsLifes[1].yellow.." | <r>Team Red<n> "..teamsLifes[2].red.." | <bv>Team Blue<n> "..teamsLifes[3].blue.." | <vp>Team Green<n> "..teamsLifes[4].green.."")
          local ballSpawnX = 0
          local ballSpawnY = 0

          if #spawnBallArea400 ~= 0 then
            randomIndex = math.random(1, #spawnBallArea400)
            ballSpawnX = spawnBallArea400[randomIndex].x
            ballSpawnY = spawnBallArea400[randomIndex].y
            spawnBall(ballSpawnX, j, ballSpawnY)
          else
            spawnBall(200, j)
          end
          
          showTheScore()
        elseif ballStats.x <= gameStats.redX and isBallOnGround(ballsId[j]) and teamsLifes[2].red >= 1 and not onCondition and not lostLife then
          lostLife = true
          onCondition = true
          teamsLifes[2].red = teamsLifes[2].red - 1
          if teamsLifes[2].red == 0 then
            ballOnGame = false
            ballOnGame2 = false
            updateTwoBallOnGame()
            for i = 1, #playersRed do
              tfm.exec.setNameColor(playersRed[i].name, 0xD1D5DB)
              tfm.exec.movePlayer(playersRed[i].name, 391, 74)
              playerInGame[playersRed[i].name] = false
              playersRed[i].name = ''
            end
            tfm.exec.chatMessage("<r>Red team lost all their lives<n>", nil)
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
          local ballSpawnX = 0
          local ballSpawnY = 0
          
          tfm.exec.chatMessage("<r>Red team lost a life<n>", nil)
          tfm.exec.chatMessage("<j>Team Yellow<n> "..teamsLifes[1].yellow.." | <r>Team Red<n> "..teamsLifes[2].red.." | <bv>Team Blue<n> "..teamsLifes[3].blue.." | <vp>Team Green<n> "..teamsLifes[4].green.."", nil)
          print("<j>Team Yellow<n> "..teamsLifes[1].yellow.." | <r>Team Red<n> "..teamsLifes[2].red.." | <bv>Team Blue<n> "..teamsLifes[3].blue.." | <vp>Team Green<n> "..teamsLifes[4].green.."")
          if #spawnBallArea800 ~= 0 then
            randomIndex = math.random(1, #spawnBallArea800)
            ballSpawnX = spawnBallArea800[randomIndex].x
            ballSpawnY = spawnBallArea800[randomIndex].y
            spawnBall(ballSpawnX, j, ballSpawnY)
          else
            spawnBall(600, j)
          end
          showTheScore()
        elseif ballStats.x <= gameStats.blueX and isBallOnGround(ballsId[j]) and teamsLifes[3].blue >= 1 and not onCondition and not lostLife then
          lostLife = true
          onCondition = true
          teamsLifes[3].blue = teamsLifes[3].blue - 1
          if teamsLifes[3].blue == 0 then
            ballOnGame = false
            ballOnGame2 = false
            updateTwoBallOnGame()
            for i = 1, #playersBlue do
              tfm.exec.setNameColor(playersBlue[i].name, 0xD1D5DB)
              tfm.exec.movePlayer(playersBlue[i].name, 391, 74)
              playerInGame[playersBlue[i].name] = false
              playersBlue[i].name = ''
            end
            tfm.exec.chatMessage("<bv>Blue team lost all their lives<n>", nil)
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
          tfm.exec.chatMessage("<bv>Blue team lost a life<n>", nil)
          tfm.exec.chatMessage("<j>Team Yellow<n> "..teamsLifes[1].yellow.." | <r>Team Red<n> "..teamsLifes[2].red.." | <bv>Team Blue<n> "..teamsLifes[3].blue.." | <vp>Team Green<n> "..teamsLifes[4].green.."", nil)
          print("<j>Team Yellow<n> "..teamsLifes[1].yellow.." | <r>Team Red<n> "..teamsLifes[2].red.." | <bv>Team Blue<n> "..teamsLifes[3].blue.." | <vp>Team Green<n> "..teamsLifes[4].green.."")
          local ballSpawnX = 0
          local ballSpawnY = 0
          if #spawnBallArea1200 ~= 0 then
            randomIndex = math.random(1, #spawnBallArea1200)
            ballSpawnX = spawnBallArea1200[randomIndex].x
            ballSpawnY = spawnBallArea1200[randomIndex].y
            spawnBall(ballSpawnX, j, ballSpawnY)
          else
            spawnBall(1000, j)
          end
          
          showTheScore()
        elseif ballStats.x >= gameStats.greenX and isBallOnGround(ballsId[j]) and teamsLifes[4].green >= 1 and not onCondition and not lostLife then
          lostLife = true
          onCondition = true
          teamsLifes[4].green = teamsLifes[4].green - 1
          if teamsLifes[4].green == 0 then
            ballOnGame = false
            ballOnGame2 = false
            updateTwoBallOnGame()
            for i = 1, #playersGreen do
              tfm.exec.setNameColor(playersGreen[i].name, 0xD1D5DB)
              tfm.exec.movePlayer(playersGreen[i].name, 391, 74)
              playerInGame[playersGreen[i].name] = false
              playersGreen[i].name = ''
            end
            tfm.exec.chatMessage("<vp>Green team lost all their lives<n>", nil)
            toggleMapType()
            updateTeamsColors(4)
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
          tfm.exec.chatMessage("<j>Team Yellow<n> "..teamsLifes[1].yellow.." | <r>Team Red<n> "..teamsLifes[2].red.." | <bv>Team Blue<n> "..teamsLifes[3].blue.." | <vp>Team Green<n> "..teamsLifes[4].green.."", nil)
          print("<j>Team Yellow<n> "..teamsLifes[1].yellow.." | <r>Team Red<n> "..teamsLifes[2].red.." | <bv>Team Blue<n> "..teamsLifes[3].blue.." | <vp>Team Green<n> "..teamsLifes[4].green.."")
          if #spawnBallArea1600 ~= 0 then
            randomIndex = math.random(1, #spawnBallArea1600)
            ballSpawnX = spawnBallArea1600[randomIndex].x
            ballSpawnY = spawnBallArea1600[randomIndex].y
            spawnBall(ballSpawnX, j, ballSpawnY)
          else
            spawnBall(1400, j)
          end
          showTheScore()
        end
      end
    elseif gameStats.typeMap == "large3v3" and ballStats ~= nil and ballOnGameTwoBalls[j] and ballsId[j] ~= nil and ballOnGame then
      for i = 1, #getTeamsLifes do
        if #teamPointsArea1 > 0 or #teamPointsArea2 > 0 or #teamPointsArea3 > 0 then
          pointsFourTeamsMode(ballStats.x, ballStats.y, j, "large3v3", i)
        else
          if ballStats.x <= 399 and isBallOnGround(ballsId[j]) and getTeamsLifes[1] >= 1 and i == 1 and not lostLife then
            lostLife = true
            getTeamsLifes[1] = getTeamsLifes[1] - 1
            if getTeamsLifes[1] == 0 then
              ballOnGame = false
              ballOnGame2 = false
              updateTwoBallOnGame()
              for j = 1, #teamsPlayersOnGame[i] do
                tfm.exec.setNameColor(teamsPlayersOnGame[i][j].name, 0xD1D5DB)
                tfm.exec.movePlayer(teamsPlayersOnGame[i][j].name, 391, 74)
                playerInGame[teamsPlayersOnGame[i][j].name] = false
                teamsPlayersOnGame[i][j].name = ''
              end
              tfm.exec.chatMessage(messageTeamsLifes[1], nil)
              print(messageTeamsLifes[1])
              updateTeamsColors(1)
              toggleMapType()
              gameStats.canTransform = false
              disablePlayersCanTransform(4000)
              delayToToggleMap = addTimer(function(i)
                if i == 1 then
                  toggleMap()
                end
              end, 3000, 1, "delayToToggleMap")
              return
            end
            tfm.exec.chatMessage(messageTeamsLostOneLife[1], nil)
            print(messageTeamsLostOneLife[1])
            tfm.exec.chatMessage(""..messageTeamsLifesTextChat[1].." "..getTeamsLifes[1].." | "..messageTeamsLifesTextChat[2].." "..getTeamsLifes[2].." | "..messageTeamsLifesTextChat[3].." "..getTeamsLifes[3].."", nil)
            print(""..messageTeamsLifesTextChat[1].." "..getTeamsLifes[1].." | "..messageTeamsLifesTextChat[2].." "..getTeamsLifes[2].." | "..messageTeamsLifesTextChat[3].." "..getTeamsLifes[3].."")
            
            local ballSpawnX = 0
            local ballSpawnY = 0
            
            if #spawnBallArea400 ~= 0 then
              randomIndex = math.random(1, #spawnBallArea400)
              ballSpawnX = spawnBallArea400[randomIndex].x
              ballSpawnY = spawnBallArea400[randomIndex].y
              spawnBall(ballSpawnX, j, ballSpawnY)
            else
              spawnBall(200, j)
            end
            showTheScore()
          elseif ballStats.x <= 799 and isBallOnGround(ballsId[j]) and getTeamsLifes[2] >= 1 and i == 2 and not lostLife then
            lostLife = true
            getTeamsLifes[2] = getTeamsLifes[2] - 1
            if getTeamsLifes[2] == 0 then
              ballOnGame = false
              ballOnGame2 = false
              updateTwoBallOnGame()
              for j = 1, #teamsPlayersOnGame[i] do
                tfm.exec.setNameColor(teamsPlayersOnGame[i][j].name, 0xD1D5DB)
                tfm.exec.movePlayer(teamsPlayersOnGame[i][j].name, 391, 74)
                playerInGame[teamsPlayersOnGame[i][j].name] = false
                teamsPlayersOnGame[i][j].name = ''
              end
              tfm.exec.chatMessage(messageTeamsLifes[2], nil)
              print(messageTeamsLifes[2])
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
            tfm.exec.chatMessage(messageTeamsLostOneLife[2], nil)
            print(messageTeamsLostOneLife[2])
            tfm.exec.chatMessage(""..messageTeamsLifesTextChat[1].." "..getTeamsLifes[1].." | "..messageTeamsLifesTextChat[2].." "..getTeamsLifes[2].." | "..messageTeamsLifesTextChat[3].." "..getTeamsLifes[3].."", nil)
            print(""..messageTeamsLifesTextChat[1].." "..getTeamsLifes[1].." | "..messageTeamsLifesTextChat[2].." "..getTeamsLifes[2].." | "..messageTeamsLifesTextChat[3].." "..getTeamsLifes[3].."")
            
            local ballSpawnX = 0
            local ballSpawnY = 0
            
            if #spawnBallArea800 ~= 0 then
              randomIndex = math.random(1, #spawnBallArea800)
              ballSpawnX = spawnBallArea800[randomIndex].x
              ballSpawnY = spawnBallArea800[randomIndex].y
              spawnBall(ballSpawnX, j, ballSpawnY)
            else
              spawnBall(600, j)
            end
            showTheScore()
          elseif ballStats.x >= 801 and isBallOnGround(ballsId[j]) and getTeamsLifes[3] >= 1 and i == 3 and not lostLife then
            lostLife = true
            getTeamsLifes[3] = getTeamsLifes[3] - 1
            if getTeamsLifes[3] == 0 then
              ballOnGame = false
              ballOnGame2 = false
              updateTwoBallOnGame()
              for j = 1, #teamsPlayersOnGame[i] do
                tfm.exec.setNameColor(teamsPlayersOnGame[i][j].name, 0xD1D5DB)
                tfm.exec.movePlayer(teamsPlayersOnGame[i][j].name, 391, 74)
                playerInGame[teamsPlayersOnGame[i][j].name] = false
                teamsPlayersOnGame[i][j].name = ''
              end
              tfm.exec.chatMessage(messageTeamsLifes[3], nil)
              print(messageTeamsLifes[3])
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
            
            tfm.exec.chatMessage(messageTeamsLostOneLife[3], nil)
            print(messageTeamsLostOneLife[3])
            tfm.exec.chatMessage(""..messageTeamsLifesTextChat[1].." "..getTeamsLifes[1].." | "..messageTeamsLifesTextChat[2].." "..getTeamsLifes[2].." | "..messageTeamsLifesTextChat[3].." "..getTeamsLifes[3].."", nil)
            print(""..messageTeamsLifesTextChat[1].." "..getTeamsLifes[1].." | "..messageTeamsLifesTextChat[2].." "..getTeamsLifes[2].." | "..messageTeamsLifesTextChat[3].." "..getTeamsLifes[3].."")
            local ballSpawnX = 0
            local ballSpawnY = 0
            
            if #spawnBallArea1200 ~= 0 then
              randomIndex = math.random(1, #spawnBallArea1200)
              ballSpawnX = spawnBallArea1200[randomIndex].x
              ballSpawnY = spawnBallArea1200[randomIndex].y
              spawnBall(ballSpawnX, j, ballSpawnY)
            else
              spawnBall(1000, j)
            end
            showTheScore()
          end
        end          
      end
    elseif gameStats.typeMap == "small" and ballStats ~= nil and ballOnGameTwoBalls[j] and ballsId[j] ~= nil and ballOnGame then
      for i = 1, #getTeamsLifes do
        if #teamPointsArea1 > 0 or #teamPointsArea2 > 0 then
          pointsFourTeamsMode(ballStats.x, ballStats.y, j, "small", i)
        else
          if ballStats.x <= 399 and isBallOnGround(ballsId[j]) and getTeamsLifes[1] >= 1 and i == 1 and not lostLife then
            lostLife = true
            getTeamsLifes[1] = getTeamsLifes[1] - 1
            if getTeamsLifes[1] == 0 then
              for j = 1, #teamsPlayersOnGame[i] do
                tfm.exec.setNameColor(teamsPlayersOnGame[i][j].name, 0xD1D5DB)
                tfm.exec.movePlayer(teamsPlayersOnGame[i][j].name, 391, 74)
                playerInGame[teamsPlayersOnGame[i][j].name] = false
                teamsPlayersOnGame[i][j].name = ''
              end
              print(teamsPlayersOnGame)
              print(messageTeamsLifes[1])
              tfm.exec.chatMessage(messageTeamsLifes[1], nil)
              showTheScore()
              updateTeamsColors(1)
              showMessageWinner()
              ballOnGame = false
              ballOnGame2 = false
              fourTeamsModeWinner(messageTeamsLifes[1], teamsPlayersOnGame[1])
              updateRankingFourTeamsMode()
              updateTwoBallOnGame()
              
              tfm.exec.removeObject (ballsId[j])
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
              spawnBall(ballSpawnX, j, ballSpawnY)
            else
              spawnBall(200, j)
            end
            showTheScore()
          elseif ballStats.x >= 401 and isBallOnGround(ballsId[j]) and getTeamsLifes[2] >= 1 and i == 2 and not lostLife then
            lostLife = true
            getTeamsLifes[2] = getTeamsLifes[2] - 1
            if getTeamsLifes[2] == 0 then
              for j = 1, #teamsPlayersOnGame[i] do
                tfm.exec.setNameColor(teamsPlayersOnGame[i][j].name, 0xD1D5DB)
                tfm.exec.movePlayer(teamsPlayersOnGame[i][j].name, 391, 74)
                playerInGame[teamsPlayersOnGame[i][j].name] = false
                teamsPlayersOnGame[i][j].name = ''
              end
              tfm.exec.chatMessage(messageTeamsLifes[2], nil)
              print(messageTeamsLifes[2])
              showTheScore()
              updateTeamsColors(2)
              showMessageWinner()
              ballOnGame = false
              ballOnGame2 = false
              fourTeamsModeWinner(messageTeamsLifes[1], teamsPlayersOnGame[1])
              updateRankingFourTeamsMode()
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
              spawnBall(600, j)
            end
            showTheScore()
          end
        end
      end
    end
  end
end
