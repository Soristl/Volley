function verifyIsPoint()
  removeTimer('verifyBallCoordinates')
  verifyBallCoordinates = addRoundTimer(function()
    if gameState.phase ~= 'gameStart' or not isGameplayMapReady() or gameStats.isGamePaused then return end
    local mode = gameTeams.mode()
    if mode == 'real' then gamePoints.checkReal()
    else gamePoints.check(mode) end
  end, 1000, 0, 'verifyBallCoordinates')
end
