function eventLoop(elapsedTime, remainingTime)
  if gameStats.isGamePaused then
    tfm.exec.setGameTime(durationTimerPause, true)
  end

  if mode == "startGame" then
    local x = math.ceil((initGame - os.time())/1000)
    local c = string.format("%d", x)
    if not gameStats.stopTimer then
      gameStats.initTimer = x
      ui.addTextArea(7, "<p align='center'>"..c.."", nil, 375, 50, 30, 20, 0x161616, 0x161616, 1, false)
    end
    
    if x == 0 and not gameStats.stopTimer then
      local playersOnGame = quantityPlayers()

      if gameStats.realMode then
        if playersOnGame.red >= 2 and playersOnGame.blue >= 2 then
          rankCrown = rankRealMode
          rulesTimer = os.time() + 10000
          mode = "showRules"
          for name, data in pairs(tfm.get.room.playerList) do
            ui.addWindow(266, ""..playerLanguage[name].tr.realModeRules.."", name, 125, 60, 650, 300, 1, false, true, playerLanguage[name].tr.closeUIText)
          end
          removeWindowsOnBottom()

          return
        else
          initGame = os.time() + 25000
          return
        end
      end

      if gameStats.threeTeamsMode then
        if playersOnGame.red >= 1 and playersOnGame.blue >= 1 and playersOnGame.green >= 1 then
          gameStats.actualMode = "3 teams mode"
          rankCrown = rankThreeTeamsMode
          gameStats.redX = 599
          gameStats.blueX = 1199
          gameStats.greenX = 1201
          removeTextAreasOfLobby()
          removeWindowsOnBottom()

          mode = "gameStart"
          gameStats.typeMap = "large4v4"
          startGame()

          return
        else
          initGame = os.time() + 25000
          return
        end
      end

      if gameStats.teamsMode then
        if playersOnGame.red >= 1 and playersOnGame.blue >= 1 and playersOnGame.yellow >= 1 and playersOnGame.green >= 1 then
          gameStats.actualMode = "4 teams mode"
          rankCrown = rankFourTeamsMode
          removeTextAreasOfLobby()
          removeWindowsOnBottom()
          gameStats.yellowX = 399
          gameStats.redX = 799
          gameStats.blueX = 1199
          gameStats.greenX = 1201

          mode = "gameStart"
          gameStats.typeMap = "large4v4"
          startGame()

          return
        else
          initGame = os.time() + 25000
          return
        end
      end

      if gameStats.twoTeamsMode then
        if playersOnGame.red >= 2 and playersOnGame.blue >= 2 then
          rankCrown = rankTwoTeamsMode
          removeTextAreasOfLobby()
          removeWindowsOnBottom()
          gameStats.blueX = 399
          gameStats.redX = 799
          gameStats.blueX2 = 1199
          gameStats.redX2 = 1201

          mode = "gameStart"
          gameStats.typeMap = "large4v4"
          startGame()

          return
        else
          initGame = os.time() + 25000

          return
        end
      end

      if playersOnGame.red >= 1 and playersOnGame.blue >= 1 then
        removeTextAreasOfLobby()
        removeWindowsOnBottom()
        rankCrown = rankNormalMode
        if playersOnGame.red <= 3 or playersOnGame.blue <= 3 then
          gameStats.gameMode = "3v3"
          gameStats.redX = 399
          gameStats.blueX = 401
        end

        if playersOnGame.red >= 4 or playersOnGame.blue >= 4 then
          gameStats.gameMode = "4v4"
          gameStats.redX = 599
          gameStats.blueX = 601
        end
        mode = "gameStart"
        startGame()
      else
        initGame = os.time() + 25000
      end
    end
  elseif mode == "showRules" then
    local x = math.ceil((rulesTimer - os.time())/1000)
    local c = string.format("%d", x)

    if x == 0 then
      gameStats.redX = 601
      gameStats.blueX = 1999
      closeWindow(266, nil)
      mode = "gameStart"
      startGame()
    end
  elseif mode == "endGame" then
    local x = math.ceil((gameTimeEnd - os.time())/1000)
    local c = string.format("%d", x)
    if x == 0 then
      countMatches = countMatches + 1
      ui.removeTextArea(899899)
      ui.removeTextArea(8998991)
      removeTimer('verifyBallCoordinates')
      init()
    end
  end
  timersLoop()
end
