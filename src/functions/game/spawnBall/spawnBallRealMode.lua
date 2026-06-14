function spawnBallRealMode(team)
  gameStats.reduceForce = true
  if team == "red" then
    gameStats.teamWithOutAce = "blue"

    ballOnGame = false
    tfm.exec.removeObject(ball_id)
    gameStats.redServe = true

    if gameStats.customBall then
      ball_id = tfm.exec.addShamanObject(balls[gameStats.customBallId].id, 700, 50, 0, 0, -5, true)
      if balls[gameStats.customBallId].isImage then
        tfm.exec.addImage(balls[gameStats.customBallId].image, "#" .. ball_id, -15, -15, nil, 1, 1, _, 10)
      end
    else
      ball_id = tfm.exec.addShamanObject(6, 700, 50, 0, 0, -5, true)
    end

    ballOnGame = true
    showTheScore()
    gameStats.canTransform = true

    return
  elseif team == "blue" then
    gameStats.teamWithOutAce = "red"
    ballOnGame = false
    tfm.exec.removeObject(ball_id)
    gameStats.blueServe = true
    if gameStats.customBall then
      ball_id = tfm.exec.addShamanObject(balls[gameStats.customBallId].id, 1900, 50, 0, 0, -5, true)
      if balls[gameStats.customBallId].isImage then
        tfm.exec.addImage(balls[gameStats.customBallId].image, "#" .. ball_id, -15, -15, nil, 1, 1, _, 10)
      end
    else
      ball_id = tfm.exec.addShamanObject(6, 1900, 50, 0, 0, -5, true)
    end

    gameStats.canTransform = true
    ballOnGame = true
    showTheScore()
  end
end
