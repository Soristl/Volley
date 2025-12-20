function chooseTeam(name)
  local maxPlayersOnGame = maxPlayers()
  if gameStats.twoTeamsMode or gameStats.realMode then
    maxPlayersOnGame = 6
  end
  local quantity = quantityPlayers()
  if quantity.red < quantity.blue and quantity.red < maxPlayersOnGame then
    for i = 1, 6 do
      if playersRed[i].name == '' then
        local isNewTeam = playerHistoryOnMatch("red", name)
        
        if isNewTeam then
          local playerTeams = playersOnGameHistoric[name].teams
          playersOnGameHistoric[name].teams[#playerTeams + 1] = "red"
          
          if gameStats.twoTeamsMode then
            addMatchToPlayerTwoTeamsMode(name)
          elseif gameStats.realMode then
            addMatchToPlayerRealMode(name)
          else
            addMatchToPlayer(name)
          end
        end
        playersRed[i].name = name
        playerInGame[name] = true
        tfm.exec.setNameColor(playersRed[i].name, 0xEF4444)
        disablePlayerCanTransform(name)
        
        if gameStats.realMode then
          tfm.exec.movePlayer(name, 900, 334)
          
          return
        end
        
        if gameStats.twoTeamsMode then
          local quantity = getQuantityPlayersOnPosition("red")
          
          if quantity.middle < quantity.back then
            if #playersSpawn800 > 0 then
              teleportPlayerWithSpecificSpawn(playersSpawn800, name)
            else
              tfm.exec.movePlayer(name, 600, 334)
            end
            
            twoTeamsPlayerRedPosition[i] = "middle"
          elseif quantity.back < quantity.middle then
            if #playersSpawn1600 > 0 then
              teleportPlayerWithSpecificSpawn(playersSpawn1600, name)
            else
              tfm.exec.movePlayer(name, 1400, 334)
            end
            
            twoTeamsPlayerRedPosition[i] = "back"
          else
            if #playersSpawn800 > 0 then
              teleportPlayerWithSpecificSpawn(playersSpawn800, name)
            else
              tfm.exec.movePlayer(name, 600, 334)
            end
            
            twoTeamsPlayerRedPosition[i] = "middle"
          end
          
          break
        end
        if gameStats.gameMode == "3v3" then
          if #playersSpawn400 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn400, name)
          else
            tfm.exec.movePlayer(name, 101, 334)
          end
        elseif gameStats.gameMode == "4v4" then
          if #playersSpawn800 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn800, name)
          else
            tfm.exec.movePlayer(name, 301, 334)
          end
        else
          tfm.exec.movePlayer(name, 401, 334)
        end
        
        break
      end
    end
    return
  elseif quantity.blue < quantity.red and quantity.blue < maxPlayersOnGame then
    for i = 1, 6 do
      if playersBlue[i].name == '' then
        local isNewTeam = playerHistoryOnMatch("blue", name)
        
        if isNewTeam then
          local playerTeams = playersOnGameHistoric[name].teams
          playersOnGameHistoric[name].teams[#playerTeams + 1] = "blue"
          
          if gameStats.twoTeamsMode then
            addMatchToPlayerTwoTeamsMode(name)
          elseif gameStats.realMode then
            addMatchToPlayerRealMode(name)
          else
            addMatchToPlayer(name)
          end
        end
        playersBlue[i].name = name
        playerInGame[name] = true
        tfm.exec.setNameColor(playersBlue[i].name, 0x3B82F6)
        disablePlayerCanTransform(name)
        
        if gameStats.realMode then
          tfm.exec.movePlayer(name, 1700, 334)
          
          return
        end
        
        if gameStats.twoTeamsMode then
          local quantity = getQuantityPlayersOnPosition("blue")
          
          if quantity.middle < quantity.back then
            if #playersSpawn1200 > 0 then
              teleportPlayerWithSpecificSpawn(playersSpawn1200, name)
            else
              tfm.exec.movePlayer(name, 1000, 334)
            end
            
            twoTeamsPlayerBluePosition[i] = "middle"
          elseif quantity.back < quantity.middle then
            if #playersSpawn400 > 0 then
              teleportPlayerWithSpecificSpawn(playersSpawn400, name)
            else
              tfm.exec.movePlayer(name, 200, 334)
            end
            
            twoTeamsPlayerBluePosition[i] = "back"
          else
            if #playersSpawn1200 > 0 then
              teleportPlayerWithSpecificSpawn(playersSpawn1200, name)
            else
              tfm.exec.movePlayer(name, 1000, 334)
            end
            
            twoTeamsPlayerBluePosition[i] = "middle"
          end
          
          break
        end
        if gameStats.gameMode == "3v3" then
          if #playersSpawn800 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn800, name)
          else
            tfm.exec.movePlayer(name, 700, 334)
          end
        elseif gameStats.gameMode == "4v4" then
          if #playersSpawn1600 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn1600, name)
          else
            tfm.exec.movePlayer(name, 900, 334)
          end
        else
          tfm.exec.movePlayer(name, 1500, 334)
        end
        
        break
      end
    end
    return
  elseif quantity.red == quantity.blue and quantity.red < maxPlayersOnGame then
    for i = 1, 6 do
      if playersRed[i].name == '' then
        local isNewTeam = playerHistoryOnMatch("red", name)
        
        if isNewTeam then
          local playerTeams = playersOnGameHistoric[name].teams
          playersOnGameHistoric[name].teams[#playerTeams + 1] = "red"
          
          if gameStats.twoTeamsMode then
            addMatchToPlayerTwoTeamsMode(name)
          elseif gameStats.realMode then
            addMatchToPlayerRealMode(name)
          else
            addMatchToPlayer(name)
          end
        end
        playersRed[i].name = name
        playerInGame[name] = true
        tfm.exec.setNameColor(playersRed[i].name, 0xEF4444)
        disablePlayerCanTransform(name)
        
        if gameStats.realMode then
          tfm.exec.movePlayer(name, 900, 334)
          
          return
        end
        
        if gameStats.twoTeamsMode then
          local quantity = getQuantityPlayersOnPosition("red")
          print(quantity.middle)
          print(quantity.back)
          
          if quantity.middle < quantity.back then
            tfm.exec.movePlayer(name, 600, 334)
            twoTeamsPlayerRedPosition[i] = "middle"
          elseif quantity.back < quantity.middle then
            tfm.exec.movePlayer(name, 1400, 334)
            twoTeamsPlayerRedPosition[i] = "back"
          else
            tfm.exec.movePlayer(name, 600, 334)
            twoTeamsPlayerRedPosition[i] = "middle"
          end
          
          break
        end
        if gameStats.gameMode == "3v3" then
          if #playersSpawn400 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn400, name)
          else
            tfm.exec.movePlayer(name, 101, 334)
          end
        elseif gameStats.gameMode == "4v4" then
          if #playersSpawn800 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn800, name)
          else
            tfm.exec.movePlayer(name, 301, 334)
          end
        else
          tfm.exec.movePlayer(name, 401, 334)
        end
        
        break
      end
    end
    return
  else
    tfm.exec.chatMessage("<bv>The teams are full<n>", name)
  end
end