do
local function applyHalfCourtBoundaries(mapWidth)
  local half = math.floor(mapWidth / 2)
  gameState.match.court.redX = half - 1
  gameState.match.court.blueX = half + 1
end

local function applyFullCourtBoundaries(mapWidth)
  if gameState.match.mode.teamsMode then
    local zoneWidth = math.floor(mapWidth / 4)
    gameState.match.court.yellowX = zoneWidth - 1
    gameState.match.court.redX = zoneWidth * 2 - 1
    gameState.match.court.blueX = zoneWidth * 3 - 1
    gameState.match.court.greenX = zoneWidth * 3 + 1
  elseif gameState.match.mode.threeTeamsMode then
    local zoneWidth = math.floor(mapWidth / 3)
    gameState.match.court.redX = zoneWidth - 1
    gameState.match.court.blueX = zoneWidth * 2 - 1
    gameState.match.court.greenX = zoneWidth * 2 + 1
  elseif gameState.match.mode.twoTeamsMode then
    local zoneWidth = math.floor(mapWidth / 4)
    gameState.match.court.blueX = zoneWidth - 1
    gameState.match.court.redX = zoneWidth * 2 - 1
    gameState.match.court.blueX2 = zoneWidth * 3 - 1
    gameState.match.court.redX2 = zoneWidth * 3 + 1
  end
end

local function applyReducedCourtBoundaries(mapWidth)
  if gameState.match.mode.teamsMode then
    local zoneWidth = math.floor(mapWidth / 3)
    gameState.match.court.yellowX = zoneWidth - 1
    gameState.match.court.redX = zoneWidth * 2 - 1
    gameState.match.court.greenX = zoneWidth * 2 + 1
  elseif gameState.match.mode.threeTeamsMode then
    applyHalfCourtBoundaries(mapWidth)
  end
end

function gameMaps.refreshBoundaries()
  groundProfile.refresh()
  if gameState.match.mode.realMode then return end
  local xmlInfo = tfm.get.room.xmlMapInfo
  if not xmlInfo or not xmlInfo.xml or xmlInfo.xml == "" then return end
  local xml = xmlInfo.xml

  -- Use the same XML attribute grammar as spawns and background geometry.
  -- Quote style or whitespace must not change which team owns a court.
  local params = xml:match('<P%s+[^>]*>') or ''
  local mapWidth = mapXml.number(mapXml.attribute(params, 'L'))
  if not mapWidth or mapWidth <= 0 then mapWidth = 800 end

  if gameState.match.court.typeMap == "large4v4" then
    applyFullCourtBoundaries(mapWidth)
  elseif gameState.match.court.typeMap == "large3v3" then
    applyReducedCourtBoundaries(mapWidth)
  elseif gameState.match.court.typeMap == "small" then
    applyHalfCourtBoundaries(mapWidth)
  else
    applyHalfCourtBoundaries(mapWidth)
  end
end
end
