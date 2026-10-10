function startGame()
  gameState.setPhase("gameStart")
  clearRoundTimers()
  beginGameplayMapLoad()
  gameStats.canTransform = false
  if not globalSettings.minimalist then
    disablePlayersCanTransform(3500)
  end
  
  addMatchesToAllPlayers()
  selectMap()

  duration = os.time() + durationTimerPause * 1000

  local _timer = math.ceil((duration - os.time()) / 1000)

  tfm.exec.setGameTime(_timer, true)

  removeTextAreasOfLobby()
  showTheScore()

  globalSettings.minimalistToggleMap = true
  gameMaps.prepareCourt(function()
    teleportPlayers()
    spawnInitialBall()
    verifyIsPoint()
    showCrownToAllPlayers()
  end)

  tfm.exec.chatMessage("<ch>If you don't want to see the ranking crowns, type the command !crown false<n>", nil)
end
