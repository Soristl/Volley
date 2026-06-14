function teleportOnePlayerTeamsMode(name)
  if gameStats.typeMap == "large4v4" then
    for i= 1, #playersYellow do
      if playersYellow[i].name == name then
        tfm.exec.setNameColor(playersYellow[i].name, 0xF59E0B)
        if #playersSpawn400 > 0 then
          teleportPlayerWithSpecificSpawn(playersSpawn400, name)
        else
          tfm.exec.movePlayer(name, 200, 334)
        end
                
        return
      end
    end
    for i= 1, #playersRed do
      if playersRed[i].name == name then
        tfm.exec.setNameColor(playersRed[i].name, 0xEF4444)
        if #playersSpawn800 > 0 then
          teleportPlayerWithSpecificSpawn(playersSpawn800, name)
        else
          tfm.exec.movePlayer(name, 600, 334)
        end
                
        return
      end
    end
    for i= 1, #playersBlue do
      if playersBlue[i].name == name then
        tfm.exec.setNameColor(playersBlue[i].name, 0x3B82F6)
        if #playersSpawn1200 > 0 then
          teleportPlayerWithSpecificSpawn(playersSpawn1200, name)
        else
          tfm.exec.movePlayer(name, 1000, 334)
        end
                
        return
      end
    end
    for i= 1, #playersGreen do
      if playersGreen[i].name == name then
        tfm.exec.setNameColor(playersGreen[i].name, 0x109267)
        if #playersSpawn1600 > 0 then
          teleportPlayerWithSpecificSpawn(playersSpawn1600, name)
        else
          tfm.exec.movePlayer(name, 1400, 334)
        end
                
        return
      end
    end
  elseif gameStats.typeMap == "large3v3" or gameStats.typeMap == "small" then
    local x = {200, 600, 1000}
    local playersSpawn = { playersSpawn400, playersSpawn800, playersSpawn1200 }
    
    if gameStats.threeTeamsMode then
      x = {300, 900}
      playersSpawn = { playersSpawn400, playersSpawn800 }
    end
    
    print("a")
    for i = 1, #teamsPlayersOnGame do
      for j = 1, #teamsPlayersOnGame[i] do
        if teamsPlayersOnGame[i][j].name == name then
          tfm.exec.setNameColor(name, getTeamsColorsName[i])
          if #playersSpawn[i] > 0 then
            teleportPlayerWithSpecificSpawn(playersSpawn[i], name)
          else
            tfm.exec.movePlayer(name, x[i], 334)
          end
                    
          return
        end
      end
    end
  end
end