function spawnBall(x, index, y)
  local id=gameBalls.spawn(index,x,y)
  showTheScore()
  return id
end
