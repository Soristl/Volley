function realServe.configureTeam(team)
  gameStats.redQuantitySpawn = 0
  gameStats.blueQuantitySpawn = 0
  if team == "red" then
    gameStats.redLimitSpawn = 1
    gameStats.blueLimitSpawn = 3
    clubhouse.showScores()
    return
  end

  gameStats.redLimitSpawn = 3
  gameStats.blueLimitSpawn = 1
  clubhouse.showScores()
end
