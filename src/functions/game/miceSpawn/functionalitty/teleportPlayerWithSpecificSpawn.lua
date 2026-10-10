do
-- Occupancy wins first, then priority; identical priorities keep random ties.
local function chooseSpawn(playersSpawn)
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
    return playersSpawn[availableIndexesToSpawn[1]]
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
    return playersSpawn[indexSelected]
  end

  return playersSpawn[availableIndexesToSpawn[math.random(1, #availableIndexesToSpawn)]]
end

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
  local chosen = previous or chooseSpawn(playersSpawn)
  chosen.players[#chosen.players+1] = name
  tfm.exec.movePlayer(name, chosen.x, chosen.y)
  return true
end
end
