function eventLoop(elapsedTime, remainingTime)
  if firstRun then timersLoop(); return end
  if gameStats.isGamePaused then
    tfm.exec.setGameTime(durationTimerPause, true)
  end

  if gameState.phase == 'startGame' then
    if gameRound.lobby() then return end
  elseif gameState.phase == 'showRules' then
    if gameRound.rules() then return end
  elseif gameState.phase == 'endGame' then
    gameRound.ending()
  end

  timersLoop()
end
