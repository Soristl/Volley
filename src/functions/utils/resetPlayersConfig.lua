function resetPlayerConfigs()
  for name, data in pairs(tfm.get.room.playerList) do
    playerCanTransform[name] = true
    playerInGame[name] = false
    playerCoordinates[name] = { x = 0, y = 0 }
    playerPhysicId[name] = 0
    bindKeys(name)
    tfm.exec.setNameColor(name, 0xD1D5DB)
    tfm.exec.setPlayerScore(name, 0, false)
    canVote[name] = true
  end
end
