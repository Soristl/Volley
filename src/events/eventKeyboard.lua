function eventKeyboard(name, key, down, x, y, xv, yv)
  local OffsetX = 0
  local OffsetY = 0

  if xv < 0 then
    OffsetX = -15
  elseif xv > 0 then
    OffsetX = 15
  end
  if yv < 0 then
    OffsetY = -5
  elseif yv > 0 then
    OffsetY = 5
  end

  local coordinatesX = (x + xv) + OffsetX
  local coordinatesY = (y + yv) + OffsetY
  tfm.get.room.playerList[name].x = coordinatesX
  tfm.get.room.playerList[name].y = coordinatesY

  if key == 0 or key == 1 or key == 2 or key == 3 then
    playersAfk[name] = os.time()

    removePlayerTrophy(name)
  end

  if key == 80 then
    if isOpenProfile[name] then
      closeAllWindows(name)
      closeRankingUI(name)
      removeButtons(25, name)
      removeButtons(26, name)
      closeWindow(24, name)
      closeWindow(25, name)
      removeUITrophies(name)

      return
    end
    closeAllWindows(name)
    closeRankingUI(name)
    removeButtons(25, name)
    removeButtons(26, name)
    removeUITrophies(name)
    profileUI(name, name)
  end

  if key == 76 then
    if openRank[name] then
      openRank[name] = false
      closeAllWindows(name)
      
      ui.removeTextArea(99992, name)
      closeWindow(266, name)
      removeButtons(25, name)
      removeButtons(26, name)
      closeRankingUI(name)
    else
      openRank[name] = true
      ui.addWindow(24, "<p align='center'><font size='16px'>", name, 125, 60, 650, 300, 1, false, true, playerLanguage[name].tr.closeUIText)
      ui.addTextArea(9999543, "<p align='center'>Room Ranking", name, 17, 168, 100, 20, 0x142b2e, 0x8a583c, 1, true)
      ui.addTextArea(9999544, "<p align='center'><n2>Global Ranking<n>", name, 17, 268, 100, 18, 0x142b2e, 0x8a583c, 1, true)
      showMode(playerRankingMode[name], name)
    end
  end

  if playerInGame[name] and mode == "gameStart" then

    if key == 0 or key == 2 then
      playerLeftRight[name] = key
    end

    if gameStats.consumables then
      if not gameStats.teamsMode and not gameStats.twoTeamsMode and not gameStats.realMode then
        local keysEmote = {55, 56, 57, 48}
        local consumablesId = {65, 80, 6, 34}
        local consumablesNames = {"pufferfish", "paper plane", "ball", "snow ball"}

        for i = 1, #keysEmote do
          if keysEmote[i] == key then
            playerConsumableKey[name] = keysEmote[i]
            playerConsumableItem[name] = consumablesId[i]
            tfm.exec.chatMessage("<bv>You chose the consumable "..consumablesNames[i].."<n>", name)
            print("<bv>You chose the consumable "..consumablesNames[i].."<n>")
          end
        end

        if key == 77 then
          if not playerConsumable[name] then
            tfm.exec.chatMessage("<bv>You need wait 5 seconds to spawn a new consumable<n>", name)
            print("<bv>You need wait 5 seconds to spawn a new item<n>")

            return
          end
          local speed = setConsumablesForce(playerConsumableKey[name], playerLeftRight[name])
          playerConsumable[name] = false

          local enablePlayerConsumable = addTimer(function(i)
            if i == 1 then
              playerConsumable[name] = true
              tfm.exec.chatMessage("<bv>You can spawn a new consumable<n>", name)
              print("<bv>You can spawn a new consumable <n>")
            end
          end, 5000, 1, "enablePlayerConsumable")

          local id = tfm.exec.addShamanObject(playerConsumableItem[name], x + OffsetX + (OffsetX / 2), y + speed[3], 0, speed[1], speed[2], false)
          playerConsumables[#playerConsumables + 1] = id

          local removeShamanObject = addTimer(function(i)
            if i == 1 then
              tfm.exec.removeObject(playerConsumables[1])
              table.remove(playerConsumables, 1)
            end
          end, 15000, 1, "removeShamanObject")
        end
      end
    end

    if gameStats.realMode then
      if key == 49 then
        playerForce[name] = 0
        tfm.exec.chatMessage("<bv>Your strength changed to normal<n>", name)
      elseif key == 50 then
        playerForce[name] = -0.2
        tfm.exec.chatMessage("<bv>Your strength has been reduced by 20%<n>", name)
      elseif key == 51 then
        playerForce[name] = -0.45
        tfm.exec.chatMessage("<bv>Your strength has been reduced by 45%<n>", name)
      elseif key == 52 then
        playerForce[name] = -1
        tfm.exec.chatMessage("<bv>Your strength has been reduced by 100%<n>", name)
      end

      if x <= 599 or x >= 2001 then
        if not playerOutOfCourt[name] and not showOutOfCourtText[name] then
          showOutOfCourtText[name] = true
          tfm.exec.chatMessage("<bv>you are outside the court you have 7 seconds to make an action, otherwise you will not be able to use the space key outside the court<n>", name)
          print("<bv>you are outside the court you have 7 seconds to make an action, otherwise you will not be able to use the space key outside the court<n>")
        end
        delayToDoAnAction = addTimer(function(i)
          if i == 1 then
            playerOutOfCourt[name] = true
          end
        end, 7000, 1, "delay"..name.."")
      end

      if x > 599 and x < 2001 then
        removeTimer("delay"..name.."")
        showOutOfCourtText[name] = false
        playerOutOfCourt[name] = false
      end
      if gameStats.redServe and name ~= gameStats.redPlayerServe then
        return
      end

      if gameStats.blueServe and name ~= gameStats.bluePlayerServe then
        return
      end
    end
    if key == 32 and gameStats.canTransform and playerCanTransform[name] and not playerOutOfCourt[name] then
      local aditionalForce = 0

      if gameStats.realMode then
        local playerCanSpawn = verifyPlayerTeam(name)
        local searchPlayerTeam = searchPlayerTeam(name)

        if searchPlayerTeam == "red" and gameStats.redQuantitySpawn >= 0 then
          aditionalForce = 0 + playerForce[name]
        end

        if searchPlayerTeam == "blue" and gameStats.blueQuantitySpawn >= 0 then
          aditionalForce = 0 + playerForce[name]
        end

        if gameStats.redServe then
          gameStats.redServe = false
          aditionalForce = 0.34
        end

        if gameStats.blueServe then
          gameStats.blueServe = false
          aditionalForce = 0.34
        end

        if not playerCanSpawn then
          return
        end

        if gameStats.redQuantitySpawn == 3 then
          aditionalForce = 0.2 + playerForce[name]
        end

        if gameStats.blueQuantitySpawn == 3 then
          aditionalForce = 0.2 + playerForce[name]
        end

        if gameStats.reduceForce and searchPlayerTeam == gameStats.teamWithOutAce then
          gameStats.reduceForce = false
          aditionalForce = -0.45 + playerForce[name]
        end

        playerNearOfTheBall(name, x, y)
      end

      playerCanTransform[name] = false
      playerPhysicId[name] = countId
      tfm.exec.killPlayer (name)
      tfm.exec.addPhysicObject (playerPhysicId[name], coordinatesX, coordinatesY, {
        type = 13,
        width = 20,
        height = 20,
        restitution = gameStats.psyhicObjectForce + aditionalForce,
        friction = 0,
        color = 0x81348A,
        miceCollision = false,
        groundCollision = true
      })

      local groundId = playerPhysicId[name]

      removeGround = addTimer(function(i)
        if i == 1 then
          tfm.exec.removePhysicObject(groundId)
          tfm.exec.respawnPlayer(name)
          setCrownToPlayer(name)
          if playerInGame[name] then
            tfm.exec.movePlayer (name, x, y)
          end
          delayOnTransform = addTimer(function(i)
            if i == 1 then
              playerCanTransform[name] = true
            end
          end, 500, 1, "delayOnTransform")
        end
      end, 3000, 1, "removeGround"..name.."")
      countId = countId + 1
      for i = 1, #playersRed do
        if playersRed[i].name == name then
          tfm.exec.setNameColor(name, 0xEF4444)
          break
        end
      end
      for i = 1, #playersBlue do
        if playersBlue[i].name == name then
          tfm.exec.setNameColor(name, 0x3B82F6)
          break
        end
      end
    end
  end
end
