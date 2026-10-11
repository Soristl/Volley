function gameBalls.spawnAndRefresh(x, index, y)
  local id=gameBalls.spawn(index,x,y)
  clubhouse.showScores()
  return id
end
