function gameMaps.selectionCatalog()
  if gameState.match.mode.realMode then
    return {}
  end
  if gameState.match.mode.threeTeamsMode then
    return customMapsThreeTeamsMode
  end
  if gameState.match.mode.teamsMode or gameState.match.mode.twoTeamsMode then
    return customMapsFourTeamsMode
  end
  return customMaps
end

do
  local function selectionRules()
    if not (gameState.match.mode.teamsMode or gameState.match.mode.twoTeamsMode or gameState.match.mode.threeTeamsMode) then
      local size = gameState.match.maps.setMapName
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
  function gameMaps.isAvailable(index)
    local entry = gameMaps.selectionCatalog()[index]
    local column, automatic = selectionRules()
    return hasVariant(entry, column, automatic)
  end

  function gameMaps.availableEntries()
    local items, indices = {}, {}
    local maps = gameMaps.selectionCatalog()
    local column, automatic = selectionRules()
    for index, entry in ipairs(maps) do
      if hasVariant(entry, column, automatic) then
        items[#items+1], indices[#indices+1] = entry, index
      end
    end
    return items, indices
  end
end

function gameMaps.refreshSizeSelection()
  if gameState.match.maps.isCustomMap and not gameMaps.isAvailable(gameState.match.maps.customMapIndex) then
    gameState.match.maps.isCustomMap, gameState.match.maps.randomMap, gameState.match.maps.customMapIndex = false, false, 0
    tfm.exec.chatMessage('<j>The selected map is unavailable at this size. Choose another map.<n>', nil)
  end
  gameState.match.maps.mapIndexSelected = 0
  mapVoting.resetMapList()
end
