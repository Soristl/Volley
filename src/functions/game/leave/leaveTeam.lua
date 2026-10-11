function gameTeams.leaveStandard(name)
  local key, index = gameTeams.find(name)
  if key ~= 'red' and key ~= 'blue' then return false end

  timers.clearPlayer(name)
  playerRuntime.clearGameplay(name)
  playerState.inGame[name] = false
  gameCrowns.clearSubject(name)
  tfm.exec.setNameColor(name, 0xD1D5DB)
  gameState.teams[key][index].name = ''
  local positions = key == 'red' and gameState.teamLayout.roles.red or gameState.teamLayout.roles.blue
  positions[index] = ''
  gameTeams.releaseSpawn(name)
  realServe.playerLeft(name, key)
  tfm.exec.killPlayer(name)
  if not roomConfig.killSpectators then
    timers.addPlayerRound(name, function()
      if playerState.inGame[name] or roomConfig.killSpectators then return end
      tfm.exec.respawnPlayer(name)
      gameTeams.placeSpectator(name)
    end, 1000, 1, 'movePlayer')
  end
  return true
end
