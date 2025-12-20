function startGame()
  gameStats.canTransform = false
  disablePlayersCanTransform(1500)

  addMatchesToAllPlayers()
  selectMap()

  duration = os.time() + durationTimerPause * 1000

  local timer = math.ceil((duration - os.time())/1000)

  tfm.exec.setGameTime(timer, true)

  tfm.exec.addPhysicObject (99999, 800, 460, 
  {
    type = 15,
    width = 3000,
    height = 100,
    miceCollision = false,
    groundCollision = false   
  })

  removeTextAreasOfLobby()
  showTheScore()

  delaySpawnBall = addTimer(function(i)
    if i == 1 then
      teleportPlayers()
      spawnInitialBall()
    end
  end, 1500)

  verifyIsPoint()
  showCrownToAllPlayers()
  mode = "gameStart"
  tfm.exec.chatMessage("<ch>If you don't want to see the ranking crowns, type the command !crown false<n>", nil)
end