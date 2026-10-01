function teleportPlayerWithSpecificSpawn(playersSpawn, name)
  if not name or name == '' or not playersSpawn or #playersSpawn == 0 then return false end
  if not tfm.get.room.playerList[name] then
    removePlayerOnSpawnConfig(name, playersSpawn)
    return false
  end
  local previous
  for _, marker in ipairs(playersSpawn) do
    for _, occupant in ipairs(marker.players) do
      if occupant == name then previous = previous or marker end
    end
  end
  removePlayerOnSpawnConfig(name, playersSpawn)
  if previous then
    previous.players[#previous.players+1] = name
    tfm.exec.movePlayer(name, previous.x, previous.y)
    return true
  end
  local lowestPlayersQuantity
  local availableIndexesToSpawn = {}
  for i = 1, #playersSpawn do
    if lowestPlayersQuantity == nil then
      lowestPlayersQuantity = #playersSpawn[i].players
      availableIndexesToSpawn[#availableIndexesToSpawn + 1] = i
    else
      if #playersSpawn[i].players == lowestPlayersQuantity then
        availableIndexesToSpawn[#availableIndexesToSpawn + 1] = i
      elseif #playersSpawn[i].players < lowestPlayersQuantity then
        lowestPlayersQuantity = #playersSpawn[i].players
        availableIndexesToSpawn = { [1] = i }
      end
    end
  end

  if #availableIndexesToSpawn == 1 then
    local index = availableIndexesToSpawn[1]
    playersSpawn[index].players[#playersSpawn[index].players + 1] = name
    tfm.exec.movePlayer(name, playersSpawn[index].x, playersSpawn[index].y)

    return true
  end

  local lowestSpawnPriority
  local indexSelected
  local foundDifference = false
  for i = 1, #availableIndexesToSpawn do
    local index = availableIndexesToSpawn[i]

    if lowestSpawnPriority == nil then
      lowestSpawnPriority = playersSpawn[index].spawnPriority
      indexSelected = index
    else
      if lowestSpawnPriority ~= playersSpawn[index].spawnPriority then
        foundDifference = true
      end

      if playersSpawn[index].spawnPriority < lowestSpawnPriority then
        lowestSpawnPriority = playersSpawn[index].spawnPriority
        indexSelected = index
      end
    end
  end

  if foundDifference then
    playersSpawn[indexSelected].players[#playersSpawn[indexSelected].players + 1] = name
    tfm.exec.movePlayer(name, playersSpawn[indexSelected].x, playersSpawn[indexSelected].y)

    return true
  end

  local index = availableIndexesToSpawn[math.random(1, #availableIndexesToSpawn)]
  playersSpawn[index].players[#playersSpawn[index].players + 1] = name
  tfm.exec.movePlayer(name, playersSpawn[index].x, playersSpawn[index].y)
  return true
end
