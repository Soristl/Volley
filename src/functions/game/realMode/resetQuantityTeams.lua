function resetQuantityTeams()
  if ballOnGame then
    local ballX = tfm.get.room.objectList[ball_id].x + tfm.get.room.objectList[ball_id].vx
    print("<br>normal:" .. ballX .. "<br><r>red:" .. (ballX + 300) .. "<n><br><bv>blue:" .. (ballX - 300) .. "<n>")

    if (ballX + 100) >= 1299 then
      print("caiu no red")
      gameStats.redQuantitySpawn = 0
      gameStats.lastPlayerRed = ""
      if gameStats.redServe then
        gameStats.redLimitSpawn = 1
      else
        gameStats.redLimitSpawn = 3
      end
    end
    if (ballX - 100) <= 1301 then
      print("caiu no blue")
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
