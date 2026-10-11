-- Stop pending gameplay immediately, including callbacks due in this eventLoop.
function matchLifecycle.finishMatch()
  if gameState.phase == "endGame" then return end
  if gameState.phase == "showRules" then clubhouse.closeLegacyWindow(266, nil) end
  timers.clearRound()
  gameBalls.removeGameplay()
  gameState.match.round.isGamePaused = false
  playerRuntime.clearMapGameplay()
  gameState.match.round.canTransform = false
  gameState.setPhase("endGame")
  -- Use the existing victory interval without shortening its presentation.
  if lobbyTransition then lobbyTransition.prime() end
end
