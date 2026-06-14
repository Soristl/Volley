function chooseTeamTeamsMode(name)
  local quantity = getQuantityPlayers()
  local smallQuantity = ""
  if gameStats.typeMap == "large4v4" then
    smallQuantity = getSmallQuantity(quantity)
  else
    smallQuantity = getSmallQuantity1(quantity)
  end
  if gameStats.typeMap == "large4v4" then
    if smallQuantity[2] == 1 and quantity.yellow < 3 then
      for i = 1, #playersYellow do
        if playersYellow[i].name == '' then
          local isNewTeam = playerHistoryOnMatch("yellow", name)

          if isNewTeam then
            local playerTeams = playersOnGameHistoric[name].teams
            playersOnGameHistoric[name].teams[#playerTeams + 1] = "yellow"

            addMatchToPlayerFourTeamsMode(name)
          end
          playersYellow[i].name = name
          playerInGame[name] = true
          tfm.exec.setNameColor(playersYellow[i].name, 0xF59E0B)
          if #playersSpawn400 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn400, name)
          else
            tfm.exec.movePlayer(name, 200, 334)
          end

          disablePlayerCanTransform(name)

          return
        end
      end
    elseif smallQuantity[2] == 2 and quantity.red < 3 then
      for i = 1, #playersRed do
        if playersRed[i].name == '' then
          local isNewTeam = playerHistoryOnMatch("red", name)

          if isNewTeam then
            local playerTeams = playersOnGameHistoric[name].teams
            playersOnGameHistoric[name].teams[#playerTeams + 1] = "red"

            addMatchToPlayerFourTeamsMode(name)
          end
          playersRed[i].name = name
          playerInGame[name] = true
          tfm.exec.setNameColor(playersRed[i].name, 0xEF4444)
          if #playersSpawn800 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn800, name)
          else
            tfm.exec.movePlayer(name, 600, 334)
          end

          disablePlayerCanTransform(name)

          return
        end
      end
    elseif smallQuantity[2] == 3 and quantity.blue < 3 then
      for i = 1, #playersBlue do
        if playersBlue[i].name == '' then
          local isNewTeam = playerHistoryOnMatch("blue", name)

          if isNewTeam then
            local playerTeams = playersOnGameHistoric[name].teams
            playersOnGameHistoric[name].teams[#playerTeams + 1] = "blue"

            addMatchToPlayerFourTeamsMode(name)
          end
          playersBlue[i].name = name
          playerInGame[name] = true
          tfm.exec.setNameColor(playersBlue[i].name, 0x3B82F6)
          if #playersSpawn1200 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn1200, name)
          else
            tfm.exec.movePlayer(name, 1000, 334)
          end

          disablePlayerCanTransform(name)

          return
        end
      end
    elseif smallQuantity[2] == 4 and quantity.green < 3 then
      for i = 1, #playersGreen do
        if playersGreen[i].name == '' then
          local isNewTeam = playerHistoryOnMatch("green", name)

          if isNewTeam then
            local playerTeams = playersOnGameHistoric[name].teams
            playersOnGameHistoric[name].teams[#playerTeams + 1] = "green"

            addMatchToPlayerFourTeamsMode(name)
          end
          playersGreen[i].name = name
          playerInGame[name] = true
          tfm.exec.setNameColor(playersGreen[i].name, 0x109267)
          if #playersSpawn1600 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn1600, name)
          else
            tfm.exec.movePlayer(name, 1400, 334)
          end

          disablePlayerCanTransform(name)

          return
        end
      end
    else
      tfm.exec.chatMessage("<bv>The teams are full<n>", name)
    end
  elseif gameStats.typeMap == "large3v3" or gameStats.typeMap == "small" then
    local x = { 200, 600, 1000 }
    local playersSpawn = { playersSpawn400, playersSpawn800, playersSpawn1200 }
    print("a")
    print(smallQuantity[2])
    for i = 1, #teamsPlayersOnGame do
      if i == smallQuantity[2] then
        for j = 1, #teamsPlayersOnGame[smallQuantity[2]] do
          if teamsPlayersOnGame[smallQuantity[2]][j].name == '' then
            local team = getTeamName(messageTeamsLifes[smallQuantity[2]])

            if team == "Yellow" then
              local isNewTeam = playerHistoryOnMatch("yellow", name)

              if isNewTeam then
                local playerTeams = playersOnGameHistoric[name].teams
                playersOnGameHistoric[name].teams[#playerTeams + 1] = "yellow"

                addMatchToPlayerFourTeamsMode(name)
              end
            elseif team == "Red" then
              local isNewTeam = playerHistoryOnMatch("red", name)

              if isNewTeam then
                local playerTeams = playersOnGameHistoric[name].teams
                playersOnGameHistoric[name].teams[#playerTeams + 1] = "red"

                addMatchToPlayerFourTeamsMode(name)
              end
            elseif team == "Blue" then
              local isNewTeam = playerHistoryOnMatch("blue", name)

              if isNewTeam then
                local playerTeams = playersOnGameHistoric[name].teams
                playersOnGameHistoric[name].teams[#playerTeams + 1] = "blue"

                addMatchToPlayerFourTeamsMode(name)
              end
            elseif team == "Green" then
              local isNewTeam = playerHistoryOnMatch("green", name)

              if isNewTeam then
                local playerTeams = playersOnGameHistoric[name].teams
                playersOnGameHistoric[name].teams[#playerTeams + 1] = "green"

                addMatchToPlayerFourTeamsMode(name)
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
