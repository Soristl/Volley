function eventNewPlayer(name)
  if string.sub(name, 1, 1) == "*" then
    tfm.exec.chatMessage("<bv>This room does not allow guest accounts to enter. Create an account to enter the room.<n>",
      name)
    tfm.exec.kickPlayer(name)

    return
  end

  if tfm.get.room.isTribeHouse then
    if tfm.get.room.name:sub(3) == tfm.get.room.playerList[name].tribeName then
      USER_PERMISSIONS[name] = 2

      if name == "Tonycoolnees#0000" then
        USER_PERMISSIONS["Tonycoolnees#0000"] = 4
      end
    end
  end

  pagePlayerSettings[name] = 1
  customMapCommand[name] = true

  selectMapOpen[name] = false
  selectMapPage[name] = 1
  selectMapImages[name] = {}

  isOpenProfile[name] = false
  playerTrophyImage[name] = 0
  if playerAchievements[name] == nil then
    playerAchievements[name] = {
      [1] = { image = "img@193d6763c82", quantity = 0 },
      [2] = { image = '19636907e9e.png', quantity = 0 },
      [3] = { image = "197d9272515.png", quantity = 0 },
      [4] = { image = "1984ac78d52.png", quantity = 0 },
      [5] = { image = "1984ac773d3.png", quantity = 0 }
    }
  end

  settings[name] = false
  settingsMode[name] = false

  playerAchievementsImages[name] = {}
  playerLeft[name] = false
  playerLeftRight[name] = 0
  playerConsumable[name] = true
  playerConsumableKey[name] = 56
  playerConsumableItem[name] = 80
  playerForce[name] = 0
  playerOutOfCourt[name] = false

  showOutOfCourtText[name] = false
  openRank[name] = false
  playerLanguage[name] = { tr = trad, name = name }
  pagesList[name] = { helpPage = 1 }
  playersAfk[name] = os.time()
  playerPressSpace[name] = false

  showCrownToAllPlayers()
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

  if gameStats.killSpec or killSpecPermanent then
    tfm.exec.killPlayer(name)
  else
    tfm.exec.respawnPlayer(name)
  end

  if playersNormalMode[name] == nil then
    --[[
      This could all be inside one single table:
      --Vit0rg
    ]]
    playersNormalMode[name] = { name = name, matches = 0, wins = 0, winRatio = 0, winsRed = 0, winsBlue = 0 }
    playersFourTeamsMode[name] = { name = name, matches = 0, wins = 0, winRatio = 0, winsRed = 0, winsBlue = 0, winsYellow = 0, winsGreen = 0 }
    playersThreeTeamsMode[name] = { name = name, matches = 0, wins = 0, winRatio = 0, winsRed = 0, winsBlue = 0, winsGreen = 0 }
    playersTwoTeamsMode[name] = { name = name, matches = 0, wins = 0, winRatio = 0, winsRed = 0, winsBlue = 0 }
    playersRealMode[name] = { name = name, matches = 0, wins = 0, winRatio = 0, winsRed = 0, winsBlue = 0 }

    --[[
      This could also  all be inside one single table:
      --Vit0rg
    ]]
    pageFourTeamsMode[name] = 1
    pageNormalMode[name] = 1
    pageThreeTeamsMode[name] = 1
    pageTwoTeamsMode[name] = 1
    pageRealMode[name] = 1

    playerRankingMode[name] = "Normal mode"
  end

  playerCanTransform[name] = true
  playerInGame[name] = false
  playerPhysicId[name] = 0
  local keys = { 32, 0, 1, 2, 3, 49, 50, 51, 52, 55, 56, 57, 48, 77, 76, 80 }

  for i = 1, #keys do
    system.bindKeyboard(name, keys[i], true, true)
  end

  tfm.exec.setNameColor(name, 0xD1D5DB)
  if playerBan[name] then
    tfm.exec.chatMessage("<bv>You have been banned from the room by the admin " .. playerBanHistory[name] .. "<n>", name)
    tfm.exec.kickPlayer(name)
  end

  if isPlayerDead[name] == nil then
    isPlayerDead[name] = false
  end

  ui.addWindow(23, "<p align='center'><font size='13px'><a href='event:menuOpen'>Menu", name, 5, 15, 100, 30, 0.2, false, false, _)
  tfm.exec.chatMessage(playerLanguage[name].tr.welcomeMessage, name)

  if mode == "startGame" then
    eventNewGameShowLobbyTexts()

    ui.addWindow(30, "<p align='center'><font size='13px'><a href='event:selectMap'>Select a map", name, 10, 370, 150, 30,
      1, false, false, _)

    if USER_PERMISSIONS[name] > 1 then
      ui.addWindow(31, "<p align='center'><font size='13px'><a href='event:settings'>Room settings", name, 180, 370, 150,
        30, 1, false, false, _)
    end
  elseif mode ~= "startGame" then
    tfm.exec.chatMessage("<ch>If you don't want to see the ranking crowns, type the command !crown false<n>", name)
    showTheScore()
    teleportPlayersToSpecWithSpecificSpawn(name)

    tfm.exec.chatMessage(playerLanguage[name].tr.welcomeMessage2, name)
    canVote[name] = true
  end
  tfm.exec.chatMessage("<j>#Volley Version: " .. gameVersion .. "<n>", name)
  tfm.exec.chatMessage("<ce>Join our #Volley Discord server: https://discord.com/invite/pWNTesmNhu<n>", name)
end
