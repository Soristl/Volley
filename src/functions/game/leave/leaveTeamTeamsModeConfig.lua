do
local function finishEliminatedMatch(remaining)
  clubhouse.showScores()
  if remaining == 1 then
    clubhouse.showWinner()
    if gameState.match.mode.threeTeamsMode then
      sessionRanking.recordThreeTeamWin(gameTeams.keyAt(1), gameState.teamLayout.remaining[1])
      sessionRanking.update.three()
    else
      sessionRanking.recordFourTeamWin(gameTeams.keyAt(1), gameState.teamLayout.remaining[1])
      sessionRanking.update.four()
    end
  end
  matchLifecycle.finishMatch()
end

local function scheduleReducedCourt(remaining)
  -- A previous elimination may have changed typeMap before loading its map.
  -- Choose the final size from survivors and keep only one pending request.
  gameState.match.court.typeMap = gameState.match.mode.threeTeamsMode and 'large3v3'
    or remaining == 3 and 'large3v3' or 'small'
  gameState.match.round.canTransform = false
  timers.remove('delayToToggleMap')
  mapLoad.begin()
  timers.handles.reduceCourt = timers.addRound(function()
    if gameState.phase == 'gameStart' then matchLifecycle.reduceCourt() end
  end, 3000, 1, 'delayToToggleMap')
end

function gameTeams.removeMultiMember(name)
  if gameState.phase ~= 'gameStart' then return end
  local key, slot = gameTeams.find(name)
  if not key then return end -- A spectator departure cannot eliminate a team.
  timers.clearPlayer(name)
  playerRuntime.clearGameplay(name)
  local roster = gameState.teams[key]
  roster[slot].name = ''
  playerState.inGame[name] = false
  gameCrowns.clearSubject(name)
  gameTeams.releaseSpawn(name)
  if tfm.get.room.playerList[name] and not playerState.left[name] then
    tfm.exec.killPlayer(name)
    timers.addPlayerRound(name, function()
      if playerState.inGame[name] or roomConfig.killSpectators then return end
      tfm.exec.respawnPlayer(name)
      gameTeams.placeSpectator(name)
    end, 1000, 1, 'movePlayer')
  end
  if gameTeams.count(roster) > 0 then return end

  local tags = {yellow='<j>',red='<r>',blue='<bv>',green='<vp>'}
  tfm.exec.chatMessage(tags[key] .. key:sub(1,1):upper() .. key:sub(2)
    .. ' team lost all their lives<n>', nil)
  gameBalls.removeGameplay()
  local remaining = gameTeams.refreshRemaining()
  if remaining <= 1 then
    finishEliminatedMatch(remaining)
    return
  end

  scheduleReducedCourt(remaining)
end
end
