function playerNearOfTheBall(name, x, y)
  if ballOnGame then
    resetQuantityTeams()
    local ballX = tfm.get.room.objectList[ball_id].x + tfm.get.room.objectList[ball_id].vx
    local ballY = tfm.get.room.objectList[ball_id].y + tfm.get.room.objectList[ball_id].vy

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
