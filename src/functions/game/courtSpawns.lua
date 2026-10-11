-- Court marker routing is shared by ball and player spawns. Parsing stays
-- with the XML readers; this owner appends independent entries to court state.
do
  local function selectedSlots(threeTeamsMode, isLargeMap, x, team1, team2, team3, team4)
    -- Explicit team markers take precedence over coordinates. Presence matters,
    -- including an empty marker. Keep adjacent coordinate ranges inclusive.
    if threeTeamsMode then
      if team1 ~= nil or team2 ~= nil or team3 ~= nil then
        return team1 ~= nil, team2 ~= nil, team3 ~= nil, false
      end
      return x >= 0 and x <= 600, x >= 600 and x <= 1200,
        x >= 1200 and x <= 1800, false
    elseif isLargeMap then
      if team1 ~= nil or team2 ~= nil then
        return false, team1 ~= nil, false, team2 ~= nil
      end
      return false, x >= 0 and x <= 600, false, x >= 600 and x <= 1200
    end
    if team1 ~= nil or team2 ~= nil or team3 ~= nil or team4 ~= nil then
      return team1 ~= nil, team2 ~= nil, team3 ~= nil, team4 ~= nil
    end
    return x >= 0 and x <= 400, x >= 400 and x <= 800,
      x >= 800 and x <= 1200, x >= 1200 and x <= 1600
  end

  local function appendBallSpawn(index, x, y)
    local spawns = gameState.court.ballSpawns[index]
    spawns[#spawns + 1] = { x = x, y = y }
  end

  local function appendPlayerSpawn(index, x, y, spawnPriority)
    local spawns = gameState.court.playerSpawns[index]
    spawns[#spawns + 1] = { x = x, y = y, spawnPriority = spawnPriority, players = {} }
  end

  function gameState.addCourtBallSpawn(threeTeamsMode, isLargeMap, x, y, team1, team2, team3, team4)
    local first, second, third, fourth = selectedSlots(threeTeamsMode, isLargeMap, x, team1, team2, team3, team4)
    if first then appendBallSpawn(1, x, y) end
    if second then appendBallSpawn(2, x, y) end
    if third then appendBallSpawn(3, x, y) end
    if fourth then appendBallSpawn(4, x, y) end
  end

  function gameState.addCourtPlayerSpawn(threeTeamsMode, isLargeMap, x, y, spawnPriority, teams)
    local first, second, third, fourth = selectedSlots(threeTeamsMode, isLargeMap, x, teams[1], teams[2], teams[3], teams[4])
    if first then appendPlayerSpawn(1, x, y, spawnPriority) end
    if second then appendPlayerSpawn(2, x, y, spawnPriority) end
    if third then appendPlayerSpawn(3, x, y, spawnPriority) end
    if fourth then appendPlayerSpawn(4, x, y, spawnPriority) end
  end
end
