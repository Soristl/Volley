function realServe.recordNearbyTouch(name, x, y)
  local ball = gameState.balls[1].id and tfm.get.room.objectList[gameState.balls[1].id]
  if not ball then return end
  if gameState.balls[1].active then
    realServe.resetTouchCounts()
    local ballX = ball.x + ball.vx
    local ballY = ball.y + ball.vy

    if (ballX + 15) >= 1250 and (ballX - 15) <= 1350 and x >= 1250 and x <= 1350 and ballY <= 297 then
      local team = gameTeams.findRealMember(name)

      if team == "red" then
        gameState.match.real.lastPlayerRed = name
        gameState.match.real.blueQuantitySpawn = 0
        if gameState.match.real.blueServe then
          gameState.match.real.blueLimitSpawn = 1
        else
          gameState.match.real.blueLimitSpawn = 3
        end
      elseif team == "blue" then
        gameState.match.real.lastPlayerBlue = name
        gameState.match.real.redQuantitySpawn = 0
        if gameState.match.real.redServe then
          gameState.match.real.redLimitSpawn = 1
        else
          gameState.match.real.redLimitSpawn = 3
        end
      end
    end

    clubhouse.showScores()
  end
end
