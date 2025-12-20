function foundBallSpawnsOnMap(map, isLargeMap)
  local tags_T131 = {}
  spawnBallArea400 = {}
  spawnBallArea800 = {}
  spawnBallArea1200 = {}
  spawnBallArea1600 = {}
  
  local mapXML = ""
  
  if #map > 10 then
    mapXML = map
  else
    mapXML = tfm.get.room.xmlMapInfo.xml
  end
  
  for tag in string.gmatch(mapXML, '<P[^>]*T="131"[^>]*/?>') do
    table.insert(tags_T131, tag)
  end
  
  for _, tag in ipairs(tags_T131) do
    local xString = tag:match('X="(%d+)"')
    local yString = tag:match('Y="(%d+)"')
    
    local x = tonumber(xString)
    local y = tonumber(yString)
    if gameStats.threeTeamsMode then
      if x >= 0 and x <= 600 then
        spawnBallArea400[#spawnBallArea400 + 1] = { x = x, y = y}
      end
      if x >= 600 and x <= 1200 then
        spawnBallArea800[#spawnBallArea800 + 1] = { x  = x, y = y}
      end
      if x >= 1200 and x <= 1800 then
        spawnBallArea1200[#spawnBallArea1200 + 1] = { x = x, y = y}
      end
    else
      if isLargeMap then
        if x >= 0 and x <= 600 then
          spawnBallArea800[#spawnBallArea800 + 1] = {x = x, y = y}
        end
        if x >= 600 and x <= 1200 then
          spawnBallArea1600[#spawnBallArea1600 + 1] = {x = x, y = y}
        end
      else
        if x >= 0 and x <= 400 then
          spawnBallArea400[#spawnBallArea400 + 1] = { x = x, y = y}
        end
        if x >= 400 and x <= 800 then
          spawnBallArea800[#spawnBallArea800 + 1] = { x  = x, y = y}
        end
        if x >= 800 and x <= 1200 then
          spawnBallArea1200[#spawnBallArea1200 + 1] = { x = x, y = y}
        end
        if x >= 1200 and x <= 1600 then
          spawnBallArea1600[#spawnBallArea1600 + 1] = { x = x, y = y}
        end
      end
    end
  end
end