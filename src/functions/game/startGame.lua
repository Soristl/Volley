function startGame()
  gameStats.canTransform = false
  if not globalSettings.minimalist then
    disablePlayersCanTransform(1500)
  end
  
  addMatchesToAllPlayers()
  selectMap()

  duration = os.time() + durationTimerPause * 1000

  local timer = math.ceil((duration - os.time())/1000)

  tfm.exec.setGameTime(timer, true)

  removeTextAreasOfLobby()
  showTheScore()

  local delayMS = 2500

  if globalSettings.minimalist then
    delayMS = 6500
  end

  globalSettings.minimalistToggleMap = true

  delaySpawnBall = addTimer(function(i)
    if i == 1 then
      teleportPlayers()
      spawnInitialBall()
      verifyIsPoint()
      showCrownToAllPlayers()

      tfm.exec.addPhysicObject (99999, 800, webY, 
      {
        type = 15,
        width = 3000,
        height = 100,
        miceCollision = false,
        groundCollision = false   
      })

      if globalSettings.minimalist then
        gameStats.canTransform = true
      end
    end
  end, delayMS)

  mode = "gameStart"
  tfm.exec.chatMessage("<ch>If you don't want to see the ranking crowns, type the command !crown false<n>", nil)
end