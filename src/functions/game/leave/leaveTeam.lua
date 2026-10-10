function leaveTeam(name)
  local key, index = gameTeams.find(name)
  if key ~= 'red' and key ~= 'blue' then return false end

  clearPlayerTimers(name)
  clearPlayerGameplay(name)
  playerInGame[name] = false
  gameCrowns.clearSubject(name)
  tfm.exec.setNameColor(name, 0xD1D5DB)
  gameState.teams[key][index].name = ''
  local positions = key == 'red' and twoTeamsPlayerRedPosition or twoTeamsPlayerBluePosition
  positions[index] = ''
  removePlayerOnSpawnConfig(name)
  leaveConfigRealMode(name, key)
  tfm.exec.killPlayer(name)
  if not killSpecPermanent then
    addPlayerRoundTimer(name, function()
      if playerInGame[name] or killSpecPermanent then return end
      tfm.exec.respawnPlayer(name)
      teleportPlayersToSpecWithSpecificSpawn(name)
    end, 1000, 1, 'movePlayer')
  end
  return true
end
