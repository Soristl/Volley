function gameMaps.addLobbySpawn(xNumber, yNumber)
  gameState.court.lobbySpawns[#gameState.court.lobbySpawns + 1] = { x = xNumber, y = yNumber }
end
