function chooseTeamThreeTeamsMode(name)
  local quantity = getQuantityPlayers()
  local smallQuantity = ""
  if gameStats.typeMap == "large4v4" then
    smallQuantity = getSmallQuantity(quantity)
  else
    smallQuantity = getSmallQuantity1(quantity)
  end
  if gameStats.typeMap == "large4v4" then
    if smallQuantity[2] == 1 and quantity.red < 4 then
      for i= 1, #playersRed do
        if playersRed[i].name == '' then
          local isNewTeam = playerHistoryOnMatch("red", name)
          
          if isNewTeam then
            local playerTeams = playersOnGameHistoric[name].teams
            playersOnGameHistoric[name].teams[#playerTeams + 1] = "red"
            
            addMatchToPlayerThreeTeamsMode(name)
          end
          playersRed[i].name = name
          playerInGame[name] = true
          tfm.exec.setNameColor(playersRed[i].name, 0xEF4444)
          if #playersSpawn400 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn400, name)
          else
            tfm.exec.movePlayer(name, 300, 334)
          end
          
          disablePlayerCanTransform(name)
          
          return
        end
      end
    elseif smallQuantity[2] == 2 and quantity.blue < 4 then
      for i= 1, #playersBlue do
        if playersBlue[i].name == '' then
          local isNewTeam = playerHistoryOnMatch("blue", name)
          
          if isNewTeam then
            local playerTeams = playersOnGameHistoric[name].teams
            playersOnGameHistoric[name].teams[#playerTeams + 1] = "blue"
            
            addMatchToPlayerThreeTeamsMode(name)
          end
          playersBlue[i].name = name
          playerInGame[name] = true
          tfm.exec.setNameColor(playersBlue[i].name, 0x3B82F6)
          if #playersSpawn800 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn800, name)
          else
            tfm.exec.movePlayer(name, 900, 334)
          end
          
          disablePlayerCanTransform(name)
          
          return
        end
      end
    elseif smallQuantity[2] == 3 and quantity.green < 4 then
      for i= 1, #playersGreen do
        if playersGreen[i].name == '' then
          local isNewTeam = playerHistoryOnMatch("green", name)
          
          if isNewTeam then
            local playerTeams = playersOnGameHistoric[name].teams
            playersOnGameHistoric[name].teams[#playerTeams + 1] = "green"
            
            addMatchToPlayerThreeTeamsMode(name)
          end
          playersGreen[i].name = name
          playerInGame[name] = true
          tfm.exec.setNameColor(playersGreen[i].name, 0x109267)
          if #playersSpawn1200 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn1200, name)
          else
            tfm.exec.movePlayer(name, 1500, 334)
          end
          
          disablePlayerCanTransform(name)
          
          return
        end
      end
    else
      tfm.exec.chatMessage("<bv>The teams are full<n>", name)
    end
  elseif gameStats.typeMap == "large3v3" or gameStats.typeMap == "small" then
    local x = {200, 600, 1000}
    local playersSpawn = { playersSpawn400, playersSpawn800, playersSpawn1200 }

    if gameStats.threeTeamsMode then
      x = {300, 900}
      playersSpawn = { playersSpawn400, playersSpawn800 }
    end

    print("a")
    print(smallQuantity[2])
    for i = 1, #teamsPlayersOnGame do
      if i == smallQuantity[2] then
        for j = 1, #teamsPlayersOnGame[smallQuantity[2]] do
          if teamsPlayersOnGame[smallQuantity[2]][j].name == '' then
            local team = getTeamName(messageTeamsLifes[smallQuantity[2]])
            
            if team == "Red" then
              local isNewTeam = playerHistoryOnMatch("red", name)
              
              if isNewTeam then
                local playerTeams = playersOnGameHistoric[name].teams
                playersOnGameHistoric[name].teams[#playerTeams + 1] = "red"
                
                addMatchToPlayerThreeTeamsMode(name)
              end
            elseif team == "Blue" then
              local isNewTeam = playerHistoryOnMatch("blue", name)
              
              if isNewTeam then
                local playerTeams = playersOnGameHistoric[name].teams
                playersOnGameHistoric[name].teams[#playerTeams + 1] = "blue"
                
                addMatchToPlayerThreeTeamsMode(name)
              end
            elseif team == "Green" then
              local isNewTeam = playerHistoryOnMatch("green", name)
              
              if isNewTeam then
                local playerTeams = playersOnGameHistoric[name].teams
                playersOnGameHistoric[name].teams[#playerTeams + 1] = "green"
                
                addMatchToPlayerThreeTeamsMode(name)
              end
            end
            teamsPlayersOnGame[smallQuantity[2]][j].name = name
            playerInGame[name] = true
            tfm.exec.setNameColor(name, getTeamsColorsName[smallQuantity[2]])
            if #playersSpawn[smallQuantity[2]] > 0 then
              teleportPlayerWithSpecificSpawn(playersSpawn[smallQuantity[2]], name)
            else
              tfm.exec.movePlayer(name, x[smallQuantity[2]], 334)
            end
            
            disablePlayerCanTransform(name)
            
            return
          end
        end
      end
    end
  end
end