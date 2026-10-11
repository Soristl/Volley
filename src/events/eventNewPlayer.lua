do
-- Forget handles and work belonging to the previous connection before resetting flags.
local function clearPreviousConnection(name)
  lobbyTransition.leave(name) -- A reconnect invalidates work for the former connection.
  timers.clearPlayer(name, false)
  playerRuntime.clearGameplay(name)
  clubhouse.removePlayerTrophy(name)
  gameCrowns.clearPlayer(name)
  -- Client images and textareas are lost on disconnect: discard cached handles.
  clubhouse.clearPlayer(name)
  clubhouse.ballSkins.clearPlayer(name)
end

-- First-time key binding still precedes admission; reconnect binding happens after it.
local function preparePlayerAccess(name)
  if string.match(name, "%*") then
    tfm.exec.chatMessage("<bv>This room does not allow guest accounts to enter. Create an account to enter the room.<n>",
      name)
    playerState.banHistory[name] = "VOLLEY SYSTEM"
    playerState.ban[name] = true

  end

  local keysBound = playerRuntime.initializeData(name)

  if tfm.get.room.isTribeHouse then
    if tfm.get.room.name:sub(3) == tfm.get.room.playerList[name].tribeName then
      if roomConfig.permissions[name] == nil then
        roomConfig.permissions[name] = 2
      end
    end
  end
  return keysBound
end

-- Reset connection-specific controls without replacing session achievements.
local function resetConnectionState(name)
  uiState.pagePlayerSettings[name] = 1
  uiState.customMapCommand[name] = true

  uiState.selectMapOpen[name] = false
  uiState.selectMapPage[name] = 1
  uiState.selectMapImages[name] = {}
  uiState.selectBallOpen[name] = false
  uiState.selectBallPage[name] = 1

  uiState.isOpenProfile[name] = false
  playerState.trophyImage[name] = 0
  if playerState.achievements[name] == nil then
    playerState.achievements[name] = playerRuntime.createAchievements()
  end

  uiState.settings[name] = false
  uiState.settingsMode[name] = false

  uiState.playerAchievementsImages[name] = {}
  playerState.left[name] = false
  playerState.lastDirection[name] = 0
  playerState.consumables.ready[name] = true
  playerState.consumables.key[name] = 56
  playerState.consumables.item[name] = 80
  playerState.force[name] = 0
  playerState.outOfCourt[name] = false

  playerState.outOfCourtText[name] = false
  uiState.openRank[name] = false
  playerState.language[name] = { tr = trad, name = name }
  uiState.pagesList[name] = { helpPage = 1 }
  playerState.afk[name] = os.time()
  playerState.pressSpace[name] = false
end

-- Preserve session choices and ranking pages when the same player reconnects.
local function initializeSessionRecords(name)
  if gameState.voting.eligible[name] == nil then
    gameState.voting.eligible[name] = true
  end

  if playerState.crownVisible[name] == nil then
    playerState.crownVisible[name] = true
  end

  sessionRanking.prepareReconnect(name)

  if playerState.ban[name] == nil then
    playerState.ban[name] = false
    playerState.banHistory[name] = ""
  end
  if sessionRanking.ensurePlayer(name) then
    --[[
      This could also  all be inside one single table:
      --Vit0rg
    ]]
    uiState.pageFourTeamsMode[name] = 1
    uiState.pageNormalMode[name] = 1
    uiState.pageThreeTeamsMode[name] = 1
    uiState.pageTwoTeamsMode[name] = 1
    uiState.pageRealMode[name] = 1

    uiState.playerRankingMode[name] = "Normal mode"
  end
end

-- A lobby transition queues rendering; other phases keep their existing presentation order.
local function showPlayerArrival(name)
  if lobbyTransition.blocksInput() then
    lobbyTransition.enqueue(name)
    tfm.exec.chatMessage(playerState.language[name].tr.welcomeMessage, name)
    tfm.exec.chatMessage("<j>#Volley Version: " .. gameVersion .. "<n>", name)
    tfm.exec.chatMessage("<ce>Join our #Volley Discord server: https://discord.com/invite/pWNTesmNhu<n>", name)
    return
  end

  ui.addWindow(23, "<p align='center'><font size='13px'><a href='event:menuOpen'>Menu", name, 5, 15, 100, 30, 0.2, false, false, _)
  tfm.exec.chatMessage(playerState.language[name].tr.welcomeMessage, name)

  if gameState.phase == "startGame" then
    clubhouse.lobby(name)
    clubhouse.renderLobby(name)

    ui.addWindow(30, "<p align='center'><font size='13px'><a href='event:selectMap'>Select a map/ball", name, 10, 370, 150, 30,
      1, false, false, _)

    clubhouse.launcher(name,31)
  elseif gameState.phase ~= "startGame" then
    tfm.exec.chatMessage("<ch>If you don't want to see the ranking crowns, type the command !crown false<n>", name)
    -- Transitional maps can leave every viewer's score pending a redraw.
    if not mapLoad.isReady() or timers.find('delayToToggleMap') then
      clubhouse.showScores()
    else
      clubhouse.showScores(name)
    end
    gameTeams.placeSpectator(name)

    tfm.exec.chatMessage(playerState.language[name].tr.welcomeMessage2, name)
    gameState.voting.eligible[name] = true
  end
  gameCrowns.showAll(name)
  mapBackgrounds.showBorders(name)
  mapBackgrounds.show(name)
  clubhouse.ballSkins.show(name)
  tfm.exec.chatMessage("<j>#Volley Version: " .. gameVersion .. "<n>", name)
  tfm.exec.chatMessage("<ce>Join our #Volley Discord server: https://discord.com/invite/pWNTesmNhu<n>", name)
end

function eventNewPlayer(name)
  if type(name) ~= 'string' or not tfm.get.room.playerList[name] then return end
  clearPreviousConnection(name)
  local keysBound = preparePlayerAccess(name)
  resetConnectionState(name)
  initializeSessionRecords(name)

  playerState.canTransform[name] = true
  playerState.inGame[name] = false
  playerState.physicId[name] = 0
  -- A kick is asynchronous. Finish safe data initialization, then stop
  -- before respawning, drawing UI or granting room ownership.
  if playerState.ban[name] or (roomConfig.statisticsCutoff ~= 0 and
      (tfm.get.room.playerList[name].registrationDate or 0) > roomConfig.statisticsCutoff) then
    playerState.left[name] = true
    timers.clearPlayer(name, true)
    if playerState.ban[name] and not name:find('*', 1, true) then
      tfm.exec.chatMessage("<bv>You have been banned from the room by the admin " .. playerState.banHistory[name] .. "<n>", name)
    end
    tfm.exec.kickPlayer(name)
    return
  end

  -- First-time initialization already binds keys; reconnects still need them.
  if not keysBound then playerRuntime.bindKeys(name) end
  tfm.exec.setNameColor(name, 0xD1D5DB)

  if gameState.match.rules.killSpec or roomConfig.killSpectators then
    tfm.exec.killPlayer(name)
  else
    tfm.exec.respawnPlayer(name)
  end

  roomConfig.assignCreator(name)

  if playerState.dead[name] == nil then
    playerState.dead[name] = false
  end

  showPlayerArrival(name)
end
end
