function gameTeams.teamCapacity()
  local maxPlayers = 0
  if gameState.match.mode.gameMode == "3v3" then
    maxPlayers = 3
  elseif gameState.match.mode.gameMode == "4v4" or gameState.match.mode.gameMode == "6v6" then
    maxPlayers = 6
  end

  return maxPlayers
end
