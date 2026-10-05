function showTheScore(viewer)
  -- Arrivals render only their own panel; phase cleanup remains room-wide.
  if gameState.phase ~= "gameStart" then clubhouse.clear(nil,"score");return end
  -- Retire the old map-relative score textareas, including Real Mode counters.
  for _,id in ipairs({0,1,899899,8998991}) do ui.removeTextArea(id) end
  local colors = {red="#E85A71",blue="#4BA9EF",yellow="#E5CC4B",green="#49CF82"}
  local entries = {}
  local function add(value,color,x,detail,detailX)
    entries[#entries+1] = {value=value,color=color,x=x,detail=detail,detailX=detailX}
  end
  if gameStats.realMode then
    add(gameState.scores.red,colors.red,1150,gameStats.redQuantitySpawn.."/"..gameStats.redLimitSpawn,200)
    add(gameState.scores.blue,colors.blue,1350,gameStats.blueQuantitySpawn.."/"..gameStats.blueLimitSpawn,600)
  elseif gameStats.twoTeamsMode then
    -- Preserve the original score position in each of the four courts.
    add(gameState.scores.blue,colors.blue,200)
    add(gameState.scores.red,colors.red,550)
    add(gameState.scores.blue,colors.blue,950)
    add(gameState.scores.red,colors.red,1300)
  elseif gameStats.threeTeamsMode or gameStats.teamsMode then
    if gameStats.typeMap == "large4v4" then
      if gameStats.teamsMode then add(gameState.lives[1].yellow,colors.yellow,200) end
      add(gameState.lives[2].red,colors.red,gameStats.teamsMode and 550 or 350)
      add(gameState.lives[3].blue,colors.blue,gameStats.teamsMode and 950 or 850)
      add(gameState.lives[4].green,colors.green,gameStats.teamsMode and 1300 or 1350)
    else
      local count = gameStats.teamsMode and gameStats.typeMap == "large3v3" and 3 or 2
      local positions = gameStats.typeMap == "small" and {0,700} or count == 3 and {200,550,900} or {200,900}
      for i=1,count do
        if gameLives.at(i) == nil or gameTeams.keyAt(i) == nil then clubhouse.clear(nil,"score");return end
        add(gameLives.at(i),colors[gameTeams.keyAt(i)] or "#E3ECE7",positions[i])
      end
    end
  else
    local positions = gameStats.gameMode == "3v3" and {0,700} or gameStats.gameMode == "4v4" and {200,900} or {200,1500}
    add(gameState.scores.red,colors.red,positions[1])
    add(gameState.scores.blue,colors.blue,positions[2])
  end
  clubhouse.drawScores(entries,viewer)
end
