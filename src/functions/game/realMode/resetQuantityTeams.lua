function resetQuantityTeams()
  local ball = gameState.balls[1].id and tfm.get.room.objectList[gameState.balls[1].id]
  if not ball then return end
  if gameState.balls[1].active then
    local ballX = ball.x + ball.vx

    if (ballX + 100) >= 1299 then
      gameStats.redQuantitySpawn = 0
      gameStats.lastPlayerRed = ""
      if gameStats.redServe then
        gameStats.redLimitSpawn = 1
      else
        gameStats.redLimitSpawn = 3
      end
    end
    if (ballX - 100) <= 1301 then
      gameStats.lastPlayerBlue = ""
      gameStats.blueQuantitySpawn = 0
      if gameStats.blueServe then
        gameStats.blueLimitSpawn = 1
      else
        gameStats.blueLimitSpawn = 3
      end
    end

    showTheScore()
  end
end
