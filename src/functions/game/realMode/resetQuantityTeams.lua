function realServe.resetTouchCounts()
  local ball = gameState.balls[1].id and tfm.get.room.objectList[gameState.balls[1].id]
  if not ball then return end
  if gameState.balls[1].active then
    local ballX = ball.x + ball.vx

    if (ballX + 100) >= 1299 then
      gameState.match.real.redQuantitySpawn = 0
      gameState.match.real.lastPlayerRed = ""
      if gameState.match.real.redServe then
        gameState.match.real.redLimitSpawn = 1
      else
        gameState.match.real.redLimitSpawn = 3
      end
    end
    if (ballX - 100) <= 1301 then
      gameState.match.real.lastPlayerBlue = ""
      gameState.match.real.blueQuantitySpawn = 0
      if gameState.match.real.blueServe then
        gameState.match.real.blueLimitSpawn = 1
      else
        gameState.match.real.blueLimitSpawn = 3
      end
    end

    clubhouse.showScores()
  end
end
