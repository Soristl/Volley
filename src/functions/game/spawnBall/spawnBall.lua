function spawnBall(x, index, y)
  local ballSpawnX = x
  local ballSpawnY = 50

  if y ~= nil then
    ballSpawnY = y
  end

  if index == 1 then
    tfm.exec.removeObject(ball_id)
    ball_id = nil
    ballOnGame = false
    updateTwoBallOnGame()
    showTheScore()

    if gameStats.customBall then
      ball_id = tfm.exec.addShamanObject(balls[gameStats.customBallId].id, ballSpawnX, ballSpawnY, 0, 0, -5, true)
      
      if balls[gameStats.customBallId].isImage then
        tfm.exec.addImage(balls[gameStats.customBallId].image, "#"..ball_id, -15, -15, nil, 1, 1, _, 10)
      end

      ballOnGame = true
      updateTwoBallOnGame()
      return
    else
      ball_id = tfm.exec.addShamanObject(6, ballSpawnX, ballSpawnY, 0, 0, -5, true)
      ballOnGame = true
      updateTwoBallOnGame()
      return
    end

  elseif index == 2 then
    tfm.exec.removeObject(ball_id2)
    ball_id2 = nil
    ballOnGame2 = false
    updateTwoBallOnGame()
    showTheScore()

    if gameStats.customBall then
      ball_id2 = tfm.exec.addShamanObject(balls[gameStats.customBallId].id, ballSpawnX, ballSpawnY, 0, 0, -5, true)
      
      if balls[gameStats.customBallId].isImage then
        tfm.exec.addImage(balls[gameStats.customBallId].image, "#"..ball_id2, -15, -15, nil, 1, 1, _, 10)
      end
      ballOnGame2 = true
      updateTwoBallOnGame()
      return
    else
      ball_id2 = tfm.exec.addShamanObject(6, ballSpawnX, ballSpawnY, 0, 0, -5, true)
      ballOnGame2 = true
      updateTwoBallOnGame()
      return
    end
  elseif index == 3 then
    tfm.exec.removeObject(ball_id3)
    ball_id3 = nil
    ballOnGame3 = false
    updateTwoBallOnGame()
    showTheScore()

    if gameStats.customBall then
      ball_id3 = tfm.exec.addShamanObject(balls[gameStats.customBallId].id, ballSpawnX, ballSpawnY, 0, 0, -5, true)
      
      if balls[gameStats.customBallId].isImage then
        tfm.exec.addImage(balls[gameStats.customBallId].image, "#"..ball_id3, -15, -15, nil, 1, 1, _, 10)
      end
      ballOnGame3 = true
      updateTwoBallOnGame()
      return
    else
      ball_id3 = tfm.exec.addShamanObject(6, ballSpawnX, ballSpawnY, 0, 0, -5, true)
      ballOnGame3 = true
      updateTwoBallOnGame()
      return
    end
  end
end