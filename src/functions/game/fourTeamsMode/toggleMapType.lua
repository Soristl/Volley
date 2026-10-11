function matchLifecycle.chooseReducedCourt()
  if gameState.match.court.typeMap == "large4v4" then
    gameState.match.court.typeMap = "large3v3"
  elseif gameState.match.court.typeMap == "large3v3" then
    gameState.match.court.typeMap = "small"
  end
end
