function leaveTeamTeamsModeConfig(name)
  local count = 0
  local index = 1

  if gameStats.typeMap == "large4v4" then
    if gameStats.teamsMode then
      for i= 1, #playersYellow do
        if playersYellow[i].name == name then
          playersYellow[i].name = ''
          tfm.exec.killPlayer(name)
          removePlayerOnSpawnConfig(name)
          
          local movePlayer = addTimer(function(i)
            tfm.exec.respawnPlayer(name)
            
            teleportPlayersToSpecWithSpecificSpawn(name)
          end, 1000, 1, "movePlayer")
        end
        
        if playersYellow[i].name ~= '' then
          count = count + 1
        end
      end
      if count == 0 then
        ballOnGame = false
        ballOnGame2 = false
        ball_id = nil
        ball_id2 = nil
        updateTwoBallOnGame()
        tfm.exec.chatMessage("<j>Yellow team lost all their lives<n>", nil)
        teamsLifes[1].yellow = 0
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
    end
    
    count = 0
    
    for i= 1, #playersRed do
      if playersRed[i].name == name then
        playersRed[i].name = ''
        tfm.exec.killPlayer(name)
        removePlayerOnSpawnConfig(name)
        
        local movePlayer = addTimer(function(i)
          tfm.exec.respawnPlayer(name)
          teleportPlayersToSpecWithSpecificSpawn(name)
        end, 1000, 1, "movePlayer")
      end
      
      if playersRed[i].name ~= '' then
        count = count + 1
      end
    end
    
    if count == 0 then
      ballOnGame = false
      ballOnGame2 = false
      ball_id = nil
      ball_id2 = nil
      updateTwoBallOnGame()
      tfm.exec.chatMessage("<r>Red team lost all their lives<n>", nil)
      teamsLifes[2].red = 0
      toggleMapType()
      local index = 2

      if gameStats.threeTeamsMode then
        index = 1
      end

      updateTeamsColors(index)
      gameStats.canTransform = false
      disablePlayersCanTransform(4000)
      delayToToggleMap = addTimer(function(i)
        if i == 1 then
          toggleMap()
        end
      end, 3000, 1, "delayToToggleMap")
      return
    end
    
    count = 0
    
    for i= 1, #playersBlue do
      if playersBlue[i].name == name then
        playersBlue[i].name = ''
        tfm.exec.killPlayer(name)
        removePlayerOnSpawnConfig(name)
        
        local movePlayer = addTimer(function(i)
          tfm.exec.respawnPlayer(name)
          teleportPlayersToSpecWithSpecificSpawn(name)
        end, 1000, 1, "movePlayer")
      end
      
      if playersBlue[i].name ~= '' then
        count = count + 1
      end
    end
    
    if count == 0 then
      ballOnGame = false
      ballOnGame2 = false
      ball_id = nil
      ball_id2 = nil
      updateTwoBallOnGame()
      tfm.exec.chatMessage("<bv>Blue team lost all their lives<n>", nil)
      teamsLifes[3].blue = 0
      toggleMapType()

      local index = 3

      if gameStats.threeTeamsMode then
        index = 2
      end

      updateTeamsColors(index)
      gameStats.canTransform = false
      disablePlayersCanTransform(4000)
      delayToToggleMap = addTimer(function(i)
        if i == 1 then
          toggleMap()
        end
      end, 3000, 1, "delayToToggleMap")
      return
    end
    
    count = 0
    
    for i= 1, #playersGreen do
      if playersGreen[i].name == name then
        playersGreen[i].name = ''
        tfm.exec.killPlayer(name)
        removePlayerOnSpawnConfig(name)
        
        local movePlayer = addTimer(function(i)
          tfm.exec.respawnPlayer(name)
          teleportPlayersToSpecWithSpecificSpawn(name)
        end, 1000, 1, "movePlayer")
      end
      
      if playersGreen[i].name ~= '' then
        count = count + 1
      end
    end
    
    if count == 0 then
      ballOnGame = false
      ballOnGame2 = false
      ball_id = nil
      ball_id2 = nil
      updateTwoBallOnGame()
      tfm.exec.chatMessage("<vp>Green team lost all their lives<n>", nil)
      teamsLifes[4].green = 0
      toggleMapType()
      local index = 4

      if gameStats.threeTeamsMode then
        index = 3
      end

      updateTeamsColors(index)
      gameStats.canTransform = false
      disablePlayersCanTransform(4000)
      delayToToggleMap = addTimer(function(i)
        if i == 1 then
          toggleMap()
        end
      end, 3000, 1, "delayToToggleMap")
      return
    end
  elseif gameStats.typeMap == "large3v3" then
    for i = 1, #getTeamsLifes do
      for j = 1, #teamsPlayersOnGame[i] do
        if teamsPlayersOnGame[i][j].name == name then
          teamsPlayersOnGame[i][j].name = ''
          tfm.exec.killPlayer(name)
          removePlayerOnSpawnConfig(name)
          
          local movePlayer = addTimer(function(i)
            tfm.exec.respawnPlayer(name)
            teleportPlayersToSpecWithSpecificSpawn(name)
          end, 1000, 1, "movePlayer")
        end
        
        if teamsPlayersOnGame[i][j].name ~= '' then
          count = count + 1
        end
      end
      
      if count == 0 then
        if gameStats.threeTeamsMode then
          tfm.exec.chatMessage(messageTeamsLifes[index], nil)
          print(messageTeamsLifes[index])
          showTheScore()
          updateTeamsColors(index)
          showMessageWinner()
          ballOnGame = false
          ballOnGame2 = false
          ballOnGame3 = false
          ball_id = nil
          ball_id2 = nil
          ball_id3 = nil
          updateTwoBallOnGame()
          threeTeamsModeWinner(messageTeamsLifes[1], teamsPlayersOnGame[1])
          updateRankingThreeTeamsMode()
          tfm.exec.removeObject (ball_id)
          mode = "endGame"
          gameTimeEnd = os.time() + 5000
          return
        end

        ballOnGame = false
        ballOnGame2 = false
        ball_id = nil
        ball_id2 = nil
        updateTwoBallOnGame()
        tfm.exec.chatMessage(messageTeamsLifes[index], nil)
        print(messageTeamsLifes[index])
        updateTeamsColors(index)
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
      
      count = 0
      index = index + 1
    end
  elseif gameStats.typeMap == "small" then
    for i = 1, #getTeamsLifes do
      for j = 1, #teamsPlayersOnGame[i] do
        if teamsPlayersOnGame[i][j].name == name then
          teamsPlayersOnGame[i][j].name = ''
          tfm.exec.killPlayer(name)
          removePlayerOnSpawnConfig(name)
          
          local movePlayer = addTimer(function(i)
            tfm.exec.respawnPlayer(name)
            teleportPlayersToSpecWithSpecificSpawn(name)
          end, 1000, 1, "movePlayer")
        end
        
        if teamsPlayersOnGame[i][j].name ~= '' then
          count = count + 1
        end
      end
      
      if count == 0 then
        tfm.exec.chatMessage(messageTeamsLifes[index], nil)
        print(messageTeamsLifes[index])
        showTheScore()
        updateTeamsColors(index)
        showMessageWinner()
        ballOnGame = false
        ballOnGame2 = false
        ball_id = nil
        ball_id2 = nil
        updateTwoBallOnGame()
        fourTeamsModeWinner(messageTeamsLifes[1], teamsPlayersOnGame[1])
        updateRankingFourTeamsMode()
        tfm.exec.removeObject (ball_id)
        mode = "endGame"
        gameTimeEnd = os.time() + 5000
        return
      end
      
      count = 0
      index = index + 1
    end
  end
end