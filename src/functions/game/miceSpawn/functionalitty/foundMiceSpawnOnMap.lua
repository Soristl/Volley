function foundMiceSpawnsOnMap(map, isLargeMap)
  lobbySpawn = {}
  playersSpawn400 = {}
  playersSpawn800 = {}
  playersSpawn1200 = {}
  playersSpawn1600 = {}

  local mapXML = ""

  if #map > 10 then
    mapXML = map
  else
    mapXML = tfm.get.room.xmlMapInfo.xml
  end

  for tag in string.gmatch(mapXML, '<T%s+.-/>') do
    local x = string.match(tag, 'X="([^"]+)"')
    local y = string.match(tag, 'Y="([^"]+)"')
    local spawn = string.match(tag, 'spawn="([^"]+)"')
    local lobby = string.match(tag, 'lobby="([^"]+)"')
    local team1 = string.match(tag, 'team1=""')
    local team2 = string.match(tag, 'team2=""')
    local team3 = string.match(tag, 'team3=""')
    local team4 = string.match(tag, 'team4=""')
    
    local teams = {team1, team2, team3, team4}

    local xNumber = tonumber(x)
    local yNumber = tonumber(y)

    if spawn == nil then
      spawn = 99999
    end

    if lobby ~= nil then
      setConfigLobbySpawn(xNumber, yNumber)
    else
      setConfigPlayersSpawn(isLargeMap, xNumber, yNumber, tonumber(spawn), teams)
    end
  end

  foundWebSpawnOnMap(map)
  
  foundMicePlayersConfig(map)

  print('400: ' .. #playersSpawn400 .. '')
  print('800: ' .. #playersSpawn800 .. '')
  print('1200: ' .. #playersSpawn1200 .. '')
  print('1600: ' .. #playersSpawn1600 .. '')
end
