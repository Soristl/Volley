function playerRuntime.resetLobbyPlayers()
  for name, data in pairs(tfm.get.room.playerList) do
    playerState.canTransform[name] = true
    playerState.inGame[name] = false
    playerState.coordinates[name] = { x = 0, y = 0 }
    playerState.physicId[name] = 0
    playerRuntime.bindKeys(name)
    tfm.exec.setNameColor(name, 0xD1D5DB)
    tfm.exec.setPlayerScore(name, 0, false)
    gameState.voting.eligible[name] = true
  end
end
