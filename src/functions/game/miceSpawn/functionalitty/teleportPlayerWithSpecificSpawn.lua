function teleportPlayerWithSpecificSpawn(playersSpawn, name)
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

    return
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

    return
  end

  local index = availableIndexesToSpawn[math.random(1, #availableIndexesToSpawn)]
  playersSpawn[index].players[#playersSpawn[index].players + 1] = name
  tfm.exec.movePlayer(name, playersSpawn[index].x, playersSpawn[index].y)
end
