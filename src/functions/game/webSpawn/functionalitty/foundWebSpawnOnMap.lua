function foundWebSpawnOnMap(map)
  local properties = mapXml.source(map):match('<P%s+[^>]*>') or ''
  webY = mapXml.number(mapXml.attribute(properties, 'WEBY')) or 460
end
