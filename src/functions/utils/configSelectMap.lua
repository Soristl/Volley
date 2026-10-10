function configSelectMap()
  if gameStats.realMode then
    return {}
  end
  if gameStats.threeTeamsMode then
    return customMapsThreeTeamsMode
  end
  if gameStats.teamsMode or gameStats.twoTeamsMode then
    return customMapsFourTeamsMode
  end
  return customMaps
end

do
  local function selectionRules()
    if not (gameStats.teamsMode or gameStats.twoTeamsMode or gameStats.threeTeamsMode) then
      local size = gameStats.setMapName
      if size == 'extra-large' then return 'extraLarge', false end
      if size == 'large' then return 2, false end
      -- Automatic sizing must support both courts as the player count changes.
      if size == '' then return 1, true end
    end
    return 1, false
  end

  local function hasVariant(entry, column, automatic)
    if not entry then return false end
    local value = entry[column]
    return type(value) == 'string' and value ~= ''
      and (not automatic or (type(entry[2]) == 'string' and entry[2] ~= ''))
  end

  -- Menus, commands and votes share the same rule and stable catalog IDs.
  function isMapAvailable(index)
    local entry = configSelectMap()[index]
    local column, automatic = selectionRules()
    return hasVariant(entry, column, automatic)
  end

  function availableMaps()
    local items, indices = {}, {}
    local maps = configSelectMap()
    local column, automatic = selectionRules()
    for index, entry in ipairs(maps) do
      if hasVariant(entry, column, automatic) then
        items[#items+1], indices[#indices+1] = entry, index
      end
    end
    return items, indices
  end
end

function refreshMapSizeSelection()
  if gameStats.isCustomMap and not isMapAvailable(gameStats.customMapIndex) then
    gameStats.isCustomMap, gameStats.randomMap, gameStats.customMapIndex = false, false, 0
    tfm.exec.chatMessage('<j>The selected map is unavailable at this size. Choose another map.<n>', nil)
  end
  gameStats.mapIndexSelected = 0
  resetMapsList()
end
