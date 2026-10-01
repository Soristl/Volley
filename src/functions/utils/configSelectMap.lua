function configSelectMap()
  local maps

  if gameStats.realMode then
    return {}
  end

  if gameStats.threeTeamsMode then
    maps = customMapsThreeTeamsMode

    return maps
  end

  if gameStats.teamsMode or gameStats.twoTeamsMode then
    maps = customMapsFourTeamsMode
    return maps
  end

  maps = customMaps

  return maps
end

-- Keep catalog IDs stable when the visible list is filtered.
function isMapAvailable(index)
  local entry = configSelectMap()[index]
  if not entry then return false end
  local column = 1
  if not (gameStats.teamsMode or gameStats.twoTeamsMode or gameStats.threeTeamsMode) then
    local size = gameStats.setMapName
    if size == 'extra-large' then column = 'extraLarge'
    elseif size == 'large' then column = 2
    elseif size == '' then
      -- Automatic size can change with the player count.
      return type(entry[1]) == 'string' and entry[1] ~= ''
        and type(entry[2]) == 'string' and entry[2] ~= ''
    end
  end
  return type(entry[column]) == 'string' and entry[column] ~= ''
end

function availableMaps()
  local items, indices = {}, {}
  local maps, column, automatic = configSelectMap(), 1, false
  if not (gameStats.teamsMode or gameStats.twoTeamsMode or gameStats.threeTeamsMode) then
    local size = gameStats.setMapName
    if size == 'extra-large' then column = 'extraLarge'
    elseif size == 'large' then column = 2
    elseif size == '' then automatic = true end
  end
  for index, entry in ipairs(maps) do
    local value = entry[column]
    if type(value) == 'string' and value ~= ''
      and (not automatic or (type(entry[2]) == 'string' and entry[2] ~= '')) then
      items[#items+1], indices[#indices+1] = entry, index
    end
  end
  return items, indices
end

function refreshMapSizeSelection()
  if gameStats.isCustomMap and not isMapAvailable(gameStats.customMapIndex) then
    gameStats.isCustomMap, gameStats.randomMap, gameStats.customMapIndex = false, false, 0
    tfm.exec.chatMessage('<j>The selected map is unavailable at this size. Choose another map.<n>', nil)
  end
  gameStats.mapIndexSelected = 0
  resetMapsList()
end
