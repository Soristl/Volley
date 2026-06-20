function maxPlayers()
  local maxPlayers = 0
  if gameStats.gameMode == "3v3" then
    maxPlayers = 3
  elseif gameStats.gameMode == "4v4" or gameStats.gameMode == "6v6" then
    maxPlayers = 6
  end

  return maxPlayers
end
