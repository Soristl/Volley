function gameMaps.readWebSpawns(map)
  local properties = mapXml.source(map):match('<P%s+[^>]*>') or ''
  gameState.court.webY = mapXml.number(mapXml.attribute(properties, 'WEBY')) or 460
end
