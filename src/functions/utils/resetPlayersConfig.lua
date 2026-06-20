function resetPlayerConfigs()
  for name, data in pairs(tfm.get.room.playerList) do
    playerCanTransform[name] = true
    playerInGame[name] = false
    playerCoordinates[name] = { x = 0, y = 0 }
    playerPhysicId[name] = 0
    system.bindKeyboard(name, 32, true, true)
    system.bindKeyboard(name, 0, true, true)
    system.bindKeyboard(name, 1, true, true)
    system.bindKeyboard(name, 2, true, true)
    system.bindKeyboard(name, 3, true, true)
    system.bindKeyboard(name, 55, true, true)
    system.bindKeyboard(name, 56, true, true)
    system.bindKeyboard(name, 57, true, true)
    system.bindKeyboard(name, 48, true, true)
    system.bindKeyboard(name, 77, true, true)
    tfm.exec.setNameColor(name, 0xD1D5DB)
    tfm.exec.setPlayerScore(name, 0, false)
    canVote[name] = true
  end
end
