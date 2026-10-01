-- Detection and point resolution are shared by XML zones and ordinary floors.
gamePoints = {}
do
  local function pointAreas() return {teamPointsArea1,teamPointsArea2,teamPointsArea3,teamPointsArea4} end
  local function spawnAreas() return {spawnBallArea400,spawnBallArea800,spawnBallArea1200,spawnBallArea1600} end

  local function respawn(index, area, fallback)
    local markers = spawnAreas()[area]
    if markers and #markers > 0 then
      local marker = markers[math.random(1, #markers)]
      spawnBall(marker.x, index, marker.y)
    else spawnBall(fallback, index) end
  end

  -- First entry along two consecutive host samples, not the final court after
  -- a fast ball has already travelled underneath a divider. Point queries
  -- without a previous sample retain their ordinary rectangle semantics.
  local function rectangleEntry(rect, x, y, previous)
    if not (rect[1] and rect[2] and rect[3] and rect[4]) then return nil end
    if not previous then
      if x >= rect[1] and x <= rect[2] and y >= rect[3] and y <= rect[4] then return 0 end
      return nil
    end
    local first, last = 0, 1
    local function clip(start, delta, low, high)
      if delta == 0 then return start >= low and start <= high end
      local a, b = (low-start)/delta, (high-start)/delta
      if a > b then a,b = b,a end
      first, last = math.max(first,a), math.min(last,b)
      return first <= last
    end
    if clip(previous.x,x-previous.x,rect[1],rect[2])
      and clip(previous.y,y-previous.y,rect[3],rect[4]) then return first end
  end

  local function courtKey(area, full)
    return full and gameTeams.keys()[area] or gameTeams.keyAt(area)
  end

  local function courtCount(mode, size)
    if mode == 'normal' then return 2 end
    if mode == 'two' then return 4 end
    if mode == 'three' then return size == 'large4v4' and 3 or 2 end
    return size == 'large4v4' and 4 or size == 'large3v3' and 3 or 2
  end

  local function boundaries(mode, size)
    if mode == 'normal' then return {gameStats.redX,gameStats.blueX} end
    if mode == 'two' then return {gameStats.blueX,gameStats.redX,gameStats.blueX2,gameStats.redX2} end
    if size == 'large4v4' then
      if mode == 'three' then return {gameStats.redX,gameStats.blueX,gameStats.greenX} end
      return {gameStats.yellowX,gameStats.redX,gameStats.blueX,gameStats.greenX}
    end
    if mode == 'three' then return {gameStats.redX,gameStats.blueX} end
    return size == 'large3v3' and {gameStats.yellowX,gameStats.redX,gameStats.greenX}
      or {gameStats.redX,gameStats.blueX}
  end

  -- Geometry owns the point before team eligibility is checked. Eliminated
  -- courts must not transfer their faults to the next surviving team.
  function gamePoints.detect(mode, x, y, index, xmlOnly, size, requestedArea, previous)
    size = size or gameStats.typeMap
    local count = courtCount(mode, size)
    local areas, custom = pointAreas(), false
    for area=1,count do if #areas[area] > 0 then custom = true end end
    if xmlOnly and not custom then return nil end
    if not custom then
      local crossing = groundProfile.crossing(previous, x, y)
      if crossing then x = crossing
      elseif not isBallOnGround(gameBalls.id(index)) then return nil end
    end
    local limits = not custom and boundaries(mode, size)
    local selected, firstEntry
    for area=1,count do
      local entry
      if custom then
        for _, rect in ipairs(areas[area]) do
          local t = rectangleEntry(rect,x,y,previous)
          if t and (not entry or t < entry) then entry = t end
        end
      else
        local low = area == count and limits[area] or area > 1 and limits[area-1]+2
        local high = area < count and limits[area]
        if (not low or x >= low) and (not high or x <= high) then entry = 0 end
      end
      if entry and (not firstEntry or entry < firstEntry) then
        selected, firstEntry = area, entry
      end
    end
    if not selected or (requestedArea and selected ~= requestedArea) then return nil end
    if mode == 'four' or mode == 'three' then
      local lives = gameLives.forTeam(courtKey(selected, size == 'large4v4'))
      if not lives or lives <= 0 then return nil end
    end
    return selected
  end

  local function announcePoint(key)
    gameScores.add(key)
    tfm.exec.chatMessage(gameTeams.label(key):gsub('<n>$',' scored!<n>'), nil)
    tfm.exec.chatMessage(gameTeams.label('red') .. ' ' .. gameState.scores.red .. ' X '
      .. gameState.scores.blue .. ' ' .. gameTeams.label('blue'), nil)
  end

  local function finishPoints(mode, key, index)
    gameBalls.deactivateAll()
    gameBalls.remove(index)
    showTheScore()
    showMessageWinner()
    if mode == 'real' then realModeWinner(key); updateRankingRealMode()
    elseif mode == 'two' then twoTeamsModeWinner(key); updateRankingTwoTeamsMode()
    else normalModeTeamWinner(key); updateRankingNormalMode() end
    beginEndGame()
  end

  local function scorePoint(mode, area, index)
    local key = mode == 'two' and (area % 2 == 1 and 'red' or 'blue') or (area == 1 and 'blue' or 'red')
    announcePoint(key)
    if gameState.scores[key] >= gameStats.winscore then finishPoints(mode, key, index); return end
    if mode == 'two' then
      local destination = ({2,1,4,3})[area]
      respawn(index, destination, destination*400-200)
    elseif gameStats.gameMode == '3v3' then
      local destination = key == 'red' and 1 or 2
      respawn(index, destination, destination*400-200)
    elseif gameStats.gameMode == '4v4' then
      respawn(index, key == 'red' and 2 or 4, key == 'red' and 400 or 800)
    else respawn(index, 0, key == 'red' and 400 or 1400) end
  end

  local function lifeSummary(full)
    local entries = {}
    local count = full and #gameTeams.keys() or #teamsPlayersOnGame
    for area=1,count do
      local key = courtKey(area, full)
      entries[#entries+1] = gameTeams.label(key) .. ' ' .. gameLives.forTeam(key)
    end
    return table.concat(entries, ' | ')
  end

  local function finishLives(mode, index)
    gameBalls.deactivateAll()
    gameBalls.remove(index)
    showTheScore()
    if #teamsPlayersOnGame == 1 then
      showMessageWinner()
      local key = gameTeams.keyAt(1)
      if mode == 'three' then threeTeamsModeWinner(key, teamsPlayersOnGame[1]); updateRankingThreeTeamsMode()
      else fourTeamsModeWinner(key, teamsPlayersOnGame[1]); updateRankingFourTeamsMode() end
    end
    beginEndGame()
  end

  local function loseLife(mode, area, index, size)
    local full = size == 'large4v4'
    local key = courtKey(area, full)
    local lives = gameLives.forTeam(key)
    if not lives or lives < 1 then return end
    gameLives.setTeam(key, lives-1)
    if lives == 1 then
      gameBalls.deactivateAll()
      gameTeams.eliminate(gameState.teams[key])
      tfm.exec.chatMessage(gameTeams.message(key, 'lost all their lives'), nil)
      local remaining = refreshRemainingTeams()
      if remaining <= 1 then finishLives(mode, index); return end
      gameStats.typeMap = mode == 'three' and 'large3v3' or remaining == 3 and 'large3v3' or 'small'
      gameStats.canTransform = false
      removeTimer('delayToToggleMap')
      delayToToggleMap = addRoundTimer(function()
        if gameState.phase == 'gameStart' then toggleMap() end
      end, 3000, 1, 'delayToToggleMap')
      return
    end
    tfm.exec.chatMessage(gameTeams.message(key, 'lost a life'), nil)
    tfm.exec.chatMessage(lifeSummary(full), nil)
    respawn(index, area, (mode == 'three' and 600 or 400)*(area-0.5))
  end

  function gamePoints.apply(mode, area, index, size)
    if mode == 'three' or mode == 'four' then loseLife(mode, area, index, size or gameStats.typeMap)
    else scorePoint(mode, area, index) end
  end

  function gamePoints.fromAreas(mode, x, y, index, size, area)
    local selected = gamePoints.detect(mode, x, y, index, true, size, area)
    if selected then gamePoints.apply(mode, selected, index, size); return true end
  end

  function gamePoints.check(mode)
    for index=1,gameBalls.quantity() do
      local ball = tfm.get.room.objectList[gameBalls.id(index)]
      if ball and gameBalls.isActive(index) then
        local previous = gameBalls.pointPosition(index)
        local area = gamePoints.detect(mode, ball.x, ball.y, index, false, nil, nil, previous)
        gameBalls.rememberPointPosition(index,ball.x,ball.y)
        if area then gamePoints.apply(mode, area, index) end
      end
    end
  end

  -- Real Mode keeps its serve/ace rules and schedules the winner's next serve.
  function gamePoints.checkReal()
    local ball = tfm.get.room.objectList[gameBalls.id(1)]
    if not ball or not gameBalls.isActive(1) then return end
    resetQuantityTeams()
    if not isBallOnGround(gameBalls.id(1)) then return end
    local key, x = nil, ball.x
    if x <= 599 then key = (gameStats.redQuantitySpawn > 0 or gameStats.redServe) and 'blue' or 'red'
    elseif x >= gameStats.redX and x <= 1299 then key = 'blue'
    elseif x >= 1301 and x <= gameStats.blueX then key = 'red'
    elseif x >= 2001 then key = (gameStats.blueQuantitySpawn > 0 or gameStats.blueServe) and 'red' or 'blue' end
    if not key then return end
    if key == 'red' then gameStats.aceBlue = false else gameStats.aceRed = false end
    announcePoint(key)
    if gameState.scores[key] >= gameStats.winscore then finishPoints('real', key, 1)
    else
      gameBalls.deactivate(1)
      gameStats.canTransform = false
      scheduleRealServe(key)
      showTheScore()
    end
  end
end
