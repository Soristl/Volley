function gameMaps.readPlayerLimits(map)
  local properties = mapXml.source(map):match('<P%s+[^>]*>') or ''
  gameState.match.rules.physicObjectForce = mapXml.number(mapXml.attribute(properties, 'playerForce')) or 1
end
