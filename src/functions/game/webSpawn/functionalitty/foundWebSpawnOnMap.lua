function foundWebSpawnOnMap(map)
  local mapXML = ""
  
  if #map > 10 then
    mapXML = map
  else
    mapXML = tfm.get.room.xmlMapInfo.xml
  end

  local webYText = mapXML:match('<C>%s*<P[^>]-WEBY="([^"]+)"')

  print('=== WEB Y ===')
  print(webYText)

  if webYText then
    webY = tonumber(webYText)
  end

  print(webY)

  print('===')
end
