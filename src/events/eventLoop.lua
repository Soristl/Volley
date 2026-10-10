function eventLoop(elapsedTime, remainingTime)
  if lobbyTransition.active then lobbyTransition.step();return end
  if firstRun then timersLoop(); return end
  if gameStats.isGamePaused then
    tfm.exec.setGameTime(durationTimerPause, true)
  end

  if gameState.phase == 'startGame' then
    if gameRound.lobby() then return end
  elseif gameState.phase == 'showRules' then
    if gameRound.rules() then return end
  elseif gameState.phase == 'endGame' then
    if lobbyTransition.priming then lobbyTransition.step() end
    gameRound.ending()
    if lobbyTransition.blocksInput() then return end
  end

  timersLoop()
end
