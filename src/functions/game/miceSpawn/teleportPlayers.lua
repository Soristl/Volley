function teleportPlayers()
  teleportPlayersToSpec()

  if gameStats.twoTeamsMode then
    local spawnOnMiddle = true
    for i = 1, #playersRed do
      if playersRed[i].name ~= '' then
        playersOnGameHistoric[playersRed[i].name] = { teams = {"red"} }
        if spawnOnMiddle then
          if #playersSpawn800 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn800, playersRed[i].name)
          else
            tfm.exec.movePlayer(playersRed[i].name, 600, 334)
          end
          
          tfm.exec.setNameColor(playersRed[i].name, 0xEF4444)
          twoTeamsPlayerRedPosition[i] = "middle"
          
          spawnOnMiddle = false
        else
          if #playersSpawn1600 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn1600, playersRed[i].name)
          else
            tfm.exec.movePlayer(playersRed[i].name, 1400, 334)
          end
          
          tfm.exec.setNameColor(playersRed[i].name, 0xEF4444)
          
          twoTeamsPlayerRedPosition[i] = "back"
          
          spawnOnMiddle = true
        end
        
      end
      
    end
    
    local spawnOnMiddle = true
    for i = 1, #playersBlue do
      if playersBlue[i].name ~= '' then
        playersOnGameHistoric[playersBlue[i].name] = { teams = {"blue"} }
        if spawnOnMiddle then
          if #playersSpawn1200 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn1200, playersBlue[i].name)
          else
            tfm.exec.movePlayer(playersBlue[i].name, 1000, 334)
          end
          tfm.exec.setNameColor(playersBlue[i].name, 0x3B82F6)
          twoTeamsPlayerBluePosition[i] = "middle"
          
          spawnOnMiddle = false
        else
          if #playersSpawn400 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn400, playersBlue[i].name)
          else
            tfm.exec.movePlayer(playersBlue[i].name, 200, 334)
          end
          
          tfm.exec.setNameColor(playersBlue[i].name, 0x3B82F6)
          twoTeamsPlayerBluePosition[i] = "back"
          
          spawnOnMiddle = true
        end
      end
      
    end
    
    return
  end

  if gameStats.teamsMode then
    for i = 1, #playersYellow do
      if playersYellow[i].name ~= '' then
        playersOnGameHistoric[playersYellow[i].name] = { teams = {"yellow"} }
        if #playersSpawn400 > 0 then
          teleportPlayerWithSpecificSpawn(playersSpawn400, playersYellow[i].name)
        else
          tfm.exec.movePlayer(playersYellow[i].name, 200, 334)
        end
        
        tfm.exec.setNameColor(playersYellow[i].name, 0xF59E0B)
      end
    end
    for i = 1, #playersRed do
      if playersRed[i].name ~= '' then
        playersOnGameHistoric[playersRed[i].name] = { teams = {"red"} }
        if #playersSpawn800 > 0 then
          teleportPlayerWithSpecificSpawn(playersSpawn800, playersRed[i].name)
        else
          tfm.exec.movePlayer(playersRed[i].name, 600, 334)
        end
        
        tfm.exec.setNameColor(playersRed[i].name, 0xEF4444)
      end
    end
    for i = 1, #playersBlue do
      if playersBlue[i].name ~= '' then
        playersOnGameHistoric[playersBlue[i].name] = { teams = {"blue"} }
        if #playersSpawn1200 > 0 then
          teleportPlayerWithSpecificSpawn(playersSpawn1200, playersBlue[i].name)
        else
          tfm.exec.movePlayer(playersBlue[i].name, 1000, 334)
        end
        
        tfm.exec.setNameColor(playersBlue[i].name, 0x3B82F6)
      end
    end
    for i = 1, #playersGreen do
      if playersGreen[i].name ~= '' then
        playersOnGameHistoric[playersGreen[i].name] = { teams = {"green"} }
        if #playersSpawn1600 > 0 then
          teleportPlayerWithSpecificSpawn(playersSpawn1600, playersGreen[i].name)
        else
          tfm.exec.movePlayer(playersGreen[i].name, 1400, 334)
        end
        
        tfm.exec.setNameColor(playersGreen[i].name, 0x109267)
      end
    end
    
    return
  end

  if gameStats.threeTeamsMode then
    for i = 1, #playersRed do
      if playersRed[i].name ~= '' then
        playersOnGameHistoric[playersRed[i].name] = { teams = {"red"} }
        if #playersSpawn400 > 0 then
          teleportPlayerWithSpecificSpawn(playersSpawn400, playersRed[i].name)
        else
          tfm.exec.movePlayer(playersRed[i].name, 300, 334)
        end
        
        tfm.exec.setNameColor(playersRed[i].name, 0xEF4444)
      end
    end

    for i = 1, #playersBlue do
      if playersBlue[i].name ~= '' then
        playersOnGameHistoric[playersBlue[i].name] = { teams = {"blue"} }
        if #playersSpawn800 > 0 then
          teleportPlayerWithSpecificSpawn(playersSpawn800, playersBlue[i].name)
        else
          tfm.exec.movePlayer(playersBlue[i].name, 900, 334)
        end
        
        tfm.exec.setNameColor(playersBlue[i].name, 0x3B82F6)
      end
    end

    for i = 1, #playersGreen do
      if playersGreen[i].name ~= '' then
        playersOnGameHistoric[playersGreen[i].name] = { teams = {"green"} }
        if #playersSpawn1200 > 0 then
          teleportPlayerWithSpecificSpawn(playersSpawn1200, playersGreen[i].name)
        else
          tfm.exec.movePlayer(playersGreen[i].name, 1500, 334)
        end
        
        tfm.exec.setNameColor(playersGreen[i].name, 0x109267)
      end
    end

    return
  end

  for i = 1, #playersRed do
    if playersRed[i].name ~= '' then
      playersOnGameHistoric[playersRed[i].name] = { teams = {"red"} }
      
      if gameStats.realMode then
        tfm.exec.movePlayer(playersRed[i].name, 900, 334)
      else
        if gameStats.gameMode == "3v3" then
          if #playersSpawn400 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn400, playersRed[i].name)
          else
            tfm.exec.movePlayer(playersRed[i].name, 101, 334)
          end
        elseif gameStats.gameMode == "4v4" then
          if #playersSpawn800 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn800, playersRed[i].name)
          else
            tfm.exec.movePlayer(playersRed[i].name, 301, 334)
          end
        else
          tfm.exec.movePlayer(playersRed[i].name, 401, 334)
        end
      end
      
      
      tfm.exec.setNameColor(playersRed[i].name, 0xEF4444)
    end
  end
  for i = 1, #playersBlue do
    if playersBlue[i].name ~= '' then
      playersOnGameHistoric[playersBlue[i].name] = { teams = {"blue"} }
      if gameStats.realMode then
        tfm.exec.movePlayer(playersBlue[i].name, 1700, 334)
      else
        if gameStats.gameMode == "3v3" then
          if #playersSpawn800 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn800, playersBlue[i].name)
          else
            tfm.exec.movePlayer(playersBlue[i].name, 700, 334)
          end
        elseif gameStats.gameMode == "4v4" then
          if #playersSpawn1600 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn1600, playersBlue[i].name)
          else
            tfm.exec.movePlayer(playersBlue[i].name, 900, 334)
          end
        else
          tfm.exec.movePlayer(playersBlue[i].name, 1500, 334)
        end
        tfm.exec.setNameColor(playersBlue[i].name, 0x3B82F6)
      end
    end
  end
end
