do
-- Forget handles and work belonging to the previous connection before resetting flags.
local function clearPreviousConnection(name)
  lobbyTransition.leave(name) -- A reconnect invalidates work for the former connection.
  clearPlayerTimers(name, false)
  clearPlayerGameplay(name)
  removePlayerTrophy(name)
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
    playerBanHistory[name] = "VOLLEY SYSTEM"
    playerBan[name] = true

  end

  local keysBound = setPlayerData(name)

  if tfm.get.room.isTribeHouse then
    if tfm.get.room.name:sub(3) == tfm.get.room.playerList[name].tribeName then
      if USER_PERMISSIONS[name] == nil then
        USER_PERMISSIONS[name] = 2
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
  playerTrophyImage[name] = 0
  if playerAchievements[name] == nil then
    playerAchievements[name] = newPlayerAchievements()
  end

  uiState.settings[name] = false
  uiState.settingsMode[name] = false

  uiState.playerAchievementsImages[name] = {}
  playerLeft[name] = false
  playerLeftRight[name] = 0
  playerConsumable[name] = true
  playerConsumableKey[name] = 56
  playerConsumableItem[name] = 80
  playerForce[name] = 0
  playerOutOfCourt[name] = false

  showOutOfCourtText[name] = false
  uiState.openRank[name] = false
  playerLanguage[name] = { tr = trad, name = name }
  uiState.pagesList[name] = { helpPage = 1 }
  playersAfk[name] = os.time()
  playerPressSpace[name] = false
end

-- Preserve session choices and ranking pages when the same player reconnects.
local function initializeSessionRecords(name)
  if canVote[name] == nil then
    canVote[name] = true
  end

  if showCrownImages[name] == nil then
    showCrownImages[name] = true
  end

  if playersOnGameHistoric[name] == nil then
    playersOnGameHistoric[name] = { teams = {} }
  end

  if playerLastMatchCount[name] == nil then
    playerLastMatchCount[name] = countMatches
  else
    if playerLastMatchCount[name] ~= countMatches then
      playersOnGameHistoric[name] = { teams = {} }
    end
  end

  if playerBan[name] == nil then
    playerBan[name] = false
    playerBanHistory[name] = ""
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
    tfm.exec.chatMessage(playerLanguage[name].tr.welcomeMessage, name)
    tfm.exec.chatMessage("<j>#Volley Version: " .. gameVersion .. "<n>", name)
    tfm.exec.chatMessage("<ce>Join our #Volley Discord server: https://discord.com/invite/pWNTesmNhu<n>", name)
    return
  end

  ui.addWindow(23, "<p align='center'><font size='13px'><a href='event:menuOpen'>Menu", name, 5, 15, 100, 30, 0.2, false, false, _)
  tfm.exec.chatMessage(playerLanguage[name].tr.welcomeMessage, name)

  if gameState.phase == "startGame" then
    clubhouse.lobby(name)
    eventNewGameShowLobbyTexts(name)

    ui.addWindow(30, "<p align='center'><font size='13px'><a href='event:selectMap'>Select a map/ball", name, 10, 370, 150, 30,
      1, false, false, _)

    clubhouse.launcher(name,31)
  elseif gameState.phase ~= "startGame" then
    tfm.exec.chatMessage("<ch>If you don't want to see the ranking crowns, type the command !crown false<n>", name)
    -- Transitional maps can leave every viewer's score pending a redraw.
    if not isGameplayMapReady() or getTimerId('delayToToggleMap') then
      clubhouse.showScores()
    else
      clubhouse.showScores(name)
    end
    gameTeams.placeSpectator(name)

    tfm.exec.chatMessage(playerLanguage[name].tr.welcomeMessage2, name)
    canVote[name] = true
  end
  showCrownToAllPlayers(name)
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

  playerCanTransform[name] = true
  playerInGame[name] = false
  playerPhysicId[name] = 0
  -- A kick is asynchronous. Finish safe data initialization, then stop
  -- before respawning, drawing UI or granting room ownership.
  if playerBan[name] or (timestamp ~= 0 and
      (tfm.get.room.playerList[name].registrationDate or 0) > timestamp) then
    playerLeft[name] = true
    clearPlayerTimers(name, true)
    if playerBan[name] and not name:find('*', 1, true) then
      tfm.exec.chatMessage("<bv>You have been banned from the room by the admin " .. playerBanHistory[name] .. "<n>", name)
    end
    tfm.exec.kickPlayer(name)
    return
  end

  -- First-time initialization already binds keys; reconnects still need them.
  if not keysBound then bindKeys(name) end
  tfm.exec.setNameColor(name, 0xD1D5DB)

  if gameStats.killSpec or killSpecPermanent then
    tfm.exec.killPlayer(name)
  else
    tfm.exec.respawnPlayer(name)
  end

  assignRoomCreator(name)

  if isPlayerDead[name] == nil then
    isPlayerDead[name] = false
  end

  showPlayerArrival(name)
end
end
