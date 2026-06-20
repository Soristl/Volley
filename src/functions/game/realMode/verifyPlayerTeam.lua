function verifyPlayerTeam(name)
  if playerOutOfCourt[name] then
    return
  end

  for i = 1, #playersRed do
    if playersRed[i].name == name then
      if gameStats.redQuantitySpawn == gameStats.redLimitSpawn then
        return false
      end
      if gameStats.redQuantitySpawn < gameStats.redLimitSpawn then
        if gameStats.redLimitSpawn == 1 and name ~= gameStats.redPlayerServe and gameStats.lastPlayerRed == name then
          return false
        end
        gameStats.redQuantitySpawn = gameStats.redQuantitySpawn + 1
        gameStats.lastPlayerRed = name
        showTheScore()

        return true
      end
    end
  end

  for i = 1, #playersBlue do
    if playersBlue[i].name == name then
      if gameStats.blueQuantitySpawn == gameStats.blueLimitSpawn then
        return false
      end

      if gameStats.blueQuantitySpawn < gameStats.blueLimitSpawn then
        if gameStats.blueLimitSpawn == 1 and name ~= gameStats.bluePlayerServe and gameStats.lastPlayerBlue == name then
          return false
        end

        gameStats.blueQuantitySpawn = gameStats.blueQuantitySpawn + 1
        gameStats.lastPlayerBlue = name
        showTheScore()

        return true
      end
    end
  end
end
