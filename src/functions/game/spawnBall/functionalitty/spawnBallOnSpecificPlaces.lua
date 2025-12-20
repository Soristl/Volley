function spawnBallsOnSpecificPlaces(spawnBallsTable, defaultSpawnBallTable)
  local spawnBalls = spawnBallsTable
  local defaultSpawnBall = defaultSpawnBallTable
  
  local randomIndex = 0
  local spawnPlaces = {[1] = {x = 0, y = 50}, [2] = {x = 0, y = 50}, [3] = {x = 0, y = 50}}
  local maxIndex = 2

  if gameStats.threeTeamsMode then
    maxIndex = 3
  end

  for i = 1, maxIndex do
    local randomTeamSpawn = math.random(1, #spawnBalls)
    if #spawnBalls > 0 and #spawnBalls[randomTeamSpawn] ~= 0 then
      randomIndex = math.random(1, #spawnBalls[randomTeamSpawn])
      spawnPlaces[i].x = spawnBalls[randomTeamSpawn][randomIndex].x
      spawnPlaces[i].y = spawnBalls[randomTeamSpawn][randomIndex].y
      table.remove(spawnBalls, randomTeamSpawn)
    else
      randomIndex = math.random(1, #defaultSpawnBall)
      spawnPlaces[i].x = defaultSpawnBall[randomIndex]
      table.remove(defaultSpawnBall, randomIndex)
    end
  end
  
  return spawnPlaces
end