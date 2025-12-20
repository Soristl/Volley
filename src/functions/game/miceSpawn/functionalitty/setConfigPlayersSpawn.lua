function setConfigPlayersSpawn(isLargeMap, xNumber, yNumber, spawnPriority)
  if gameStats.threeTeamsMode then
    if xNumber >= 0 and xNumber <= 600 then
      playersSpawn400[#playersSpawn400 + 1] = { x = xNumber, y = yNumber, spawnPriority = spawnPriority, players = {} }
    end
    
    if xNumber >= 600 and xNumber <= 1200 then
      playersSpawn800[#playersSpawn800 + 1] = { x = xNumber, y = yNumber, spawnPriority = spawnPriority, players = {} }
    end
    
    if xNumber >= 1200 and xNumber <= 1800 then
      playersSpawn1200[#playersSpawn1200 + 1] = { x = xNumber, y = yNumber, spawnPriority = spawnPriority, players = {} }
    end
  else
    if isLargeMap then
      if xNumber >= 0 and xNumber <= 600 then
        playersSpawn800[#playersSpawn800 + 1] = { x = xNumber, y = yNumber, spawnPriority = spawnPriority, players = {}}
      end
      
      if xNumber >= 600 and xNumber <= 1200 then
        playersSpawn1600[#playersSpawn1600 + 1] = { x = xNumber , y = yNumber, spawnPriority = spawnPriority, players = {} }
      end
    else
      if xNumber >= 0 and xNumber <= 400 then
        playersSpawn400[#playersSpawn400 + 1] = { x = xNumber, y = yNumber, spawnPriority = spawnPriority, players = {} }
      end
      
      if xNumber >= 400 and xNumber <= 800 then
        playersSpawn800[#playersSpawn800 + 1] = { x = xNumber, y = yNumber, spawnPriority = spawnPriority, players = {} }
      end
      
      if xNumber >= 800 and xNumber <= 1200 then
        playersSpawn1200[#playersSpawn1200 + 1] = { x = xNumber, y = yNumber, spawnPriority = spawnPriority, players = {} }
      end
      
      if xNumber >= 1200 and xNumber <= 1600 then
        playersSpawn1600[#playersSpawn1600 + 1] = { x = xNumber, y = yNumber, spawnPriority = spawnPriority, players = {} }
      end
    end
  end
end