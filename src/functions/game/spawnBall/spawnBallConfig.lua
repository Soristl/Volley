function spawnBallConfig(spawnBalls, x)
  local places=spawnBallsOnSpecificPlaces(spawnBalls,x)
  gameBalls.clear()
  for index=1,gameBalls.quantity() do
    gameBalls.spawn(index,places[index].x,places[index].y)
  end
end
