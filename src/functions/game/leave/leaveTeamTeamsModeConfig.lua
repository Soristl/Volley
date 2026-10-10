function leaveTeamTeamsModeConfig(name)
  if gameState.phase ~= 'gameStart' then return end
  local key, slot = gameTeams.find(name)
  if not key then return end -- A spectator departure cannot eliminate a team.
  clearPlayerTimers(name)
  clearPlayerGameplay(name)
  local roster = gameState.teams[key]
  roster[slot].name = ''
  playerInGame[name] = false
  gameCrowns.clearSubject(name)
  removePlayerOnSpawnConfig(name)
  if tfm.get.room.playerList[name] and not playerLeft[name] then
    tfm.exec.killPlayer(name)
    addPlayerRoundTimer(name, function()
      if playerInGame[name] or killSpecPermanent then return end
      tfm.exec.respawnPlayer(name)
      teleportPlayersToSpecWithSpecificSpawn(name)
    end, 1000, 1, 'movePlayer')
  end
  if gameTeams.count(roster) > 0 then return end

  local tags = {yellow='<j>',red='<r>',blue='<bv>',green='<vp>'}
  tfm.exec.chatMessage(tags[key] .. key:sub(1,1):upper() .. key:sub(2)
    .. ' team lost all their lives<n>', nil)
  removeGameplayBalls()
  local remaining = refreshRemainingTeams()
  if remaining <= 1 then
    showTheScore()
    if remaining == 1 then
      showMessageWinner()
      if gameStats.threeTeamsMode then
        threeTeamsModeWinner(gameTeams.keyAt(1), teamsPlayersOnGame[1])
        updateRankingThreeTeamsMode()
      else
        fourTeamsModeWinner(gameTeams.keyAt(1), teamsPlayersOnGame[1])
        updateRankingFourTeamsMode()
      end
    end
    beginEndGame()
    return
  end

  -- A previous elimination may have changed typeMap before loading its map.
  -- Choose the final size from survivors and keep only one pending request.
  gameStats.typeMap = gameStats.threeTeamsMode and 'large3v3'
    or remaining == 3 and 'large3v3' or 'small'
  gameStats.canTransform = false
  removeTimer('delayToToggleMap')
  beginGameplayMapLoad()
  delayToToggleMap = addRoundTimer(function()
    if gameState.phase == 'gameStart' then toggleMap() end
  end, 3000, 1, 'delayToToggleMap')
end
