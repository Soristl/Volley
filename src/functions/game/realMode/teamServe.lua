function realServe.configureTeam(team)
  gameState.match.real.redQuantitySpawn = 0
  gameState.match.real.blueQuantitySpawn = 0
  if team == "red" then
    gameState.match.real.redLimitSpawn = 1
    gameState.match.real.blueLimitSpawn = 3
    clubhouse.showScores()
    return
  end

  gameState.match.real.redLimitSpawn = 3
  gameState.match.real.blueLimitSpawn = 1
  clubhouse.showScores()
end
