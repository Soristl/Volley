function foundMicePlayersConfig(map)
  local mapXML = ""

  if #map > 10 then
    mapXML = map
  else
    mapXML = tfm.get.room.xmlMapInfo.xml
  end

  local pTag = string.match(mapXML, '<C><P%s+([^>]+)')

  if pTag then
    local playerForce = string.match(pTag, 'playerForce="([^"]+)"')

    if type(tonumber(playerForce)) == 'number' then
      gameStats.physicObjectForce = tonumber(playerForce)
    end
  end
end
