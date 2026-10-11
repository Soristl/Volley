function gameMaps.readPlayerSpawns(map, isLargeMap)
  gameState.court.lobbySpawns = {}
  gameState.court.playerSpawns[1] = {}
  gameState.court.playerSpawns[2] = {}
  gameState.court.playerSpawns[3] = {}
  gameState.court.playerSpawns[4] = {}

  local xml = mapXml.spawnSource(map)
  for tag in xml:gmatch('<T%s+[^>]*>') do
    local x = mapXml.number(mapXml.attribute(tag, 'X'))
    local y = mapXml.number(mapXml.attribute(tag, 'Y'))
    if x and y then
      local priority = mapXml.number(mapXml.attribute(tag, 'spawn')) or 99999
      local teams = {}
      for i = 1, 4 do teams[i] = mapXml.attribute(tag, 'team' .. i) end
      if mapXml.attribute(tag, 'lobby') ~= nil then
        gameMaps.addLobbySpawn(x, y)
      else
        gameMaps.addPlayerSpawn(isLargeMap, x, y, priority, teams)
      end
    end
  end

  gameMaps.readWebSpawns(map)
  gameMaps.readPointAreas(map)
  gameMaps.readPlayerLimits(map)
end
