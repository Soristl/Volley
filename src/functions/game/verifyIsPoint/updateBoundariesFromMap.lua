function updateBoundariesFromMap()
  groundProfile.refresh()
  if gameStats.realMode then return end
  local xmlInfo = tfm.get.room.xmlMapInfo
  if not xmlInfo or not xmlInfo.xml or xmlInfo.xml == "" then return end
  local xml = xmlInfo.xml

  -- Use the same XML attribute grammar as spawns and background geometry.
  -- Quote style or whitespace must not change which team owns a court.
  local params = xml:match('<P%s+[^>]*>') or ''
  local mapWidth = mapXml.number(mapXml.attribute(params, 'L'))
  if not mapWidth or mapWidth <= 0 then mapWidth = 800 end

  if gameStats.typeMap == "large4v4" then
    if gameStats.teamsMode then
      local zoneWidth = math.floor(mapWidth / 4)
      gameStats.yellowX = zoneWidth - 1
      gameStats.redX = zoneWidth * 2 - 1
      gameStats.blueX = zoneWidth * 3 - 1
      gameStats.greenX = zoneWidth * 3 + 1
    elseif gameStats.threeTeamsMode then
      local zoneWidth = math.floor(mapWidth / 3)
      gameStats.redX = zoneWidth - 1
      gameStats.blueX = zoneWidth * 2 - 1
      gameStats.greenX = zoneWidth * 2 + 1
    elseif gameStats.twoTeamsMode then
      local zoneWidth = math.floor(mapWidth / 4)
      gameStats.blueX = zoneWidth - 1
      gameStats.redX = zoneWidth * 2 - 1
      gameStats.blueX2 = zoneWidth * 3 - 1
      gameStats.redX2 = zoneWidth * 3 + 1
    end
  elseif gameStats.typeMap == "large3v3" then
    if gameStats.teamsMode then
      local zoneWidth = math.floor(mapWidth / 3)
      gameStats.yellowX = zoneWidth - 1
      gameStats.redX = zoneWidth * 2 - 1
      gameStats.greenX = zoneWidth * 2 + 1
    elseif gameStats.threeTeamsMode then
      local half = math.floor(mapWidth / 2)
      gameStats.redX = half - 1
      gameStats.blueX = half + 1
    end
  elseif gameStats.typeMap == "small" then
    local half = math.floor(mapWidth / 2)
    gameStats.redX = half - 1
    gameStats.blueX = half + 1
  else
    local half = math.floor(mapWidth / 2)
    gameStats.redX = half - 1
    gameStats.blueX = half + 1
  end
end
