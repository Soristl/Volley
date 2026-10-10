function playerNearOfTheBall(name, x, y)
  local ball = gameState.balls[1].id and tfm.get.room.objectList[gameState.balls[1].id]
  if not ball then return end
  if gameState.balls[1].active then
    resetQuantityTeams()
    local ballX = ball.x + ball.vx
    local ballY = ball.y + ball.vy

    if (ballX + 15) >= 1250 and (ballX - 15) <= 1350 and x >= 1250 and x <= 1350 and ballY <= 297 then
      local team = searchPlayerTeam(name)

      if team == "red" then
        gameStats.lastPlayerRed = name
        gameStats.blueQuantitySpawn = 0
        if gameStats.blueServe then
          gameStats.blueLimitSpawn = 1
        else
          gameStats.blueLimitSpawn = 3
        end
      elseif team == "blue" then
        gameStats.lastPlayerBlue = name
        gameStats.redQuantitySpawn = 0
        if gameStats.redServe then
          gameStats.redLimitSpawn = 1
        else
          gameStats.redLimitSpawn = 3
        end
      end
    end

    showTheScore()
  end
end
