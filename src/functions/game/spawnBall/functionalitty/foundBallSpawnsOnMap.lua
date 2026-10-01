function foundBallSpawnsOnMap(map, isLargeMap)
  local tags_T131 = {}
  spawnBallArea400 = {}
  spawnBallArea800 = {}
  spawnBallArea1200 = {}
  spawnBallArea1600 = {}

  local mapXML = mapXml.spawnSource(map)
  for tag in mapXML:gmatch('<P%s+[^>]*>') do
    if mapXml.attribute(tag, "T") == "131" then tags_T131[#tags_T131 + 1] = tag end
  end

  for _, tag in ipairs(tags_T131) do
    local x = mapXml.number(mapXml.attribute(tag, "X"))
    local y = mapXml.number(mapXml.attribute(tag, "Y"))
    local team1 = mapXml.attribute(tag, "team1")
    local team2 = mapXml.attribute(tag, "team2")
    local team3 = mapXml.attribute(tag, "team3")
    local team4 = mapXml.attribute(tag, "team4")
    if x and y then
      if gameStats.threeTeamsMode then
        if team1 ~= nil or team2 ~= nil or team3 ~= nil then
          if team1 ~= nil then
            spawnBallArea400[#spawnBallArea400 + 1] = { x = x, y = y}
          end

          if team2 ~= nil then
            spawnBallArea800[#spawnBallArea800 + 1] = { x  = x, y = y}
          end

          if team3 ~= nil then
            spawnBallArea1200[#spawnBallArea1200 + 1] = { x = x, y = y}
          end
        else
          if x >= 0 and x <= 600 then
            spawnBallArea400[#spawnBallArea400 + 1] = { x = x, y = y}
          end
          if x >= 600 and x <= 1200 then
            spawnBallArea800[#spawnBallArea800 + 1] = { x  = x, y = y}
          end
          if x >= 1200 and x <= 1800 then
            spawnBallArea1200[#spawnBallArea1200 + 1] = { x = x, y = y}
          end
        end
      else
        if isLargeMap then
          if team1 ~= nil or team2 ~= nil then
            if team1 ~= nil then
              spawnBallArea800[#spawnBallArea800 + 1] = {x = x, y = y}
            end

            if team2 ~= nil then
              spawnBallArea1600[#spawnBallArea1600 + 1] = {x = x, y = y}
            end
          else
            if x >= 0 and x <= 600 then
              spawnBallArea800[#spawnBallArea800 + 1] = {x = x, y = y}
            end
            if x >= 600 and x <= 1200 then
              spawnBallArea1600[#spawnBallArea1600 + 1] = {x = x, y = y}
            end
          end
        else
          if team1 ~= nil or team2 ~= nil or team3 ~= nil or team4 ~= nil then
            if team1 ~= nil then
              spawnBallArea400[#spawnBallArea400 + 1] = { x = x, y = y}
            end

            if team2 ~= nil then
              spawnBallArea800[#spawnBallArea800 + 1] = { x  = x, y = y}
            end

            if team3 ~= nil then
              spawnBallArea1200[#spawnBallArea1200 + 1] = { x = x, y = y}
            end

            if team4 ~= nil then
              spawnBallArea1600[#spawnBallArea1600 + 1] = { x = x, y = y}
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
    else
      print("[Volley] Ignoring ball spawn with invalid X or Y")
    end
  end
end
