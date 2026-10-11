function gameMaps.readBallSpawns(map, isLargeMap)
  local tags_T131 = {}
  gameState.court.ballSpawns[1] = {}
  gameState.court.ballSpawns[2] = {}
  gameState.court.ballSpawns[3] = {}
  gameState.court.ballSpawns[4] = {}

  local mapXML = mapXml.spawnSource(map)
  for tag in mapXML:gmatch('<P%s+[^>]*>') do
    if mapXml.attribute(tag, "T") == "131" then tags_T131[#tags_T131 + 1] = tag end
  end

  for _, tag in ipairs(tags_T131) do
    local x = mapXml.number(mapXml.attribute(tag, "X"))
    local y = mapXml.number(mapXml.attribute(tag, "Y"))
    local team1 = mapXml.attribute(tag, "team1")
    local team2 = mapXml.attribute(tag, "team2")
    local team3 = mapXml.attribute(tag, "team3")
    local team4 = mapXml.attribute(tag, "team4")
    if x and y then
      gameState.addCourtBallSpawn(gameState.match.mode.threeTeamsMode, isLargeMap, x, y, team1, team2, team3, team4)
    else
      print("[Volley] Ignoring ball spawn with invalid X or Y")
    end
  end
end
