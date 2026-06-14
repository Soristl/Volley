function teleportOnePlayer(name)
  for i = 1, 6 do
    if playersRed[i].name == name then      
      tfm.exec.setNameColor(playersRed[i].name, 0xEF4444)
      
      if gameStats.realMode then
        tfm.exec.movePlayer(name, 900, 334)
        
        return
      end
      
      if gameStats.twoTeamsMode then        
        if twoTeamsPlayerRedPosition[i] == "middle" then
          if #playersSpawn800 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn800, name)
          else
            tfm.exec.movePlayer(name, 600, 334)
          end          
        elseif twoTeamsPlayerRedPosition[i] == "back" then
          if #playersSpawn1600 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn1600, name)
          else
            tfm.exec.movePlayer(name, 1400, 334)
          end
        else
          if #playersSpawn800 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn800, name)
          else
            tfm.exec.movePlayer(name, 600, 334)
          end
        end
        
        return
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
      
      return
    end
  end

  for i = 1, 6 do
    if playersBlue[i].name == name then      
      tfm.exec.setNameColor(playersBlue[i].name, 0x3B82F6)
      
      if gameStats.realMode then
        tfm.exec.movePlayer(name, 1700, 334)
        
        return
      end
      
      if gameStats.twoTeamsMode then        
        if twoTeamsPlayerBluePosition[i] == "middle" then
          if #playersSpawn1200 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn1200, name)
          else
            tfm.exec.movePlayer(name, 1000, 334)
          end          
        elseif twoTeamsPlayerBluePosition[i] == "back" then
          if #playersSpawn400 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn400, name)
          else
            tfm.exec.movePlayer(name, 200, 334)
          end
        else
          if #playersSpawn1200 > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn1200, name)
          else
            tfm.exec.movePlayer(name, 1000, 334)
          end          
        end
        
        return
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
      
      return
    end
  end
end