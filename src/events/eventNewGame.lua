do
local function initializeFirstMap()
  local config, reason = readLobbyConfig()
  if not config then
    tfm.exec.chatMessage("<r>Lobby configuration error: " .. reason .. ". Waiting for valid XML.<n>", nil)
    return false
  end
  initUsersPermissions(config)
  lobbyMapConfig(config)
  firstRun = false
  if roomCreator.pendingName then
    local pendingName = roomCreator.pendingName
    roomCreator.pendingName = nil
    assignRoomCreator(pendingName)
  end
  if not roomCreator.name then
    initializeRoomCreator()
  end
  return true
end

function eventNewGame()
  if lobbyTransition.blocksInput() then lobbyTransition.onMapLoaded();return end
  groundProfile.reset()
  mapBackgrounds.newGame()
  gameBalls.forget()
  showCrownToAllPlayers()
  clubhouse.ballSkins.reset()
  clubhouse.newGame()
  if firstRun and not initializeFirstMap() then return end

  if autosync then refletzSyncSystem() end

  if gameState.phase == "gameStart" then
    gameMaps.onGameplayLoaded()
  end
end
end
