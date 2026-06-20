function setConfigPlayersSpawn(isLargeMap, xNumber, yNumber, spawnPriority, teams)
  if gameStats.threeTeamsMode then
    if teams[1] ~= nil or teams[2] ~= nil or teams[3] ~= nil then
      if teams[1] ~= nil then
        playersSpawn400[#playersSpawn400 + 1] = { x = xNumber, y = yNumber, spawnPriority = spawnPriority, players = {} }
      end

      if teams[2] ~= nil then
        playersSpawn800[#playersSpawn800 + 1] = { x = xNumber, y = yNumber, spawnPriority = spawnPriority, players = {} }
      end

      if teams[3] ~= nil then
        playersSpawn1200[#playersSpawn1200 + 1] = { x = xNumber, y = yNumber, spawnPriority = spawnPriority, players = {} }
      end
    else
      if xNumber >= 0 and xNumber <= 600 then
        playersSpawn400[#playersSpawn400 + 1] = { x = xNumber, y = yNumber, spawnPriority = spawnPriority, players = {} }
      end

      if xNumber >= 600 and xNumber <= 1200 then
        playersSpawn800[#playersSpawn800 + 1] = { x = xNumber, y = yNumber, spawnPriority = spawnPriority, players = {} }
      end

      if xNumber >= 1200 and xNumber <= 1800 then
        playersSpawn1200[#playersSpawn1200 + 1] = { x = xNumber, y = yNumber, spawnPriority = spawnPriority, players = {} }
      end
    end
  else
    if isLargeMap then
      if teams[1] ~= nil or teams[2] ~= nil then
        if teams[1] ~= nil then
          playersSpawn800[#playersSpawn800 + 1] = { x = xNumber, y = yNumber, spawnPriority = spawnPriority, players = {}}
        end

        if teams[2] ~= nil then
          playersSpawn1600[#playersSpawn1600 + 1] = { x = xNumber , y = yNumber, spawnPriority = spawnPriority, players = {} }
        end
      else
        if xNumber >= 0 and xNumber <= 600 then
          playersSpawn800[#playersSpawn800 + 1] = { x = xNumber, y = yNumber, spawnPriority = spawnPriority, players = {}}
        end
      
        if xNumber >= 600 and xNumber <= 1200 then
          playersSpawn1600[#playersSpawn1600 + 1] = { x = xNumber , y = yNumber, spawnPriority = spawnPriority, players = {} }
        end
      end
    else
      if teams[1] ~= nil or teams[2] ~= nil or teams[3] ~= nil or teams[4] ~= nil then
        if teams[1] ~= nil then
          playersSpawn400[#playersSpawn400 + 1] = { x = xNumber, y = yNumber, spawnPriority = spawnPriority, players = {} }
        end

        if teams[2] ~= nil then
          playersSpawn800[#playersSpawn800 + 1] = { x = xNumber, y = yNumber, spawnPriority = spawnPriority, players = {} }
        end

        if teams[3] ~= nil then
          playersSpawn1200[#playersSpawn1200 + 1] = { x = xNumber, y = yNumber, spawnPriority = spawnPriority, players = {} }
        end

        if teams[4] ~= nil then
          playersSpawn1600[#playersSpawn1600 + 1] = { x = xNumber, y = yNumber, spawnPriority = spawnPriority, players = {} }
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
end
