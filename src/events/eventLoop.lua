function eventLoop(elapsedTime, remainingTime)
  if lobbyTransition.active then lobbyTransition.step();return end
  if roomConfig.firstRun then timers.tick(); return end
  if gameState.match.round.isGamePaused then
    gameRound.showPausedTime()
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

  timers.tick()
end
