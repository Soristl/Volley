function startGame()
  mode = "gameStart"
  gameStats.canTransform = false

  addMatchesToAllPlayers()
  selectMap()

  duration = os.time() + durationTimerPause * 1000

  local _timer = math.ceil((duration - os.time()) / 1000)

  tfm.exec.setGameTime(_timer, true)

  removeTextAreasOfLobby()
  showTheScore()

  local delayMS = 2500

  if globalSettings.minimalist then
    delayMS = 6500
  end

  globalSettings.minimalistToggleMap = true

  tfm.exec.chatMessage("<ch>If you don't want to see the ranking crowns, type the command !crown false<n>", nil)
end
