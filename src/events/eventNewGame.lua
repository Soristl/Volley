do
local function initializeFirstMap()
  local config, reason = roomConfig.readLobby()
  if not config then
    tfm.exec.chatMessage("<r>Lobby configuration error: " .. reason .. ". Waiting for valid XML.<n>", nil)
    return false
  end
  roomConfig.applyPermissions(config)
  roomConfig.applyAccessRules(config)
  roomConfig.firstRun = false
  if roomConfig.creator.pendingName then
    local pendingName = roomConfig.creator.pendingName
    roomConfig.creator.pendingName = nil
    roomConfig.assignCreator(pendingName)
  end
  if not roomConfig.creator.name then
    roomConfig.initializeCreator()
  end
  return true
end

function eventNewGame()
  if lobbyTransition.blocksInput() then lobbyTransition.onMapLoaded();return end
  groundProfile.reset()
  mapBackgrounds.newGame()
  gameBalls.forget()
  gameCrowns.showAll()
  clubhouse.ballSkins.reset()
  clubhouse.newGame()
  if roomConfig.firstRun and not initializeFirstMap() then return end

  if roomConfig.autoSync then roomSync.refresh() end

  if gameState.phase == "gameStart" then
    gameMaps.onGameplayLoaded()
  end
end
end
