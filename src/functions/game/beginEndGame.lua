-- Stop pending gameplay immediately, including callbacks due in this eventLoop.
function beginEndGame()
  if gameState.phase == "endGame" then return end
  if gameState.phase == "showRules" then closeWindow(266, nil) end
  clearRoundTimers()
  removeGameplayBalls()
  gameStats.isGamePaused = false
  clearMapPlayerGameplay()
  gameStats.canTransform = false
  gameState.setPhase("endGame")
end
