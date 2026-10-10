function foundMiceSpawnsOnMap(map, isLargeMap)
  lobbySpawn = {}
  playersSpawn400 = {}
  playersSpawn800 = {}
  playersSpawn1200 = {}
  playersSpawn1600 = {}

  local xml = mapXml.spawnSource(map)
  for tag in xml:gmatch('<T%s+[^>]*>') do
    local x = mapXml.number(mapXml.attribute(tag, 'X'))
    local y = mapXml.number(mapXml.attribute(tag, 'Y'))
    if x and y then
      local priority = mapXml.number(mapXml.attribute(tag, 'spawn')) or 99999
      local teams = {}
      for i = 1, 4 do teams[i] = mapXml.attribute(tag, 'team' .. i) end
      if mapXml.attribute(tag, 'lobby') ~= nil then
        setConfigLobbySpawn(x, y)
      else
        setConfigPlayersSpawn(isLargeMap, x, y, priority, teams)
      end
    end
  end

  foundWebSpawnOnMap(map)
  foundPointsAreaOnMap(map)
  foundMicePlayersConfig(map)
end
