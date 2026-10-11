function gamePoints.startChecking()
  timers.remove('verifyBallCoordinates')
  timers.handles.ballCoordinates = timers.addRound(function()
    if gameState.phase ~= 'gameStart' or not mapLoad.isReady() or gameState.match.round.isGamePaused then return end
    local mode = gameTeams.mode()
    if mode == 'real' then gamePoints.checkReal()
    else gamePoints.check(mode) end
  end, 1000, 0, 'verifyBallCoordinates')
end
