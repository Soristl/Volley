function spawnBallsOnSpecificPlaces(spawnBallsTable, defaultSpawnBallTable)
  local pool,places={},{}
  for index,x in ipairs(defaultSpawnBallTable) do
    pool[#pool+1]={markers=spawnBallsTable[index],x=x}
  end
  -- Inputs are map metadata: do not consume or reorder the caller's tables.
  for index=1,gameBalls.quantity() do
    if #pool==0 then
      places[index]={x=defaultSpawnBallTable[1] or 400,y=50}
    else
      local selected=table.remove(pool,math.random(1,#pool))
      if selected.markers and #selected.markers>0 then
        local point=selected.markers[math.random(1,#selected.markers)]
        places[index]={x=point.x,y=point.y}
      else places[index]={x=selected.x,y=50} end
    end
  end
  return places
end
