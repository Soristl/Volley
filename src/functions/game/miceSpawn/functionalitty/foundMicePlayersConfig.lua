function foundMicePlayersConfig(map)
  local properties = mapXml.source(map):match('<P%s+[^>]*>') or ''
  gameStats.physicObjectForce = mapXml.number(mapXml.attribute(properties, 'playerForce')) or 1
end
