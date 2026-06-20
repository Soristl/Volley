function teamServe(team)
  gameStats.redQuantitySpawn = 0
  gameStats.blueQuantitySpawn = 0
  if team == "red" then
    gameStats.redLimitSpawn = 1
    gameStats.blueLimitSpawn = 3
    showTheScore()
    return
  end

  gameStats.redLimitSpawn = 3
  gameStats.blueLimitSpawn = 1
  showTheScore()
end
