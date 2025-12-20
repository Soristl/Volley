local short_commands = { j = "join", l = "leave", la = "lang", ads = "admins", b = "balls", 
                   vm = "votemap", cr = "crown", pr = "profile", rt = "resettimer",
                   skip = "skiptimer", stop = "stoptimer", smp = "setmaxplayers",
                   w = "winscore", rm = "randommap", cm = "custommap", bc = "ballcoords",
                   ssc = "setscore", ftm = "4teamsmode", rm = "realmode",
                   a = "admin", ua = "unadmin", k = "kick", f = "fleave", b = "ban",
                   ub = "unban", rb = "randomball", cb = "customball", lo = "lobby",
                   ks = "killspec", p = "pause", sy = "sync", ssy = "setsync",
                   syt = "synctfm", lsy = "listsync", spf = "setplayerforce", 
                   t = "test", tt = "2teamsmode", afk = "afksystem", sat = "setafktime",
                   tb = "twoballs", co = "consumables", se = "settings", dc = "discord"
                }

function eventChatCommand(name, c)
  local command = string.lower(c)
  
  if short_commands[command] then
    command = short_commands[command]
  end

  local permanentAdmin = isPermanentAdmin(name)
  

  if command == "join" and playerInGame[name] == false and mode == "gameStart" then
    local isPlayerBanned = messagePlayerIsBanned(name)
    if isPlayerBanned then
      return
    end

    if gameStats.threeTeamsMode and gameStats.canTransform then
      if tfm.get.room.playerList[name].isDead then
        tfm.exec.respawnPlayer(name)
      end

      chooseTeamThreeTeamsMode(name)
      showCrownToAllPlayers()
      return
    end

    if gameStats.teamsMode and gameStats.canTransform then
      if tfm.get.room.playerList[name].isDead then
        tfm.exec.respawnPlayer(name)
      end
      chooseTeamTeamsMode(name)
      showCrownToAllPlayers()
      return
    else
      if not gameStats.teamsMode then
        if tfm.get.room.playerList[name].isDead then
          tfm.exec.respawnPlayer(name)
        end
        chooseTeam(name)
        showCrownToAllPlayers()
        return
      end
      tfm.exec.chatMessage("<bv>The join command is disabled now, please try the same command in few seconds<n>", name)
      return
    end
  elseif command == "leave" and playerInGame[name] and mode == "gameStart" then
    local isPlayerBanned = messagePlayerIsBanned(name)
    if isPlayerBanned then
      return
    end

    if gameStats.threeTeamsMode and gameStats.canTransform then
      leaveTeamTeamsMode(name)
      return
    end

    if gameStats.teamsMode and gameStats.canTransform then
      leaveTeamTeamsMode(name)
      return
    else
      if not gameStats.teamsMode then
        leaveTeam(name)
        return
      end
      tfm.exec.chatMessage("<bv>The leave command is disabled now, please try the same command in few seconds<n>", name)
      return
    end
  elseif command:sub(1,4)=="lang" then
    local language = string.lower(command:sub(6,7))
    if language == "en" then
      playerLanguage[name].tr = lang.en
    elseif language == "br" then
      playerLanguage[name].tr = lang.br
    elseif language == "ar" then
      playerLanguage[name].tr = lang.ar
    elseif language == "fr" then
      playerLanguage[name].tr = lang.fr
    elseif language == "pl" then
      playerLanguage[name].tr = lang.pl
    end
  elseif command == "admins" then
    local str = ""
    for name, data in pairs(admins) do
      if name ~= "Refletz#6472" and name ~= "Soristl1#0000" then
        if admins[name] then
          str = ""..str.." "..name..""
        end
      end
    end
    tfm.exec.chatMessage("<bv>Admins: "..str.."<n>", name)
    print(str)
  elseif command == "maps" then
    local str = "<bv>Volley maps"
    if gameStats.twoTeamsMode then
      for i = 1, #customMapsFourTeamsMode do
        str = ""..str.."\n"..i.."- "..customMapsFourTeamsMode[i][3]..""
      end
    elseif gameStats.teamsMode then
      for i = 1, #customMapsFourTeamsMode do
        str = ""..str.."\n"..i.."- "..customMapsFourTeamsMode[i][3]..""
      end
    else
      for i = 1, #customMaps do
        str = ""..str.."\n"..i.."- "..customMaps[i][3]..""
      end
    end
    if not gameStats.twoTeamsMode and not gameStats.teamsMode then
      str = ""..str.."\n\nto vote type !votemap number, example: !votemap 1<n>"
    end

    tfm.exec.chatMessage(str, name)
    print(str)
  elseif command == "balls" then
    local str = "<bv>Volley custom balls"
    for i = 1, #balls do
      str = ""..str.."\n"..i.."- "..balls[i].name..""
    end
    str = ""..str.."<n>"
    tfm.exec.chatMessage(str, name)
  elseif command:sub(1, 7) == "votemap" and mode == "startGame" and canVote[name] then
    local isPlayerBanned = messagePlayerIsBanned(name)
    if isPlayerBanned then
      return
    end

    if gameStats.realMode then
      commandNotAvailable(command:sub(1, 7), name)
      return
    end
    local args = split(command)

    if #args < 2 then
      return
    end

    if type(tonumber(args[2])) ~= "number" then
      tfm.exec.chatMessage('<bv>Second parameter invalid, must be a number<n>', name)
      return
    end

    local maps = configSelectMap()
    local indexMap = math.abs(math.floor(tonumber(args[2])))

    if type(indexMap) ~= "number" then
      tfm.exec.chatMessage('<bv>Second parameter invalid, must be a number<n>', name)
      return
    elseif indexMap < 1 or indexMap > #maps then
      tfm.exec.chatMessage('<bv>Second parameter invalid, the map index must be higher than 1 and less than '..tostring(#maps)..'<n>', name)
      return
    end

    canVote[name] = false
    if mapsVotes[indexMap] == nil then
      mapsVotes[indexMap] = 0
    end
    mapsVotes[indexMap] = mapsVotes[indexMap] + 1
    gameStats.totalVotes = gameStats.totalVotes + 1

    for name1, data in pairs(tfm.get.room.playerList) do
      if selectMapPage[name] == selectMapPage[name1] and selectMapOpen[name1] then
        selectMapUI(name1)
      end
    end

    verifyMostMapVoted()
    tfm.exec.chatMessage("<bv>"..name.." voted for the "..maps[indexMap][3].." map ("..tostring(mapsVotes[indexMap]).." votes), type !maps to see the maps list and to vote !votemap (number)<n>", nil)
  elseif command:sub(1, 5) == "crown" then
    local args = split(command)

    if args[2] ~= "true" and args[2] ~= "false" then
      tfm.exec.chatMessage('<bv>Second parameter invalid, must be true or false<n>', name)

      return
    end

    if args[2] == "true" then
      showCrownImages[name] = true

      return
    end

    showCrownImages[name] = false
  elseif command:sub(1, 7) == "profile" then
    closeRankingUI(name)
    removeButtons(25, name)
    removeButtons(26, name)
    removeUITrophies(name)
    local args = split(command)

    if #args == 1 then
      profileUI(name, name)
    else
      for name1, value in pairs(playerAchievements) do
        if string.lower(name1) == args[2] then
          profileUI(name, name1)
        end
      end
    end
  elseif command == "discord" then
    if permanentAdmin then
      tfm.exec.chatMessage("<bv>https://discord.com/invite/pWNTesmNhu", nil)  
      return
    end

    tfm.exec.chatMessage("<bv>https://discord.com/invite/pWNTesmNhu", name)
  end
  
  
  if admins[name] then
    local isPlayerBanned = messagePlayerIsBanned(name)
    if isPlayerBanned then
      return
    end

    if command == "resettimer" and mode == "startGame" then
      initGame = os.time() + 15000

      tfm.exec.chatMessage("<bv>resettimer command enabled by admin "..name.."<n>", nil)
    elseif command:sub(1,11) == "setduration" then
      local args = split(command)

      if #args >= 2 then
        if type(tonumber(args[2])) ~= "number" then
          print('<bv>Second parameter invalid, must be a number<n>', name)
          tfm.exec.chatMessage('<bv>Second parameter invalid, must be a number<n>', name)
          return
        end

        local timer = math.abs(math.floor(tonumber(args[2])))
        duration = os.time() + timer * 1000
        durationTimerPause = timer

        tfm.exec.setGameTime(durationTimerPause, true)
        print("<bv>The match duration was set to "..tostring(durationTimerPause).." seconds by admin "..name.."<n>")
        tfm.exec.chatMessage("<bv>The match duration was set to"..tostring(durationTimerPause).." seconds by admin "..name.."<n>", nil)

        return
      end

      duration = os.time() + durationDefault * 1000
      durationTimerPause = durationDefault
      tfm.exec.setGameTime(durationDefault, true)
      print("<bv>The match duration was set to "..tostring(durationDefault).." seconds by admin "..name.."<n>")
      tfm.exec.chatMessage("<bv>The match duration was set to"..tostring(durationDefault).." seconds by admin "..name.."<n>", nil)
    elseif command == "skiptimer" and mode == "startGame" then
      initGame = os.time() + 5000

      tfm.exec.chatMessage("<bv>skiptimer command enabled by admin "..name.."<n>", nil)
    elseif command == "stoptimer" and mode == "startGame" then
      local permanentAdmin = isPermanentAdmin(name)

      if not permanentAdmin then
        return
      end

      if not gameStats.stopTimer then
        gameStats.stopTimer = true

        tfm.exec.chatMessage("<bv>stoptimer command enabled by admin "..name.."<n>", nil)

        return
      end

      initGame = os.time() + (gameStats.initTimer * 1000)
      gameStats.stopTimer = false
      tfm.exec.chatMessage("<bv>stoptimer command disabled by admin "..name.."<n>", nil)
    elseif command:sub(1, 13) == "setmaxplayers" then
      if #command <= 14 then
        return
      end
      local maxNumberPlayers = math.abs(math.floor(tonumber(command:sub(15))))
      if type(maxNumberPlayers) ~= "number" then
        return
      end

      if maxNumberPlayers >= 6 and maxNumberPlayers <= 20 then
        tfm.exec.setRoomMaxPlayers(maxNumberPlayers)
        tfm.exec.chatMessage("<bv>"..playerLanguage[name].tr.messageSetMaxPlayers.." "..command:sub(15).." by admin "..name.."<n>", nil)
      else
        tfm.exec.chatMessage(playerLanguage[name].tr.messageMaxPlayersAlert, name)
      end
    elseif command:sub(1, 6) == "setmap" and mode == "startGame" then
      if gameStats.teamsMode then
        commandNotAvailable(command:sub(1, 6), name)
        return
      end

      if command:sub(8) == "small" or command:sub(8) == "large" or command:sub(8) == "extra-large" then
        if command:sub(8) == "small" or command:sub(8) == "large" then
          resetMapsToTest()
        end

        gameStats.setMapName = command:sub(8)
        tfm.exec.chatMessage("<bv>"..gameStats.setMapName.." map selected by admin "..name.."<n>", nil)
      else
        tfm.exec.chatMessage("<bv>Invalid map to select, valid options: small or large<n>", name)
      end
    elseif command:sub(1, 8) == "winscore" and mode == "gameStart" then
      if gameStats.teamsMode then
        commandNotAvailable(command:sub(1, 8), name)
        return
      end
      if #command <= 9 then
        return
      end

      if type(tonumber(command:sub(10))) ~= "number" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be a number<n>', name)
        return
      end

      local winscoreNumber = math.abs(math.floor(tonumber(command:sub(10))))
      if type(winscoreNumber) ~= "number" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be a number<n>', name)
        return
      end

      if winscoreNumber > score_red and winscoreNumber > score_blue and winscoreNumber > 0 then
        gameStats.winscore = math.abs(winscoreNumber)
        tfm.exec.chatMessage("<bv>Winscore changed to "..command:sub(10).."<n>", nil)
      end
    elseif command:sub(1,2) == "pw" then
      tfm.exec.setRoomPassword(command:sub(4))
      if command:sub(4) ~= "" then
        tfm.exec.chatMessage("<bv>"..playerLanguage[name].tr.newPassword.." "..command:sub(4).." by admin "..name.."<n>", nil)
      else
        tfm.exec.chatMessage(playerLanguage[name].tr.passwordRemoved, name)
      end
    elseif command:sub(1, 9) == "randommap" and mode == "startGame" and customMapCommand[name] then
      if gameStats.realMode then
        tfm.exec.chatMessage("<bv>The command !randomMap is not available on Volley Real Mode<n>", name)
        return
      end

      local args = split(command)
      
      if args[2] ~= "true" and args[2] ~= "false" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be true or false<n>', name)
        return
      end

      if args[2] == "false" then
        customMapCommand[name] = false

        customMapCommandDelay = addTimer(function(i)
          if i == 1 then
            customMapCommand[name] = true
          end
        end, 2500, 1, "customMapCommandDelay")

        gameStats.isCustomMap = false
        gameStats.customMapIndex = 0
        for name1, data in pairs(tfm.get.room.playerList) do
          if selectMapOpen[name1] then
            selectMapUI(name1)
          end
        end

        print("<bv>Random map has been disabled by the admin "..name.."<n>", nil)
        tfm.exec.chatMessage("<bv>Random map has been disabled by the admin "..name.."<n>", nil)
      end

      if args[2] == "true" then
        local indexMap = ''
        gameStats.isCustomMap = true
        tfm.exec.chatMessage("<bv>Random map has been enabled by the admin "..name.."<n>", nil)

        for name1, data in pairs(tfm.get.room.playerList) do
          if selectMapOpen[name1] then
            selectMapUI(name1)
          end
        end
                
        if gameStats.twoTeamsMode or gameStats.teamsMode then
          indexMap = math.random(1, #customMapsFourTeamsMode)
          gameStats.customMapIndex = indexMap
          tfm.exec.chatMessage('<bv>'..customMapsFourTeamsMode[gameStats.customMapIndex][3]..' map (created by '..customMapsFourTeamsMode[gameStats.customMapIndex][4]..') selected by admin '..name..'<n>', nil)
          print('<bv>'..customMapsFourTeamsMode[gameStats.customMapIndex][3]..' map (created by '..customMapsFourTeamsMode[gameStats.customMapIndex][4]..') selected randomly<n>')
          return
        end

        indexMap = math.random(1, #customMaps)
        gameStats.customMapIndex = indexMap
        print('<bv>'..customMaps[gameStats.customMapIndex][3]..' map (created by '..customMaps[gameStats.customMapIndex][4]..') selected randomly<n>', nil)
        tfm.exec.chatMessage('<bv>'..customMaps[gameStats.customMapIndex][3]..' map (created by '..customMaps[gameStats.customMapIndex][4]..') selected randomly<n>', nil)
        return
      end
  
      gameStats.isCustomMap = false
      gameStats.customMapIndex = 0
      
      for name1, data in pairs(tfm.get.room.playerList) do
        if selectMapOpen[name1] then
          selectMapUI(name1)
        end
      end

    elseif command:sub(1, 9) == "custommap" and mode == "startGame" and customMapCommand[name] then
      if gameStats.realMode then
        tfm.exec.chatMessage("<bv>The command !customMap is not available on Volley Real Mode<n>", name)
        return
      end
      local args = split(command)
      local indexMap = ""
      if #args >= 3 then
        if type(tonumber(args[3])) ~= "number" then
          tfm.exec.chatMessage('<bv>Third parameter invalid, must be a number<n>', name)
          return
        end
        indexMap = math.abs(math.floor(tonumber(args[3])))
      end

      if args[2] ~= "true" and args[2] ~= "false" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be true or false<n>', name)
        return
      end

      if args[2] == "false" then
        customMapCommand[name] = false

        customMapCommandDelay = addTimer(function(i)
          if i == 1 then
            customMapCommand[name] = true
          end
        end, 2500, 1, "customMapCommandDelay")

        gameStats.isCustomMap = false
        gameStats.customMapIndex = 0
        for name1, data in pairs(tfm.get.room.playerList) do
          if selectMapOpen[name1] then
            selectMapUI(name1)
          end
        end

        return
      end

      if type(indexMap) ~= "number" then
        tfm.exec.chatMessage('<bv>Third parameter invalid, must be a number<n>', name)
        return
      end

      if gameStats.twoTeamsMode or gameStats.teamsMode then
        if indexMap < 1 or indexMap > #customMapsFourTeamsMode then
          tfm.exec.chatMessage('<bv>Third parameter invalid, the map index must be higher than 1 and less than '..tostring(#customMapsFourTeamsMode)..'<n>', name)
          return
        end
      end

      if gameStats.threeTeamsMode then
        if indexMap < 1 or indexMap > #customMapsThreeTeamsMode then
          tfm.exec.chatMessage('<bv>Third parameter invalid, the map index must be higher than 1 and less than '..tostring(#customMapsThreeTeamsMode)..'<n>', name)
          return
        end
      end

      if not gameStats.twoTeamsMode and not gameStats.teamsMode then
        if indexMap < 1 or indexMap > #customMaps then
          tfm.exec.chatMessage('<bv>Third parameter invalid, the map index must be higher than 1 and less than '..tostring(#customMaps)..'<n>', name)
          return
        end
      end

      customMapCommand[name] = false

      customMapCommandDelay = addTimer(function(i)
        if i == 1 then
          customMapCommand[name] = true
        end
      end, 2000, 1, "customMapCommandDelay")

      if args[2] == "true" then
        gameStats.isCustomMap = true
        gameStats.customMapIndex = indexMap
        for name1, data in pairs(tfm.get.room.playerList) do
          if selectMapOpen[name1] then
            selectMapUI(name1)
          end
        end
        if gameStats.twoTeamsMode then
          tfm.exec.chatMessage('<bv>'..customMapsFourTeamsMode[gameStats.customMapIndex][3]..' map (created by '..customMapsFourTeamsMode[gameStats.customMapIndex][4]..') selected by admin '..name..'<n>', nil)
          print('<bv>'..customMapsFourTeamsMode[gameStats.customMapIndex][3]..' map (created by '..customMapsFourTeamsMode[gameStats.customMapIndex][4]..') selected by admin '..name..'<n>')
          return
        end

        if gameStats.threeTeamsMode then
          tfm.exec.chatMessage('<bv>'..customMapsThreeTeamsMode[gameStats.customMapIndex][3]..' map (created by '..customMapsThreeTeamsMode[gameStats.customMapIndex][4]..') selected by admin '..name..'<n>', nil)
          print('<bv>'..customMapsThreeTeamsMode[gameStats.customMapIndex][3]..' map (created by '..customMapsThreeTeamsMode[gameStats.customMapIndex][4]..') selected by admin '..name..'<n>')
          return
        end

        if gameStats.teamsMode then
          tfm.exec.chatMessage('<bv>'..customMapsFourTeamsMode[gameStats.customMapIndex][3]..' map (created by '..customMapsFourTeamsMode[gameStats.customMapIndex][4]..') selected by admin '..name..'<n>', nil)
          print('<bv>'..customMapsFourTeamsMode[gameStats.customMapIndex][3]..' map (created by '..customMapsFourTeamsMode[gameStats.customMapIndex][4]..') selected by admin '..name..'<n>')
          return
        end

        print('<bv>'..customMaps[gameStats.customMapIndex][3]..' map (created by '..customMaps[gameStats.customMapIndex][4]..') selected by admin '..name..'<n>', nil)
        tfm.exec.chatMessage('<bv>'..customMaps[gameStats.customMapIndex][3]..' map (created by '..customMaps[gameStats.customMapIndex][4]..') selected by admin '..name..'<n>', nil)
        return
      end

      gameStats.isCustomMap = false
      gameStats.customMapIndex = 0
      for name1, data in pairs(tfm.get.room.playerList) do
        if selectMapOpen[name1] then
          selectMapUI(name1)
        end
      end
    elseif command == "ballcoords" and name == "Refletz#6472" then
      print('X: '..tfm.get.room.objectList[ball_id].x..'')
      print('Y: '..tfm.get.room.objectList[ball_id].y..'')
    elseif command:sub(1, 8) == "setscore" and mode ~= "startGame" then
      local args = split(command)
      local isPlayerInTheRoom = false
      local scoreNumber = nil

      if #args >= 3 then
        if type(tonumber(args[3])) ~= "number" then
          tfm.exec.chatMessage("<bv>Third parameter invalid, must be a number<n>", name)

          return
        end

        scoreNumber = math.abs(math.floor(tonumber(args[3])))
      end

      if type(args[2]) ~= "string" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be a name player in the room or the value can be: red or blue<n>', name)
        return
      end

      if args[2] == "red" or args[2] == "blue" then
        if gameStats.teamsMode then
          commandNotAvailable(command:sub(1, 8), name)
          return
        end

        if type(scoreNumber) ~= "number" then
          tfm.exec.chatMessage("<bv>Third parameter invalid, must be a number and the number must be less than the actual winscore "..gameStats.winscore.."<n>", name)
          return
        end

        if scoreNumber >= gameStats.winscore then
          tfm.exec.chatMessage("<bv>Third parameter invalid, must be a number and the number must be less than the actual winscore "..gameStats.winscore.."<n>", name)
          return
        end

        if args[2] == "red" then
          score_red = scoreNumber
          tfm.exec.chatMessage("<r>Red score changed to "..score_red.." by admin "..name.."<n>", nil)
        end

        if args[2] == "blue" then
          score_blue = scoreNumber
          tfm.exec.chatMessage("<bv>Blue score changed to "..score_blue.." by admin "..name.."<n>", nil)
        end

        showTheScore()

        return
      end

      for name, data in pairs(tfm.get.room.playerList) do
        if string.lower(name) == args[2] then
          isPlayerInTheRoom = true
        end
      end

      if not isPlayerInTheRoom then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be a name player in the room<n>', name)
        return
      end

      if type(scoreNumber) == "number" then
        tfm.exec.setPlayerScore(args[2], scoreNumber, false)
        tfm.exec.chatMessage("<bv>the "..args[2].."'s score was changed to "..args[3].."<n>", name)
      else
        tfm.exec.setPlayerScore(args[2], 1, true)
        tfm.exec.chatMessage("<bv>added +1 to "..args[2].."'s score<n>", name)
      end
    elseif command:sub(1, 10) == "4teamsmode" and mode == "startGame" then
      if gameStats.twoTeamsMode then
        tfm.exec.chatMessage("<bv>You should disable the 2 teams mode first to enable the 4 teams mode<n>", nil)
        return
      end
      if gameStats.threeTeamsMode then
        tfm.exec.chatMessage("<bv>You should disable the 3 teams mode first to enable the 4 teams mode<n>", nil)
        return
      end
      if gameStats.realMode then
        tfm.exec.chatMessage("<bv>You should disable the real mode first to enable the 4 teams mode<n>", nil)
        return
      end
      local args = split(command)
      if args[2] ~= "true" and args[2] ~= "false" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be true or false<n>', name)
        return
      end

      gameStats.canJoin = false
      gameStats.isCustomMap = false
      gameStats.customMapIndex = 0
      getTeamsColorsName = {0xF59E0B, 0xEF4444, 0x3B82F6, 0x109267}
      teamsLifes = { [1] = {yellow = 3}, [2] = {red = 3}, [3] = {blue = 3}, [4] = {green = 3} }

      if args[2] == "true" then
        if gameStats.teamsMode then
          return
        end
        resetMapsToTest()
        gameStats.teamsMode = true
        resetMapsList()
        updateLobbyTextAreas()
        tfm.exec.chatMessage("<bv>4-team volley mode activated by admin "..name.."<n>", nil)
        return
      end

      if not gameStats.teamsMode then
        return
      end
      resetMapsToTest()

      gameStats.teamsMode = false
      resetMapsList()
      tfm.exec.chatMessage("<bv>4-team volley mode disabled by admin "..name.."<n>", nil)
      updateLobbyTextAreas()
    elseif command:sub(1, 10) == "3teamsmode" and mode == "startGame" then
      if gameStats.teamsMode then
        tfm.exec.chatMessage("<bv>You should disable the 4 teams mode first to enable the 3 teams mode<n>", nil)
        return
      end
      if gameStats.twoTeamsMode then
        tfm.exec.chatMessage("<bv>You should disable the 2 teams mode first to enable the 3 teams mode<n>", nil)
        return
      end
      if gameStats.realMode then
        tfm.exec.chatMessage("<bv>You should disable the real mode first to enable the 3 teams mode<n>", nil)
        return
      end
      local args = split(command)
      if args[2] ~= "true" and args[2] ~= "false" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be true or false<n>', name)
        return
      end

      gameStats.canJoin = false
      gameStats.isCustomMap = false
      gameStats.customMapIndex = 0
      getTeamsColorsName = {0xEF4444, 0x3B82F6, 0x109267}
      teamsLifes = { [1] = {yellow = 5}, [2] = {red = 5}, [3] = {blue = 5}, [4] = {green = 5} }

      if args[2] == "true" then
        if gameStats.threeTeamsMode then
          return
        end
        resetMapsToTest()
        gameStats.threeTeamsMode = true
        resetMapsList()
        tfm.exec.chatMessage("<bv>3-team volley mode activated by admin "..name.."<n>", nil)
        updateLobbyTextAreas()
        return
      end

      if not gameStats.threeTeamsMode then
        return
      end
      resetMapsToTest()

      gameStats.threeTeamsMode = false
      gameStats.threeBalls = false
      resetMapsList()
      tfm.exec.chatMessage("<bv>3-team volley mode disabled by admin "..name.."<n>", nil)
      updateLobbyTextAreas()
    elseif command:sub(1, 8) == "realmode" and mode == "startGame" then
      if gameStats.twoTeamsMode then
        tfm.exec.chatMessage("<bv>You should disable the real mode first to enable the 4 teams mode<n>", nil)
        return
      end

      if gameStats.threeTeamsMode then
        tfm.exec.chatMessage("<bv>You should disable the 3 teams mode first to enable the real mode<n>", nil)
        return
      end

      if gameStats.teamsMode then
        tfm.exec.chatMessage("<bv>You should disable the realmode mode first to enable the real mode<n>", nil)
        return
      end

      local args = split(command)
      if args[2] ~= "true" and args[2] ~= "false" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be true or false<n>', name)
        return
      end

      gameStats.isCustomMap = false
      gameStats.customMapIndex = 0

      if args[2] == "true" then
        gameStats.realMode = true
        resetMapsToTest()
        resetMapsList()
        tfm.exec.chatMessage("<bv>real volley mode activated by admin "..name.."<n>", nil)
        return
      end

      gameStats.realMode = false
      resetMapsList()
      resetMapsToTest()
      tfm.exec.chatMessage("<bv>real volley mode disabled by admin "..name.."<n>", nil)
    elseif command:sub(1, 5) == "admin" then
      local args = split(command)

      for name1, data in pairs(tfm.get.room.playerList) do
        if string.lower(name1) == args[2] then
          if admins[name1] then
            return
          end

          admins[name1] = true
          tfm.exec.chatMessage("<bv>Admin selected for "..name1.." command used by "..name.."<n>", nil)

          if mode == "startGame" then
            ui.addWindow(31, "<p align='center'><font size='13px'><a href='event:settings'>Room settings", name, 350, 370, 150, 30, 1, false, false, _)

            if selectMapOpen[name1] then
              selectMapUI(name1)
            end
          end
        end
      end
    elseif command:sub(1, 7) == "unadmin" then
      local args = split(command)
      local permanentAdmin = isPermanentAdmin(name)

      if args[2] == "all" and permanentAdmin then
        admins = {}
        for i = 1, #permanentAdmins do
          admins[permanentAdmins[i]] = true
        end
        tfm.exec.chatMessage("<bv>Admin list reseted by admin "..name.."<n>", nil)
        return
      end

      for i = 1, #permanentAdmins do
        local admin = string.lower(permanentAdmins[i])
        if args[2] == admin then
          return
        end
      end

      for name1, data in pairs(playerLanguage) do
        if string.lower(name1) == args[2] then
          if not admins[name1] then
            return
          end

          if name1 == getRoomAdmin and permanentAdmin then
            admins[name1] = false
            tfm.exec.chatMessage("<bv>Admin removed for "..name1.." command used by "..name.."<n>", nil)
          end
          admins[name1] = false
          tfm.exec.chatMessage("<bv>Admin removed for "..name1.." command used by "..name.."<n>", nil)

          if mode == "startGame" then
            closeWindow(31, name1)

            if selectMapOpen[name1] then
              selectMapUI(name1)
            end
          end
        end
      end
    elseif command:sub(1, 4) == "kick" then
      local args = split(command)
      local permanentAdmin = isPermanentAdmin(name)

      if not permanentAdmin then
        return
      end

      for i = 1, #permanentAdmins do
        local admin = string.lower(permanentAdmins[i])
        if args[2] == admin then
          return
        end
      end

      for name1, data in pairs(tfm.get.room.playerList) do
        if string.lower(name1) == args[2] then
          tfm.exec.kickPlayer(name1)
          tfm.exec.chatMessage("<bv>You have been kicked from the room by the admin "..name.."<n>", name1)
          tfm.exec.chatMessage("<bv>"..name.." kicked the player "..name1.." from the room<n>", nil)
          print("<bv>"..name.." kicked the player "..name1.." from the room<n>")
        end
      end
    elseif command:sub(1, 6) == "fleave" and mode == "gameStart" then
      local args = split(command)
      local permanentAdmin = isPermanentAdmin(name)

      if not permanentAdmin then
        return
      end

      for i = 1, #permanentAdmins do
        local admin = string.lower(permanentAdmins[i])
        if args[2] == admin then
          return
        end
      end

      for name1, data in pairs(tfm.get.room.playerList) do
        if string.lower(name1) == args[2] then
          if gameStats.teamsMode or gameStats.threeTeamsMode then
            if gameStats.canTransform then
                leaveTeamTeamsMode(name1)
                tfm.exec.chatMessage("<bv>Force leave used on "..name1.." command used by "..name.."<n>", nil)
                return
            end
          else
            if not gameStats.teamsMode then
              leaveTeam(name1)
              tfm.exec.chatMessage("<bv>Force leave used on "..name1.." command used by "..name.."<n>", nil)
              return
            end
            tfm.exec.chatMessage("<bv>The force leave command is disabled now, please try the same command in few seconds<n>", name)
            return
          end
        end
      end
    elseif command:sub(1, 3) == "ban" and gameStats.banCommandIsEnabled then
      local args = split(command)
      local permanentAdmin = isPermanentAdmin(name)

      if not permanentAdmin then
        return
      end

      for i = 1, #permanentAdmins do
        local admin = string.lower(permanentAdmins[i])
        if args[2] == admin then
          return
        end
      end

      for name1, data in pairs(tfm.get.room.playerList) do
        if args[2] == string.lower(name1) then
          if args[2] == string.lower(getRoomAdmin) and not permanentAdmin then
            return
          end
          playerBan[name1] = true
          tfm.exec.chatMessage("<bv>You have been banned from the room by the admin "..name.."<n>", name1)
          tfm.exec.chatMessage("<bv>"..name.." banned the player "..name1.." from the room<n>", nil)
          print("<bv>"..name.." banned the player "..name1.." from the room<n>")
          tfm.exec.kickPlayer(name1)
          playerBanHistory[name1] = name
          if mode == "startGame" then
            updateLobbyTexts(name1)
          elseif mode == "gameStart" then
            if gameStats.teamsMode and gameStats.canTransform then
              leaveTeamTeamsMode(name1)
              return
            else
              if not gameStats.teamsMode then
                leaveTeam(name1)
                return
              end
              tfm.exec.chatMessage("<bv>The force leave command is disabled now, please try the same command in few seconds<n>", name)
              return
            end
          end
        end
      end
    elseif command:sub(1, 5) == "unban" and gameStats.banCommandIsEnabled then
      local args = split(command)
      local permanentAdmin = isPermanentAdmin(name)

      if not permanentAdmin then
        return
      end

      for name1, data in pairs(playerLanguage) do
        if args[2] == string.lower(name1) then
          if args[2] == string.lower(getRoomAdmin) and not permanentAdmin then
            return
          end

          if not playerBan[name1] then
            return
          end

          playerBan[name1] = false
          tfm.exec.chatMessage("<bv>"..name.." unbanned the player "..name1.." from the room<n>", nil)
          print("<bv>"..name.." unbanned the player "..name1.." from the room<n>")
        end
      end
    elseif command:sub(1,10) == "randomball" and mode == "startGame" then
      local args = split(command)

      if args[2] ~= "true" and args[2] ~= "false" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be true or false<n>', name)
        return
      end
      
      if args[2] ~= "true" and args[2] ~= "false" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be true or false<n>', name)
        return
      end

      if args[2] == "true" then        
        print("<bv>Random ball has been enabled by the admin "..name.."<n>", nil)
        tfm.exec.chatMessage("<bv>Random ball has been enabled by the admin "..name.."<n>", nil)
        
        gameStats.customBall = true
        local indexBall= math.random(1, #balls)
        gameStats.customBallId = indexBall
        print("<bv>"..balls[gameStats.customBallId].name.." selected randomly<n>", nil)
        tfm.exec.chatMessage("<bv>"..balls[gameStats.customBallId].name.." selected randomly<n>", nil)
        return
      end

      gameStats.customBall = false
      print("<bv>Random ball has been disabled by the admin "..name.."<n>", nil)
      tfm.exec.chatMessage("<bv>Random ball has been disabled by the admin "..name.."<n>", nil)

    elseif command:sub(1, 10) == "customball" and mode == "startGame" then
      local args = split(command)

      if type(tonumber(args[2])) ~= "number" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be a number<n>', name)
        return
      end
      local indexBall = math.abs(math.floor(tonumber(args[2])))

      if type(indexBall) ~= "number" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be a number<n>', name)
        return
      elseif indexBall < 1 or indexBall > #balls then
        tfm.exec.chatMessage('<bv>Second parameter invalid, the ball index must be higher than 1 and less than '..tostring(#balls)..'<n>', name)
        return
      end

      gameStats.customBall = true
      gameStats.customBallId = indexBall

      tfm.exec.chatMessage("<bv>"..balls[gameStats.customBallId].name.." selected by admin "..name.."<n>", nil)
    elseif command:sub(1, 6) == "lobby" and mode == "gameStart" then
      ballOnGame = false
      ballOnGame2 = false
      ballOnGame3 = false
      ballOnGameTwoBalls = {ballOnGame, ballOnGame2, ballOnGame3}
      tfm.exec.removeObject(ball_id)
      mode = "endGame"
      gameTimeEnd = os.time() + 5000

      if gameStats.teamsMode then
        updateRankingFourTeamsMode()
      elseif gameStats.threeTeamsMode then
        updateRankingThreeTeamsMode()
      elseif gameStats.twoTeamsMode then
        updateRankingTwoTeamsMode()
      elseif gameStats.realMode then
        updateRankingRealMode()
      else
        updateRankingNormalMode()
      end

      tfm.exec.chatMessage("<bv>The command to reset lobby was actived by admin "..name..", the match will restart in 5 seconds<n>", nil)
    elseif command:sub(1, 8) == "killspec" then

      local findAdminPermanent = false

      for i = 1, #permanentAdmins do
        local admin = permanentAdmins[i]
        if name == admin then
          findAdminPermanent = true
        end
      end

      if findAdminPermanent then
        if mode == "startGame" then
          local boolean = command:sub(10)
          if boolean ~= "true" and boolean ~= "false" then
            tfm.exec.chatMessage('<bv>Second parameter invalid, must be true or false<n>', name)
            return
          end

          if boolean == "true" then
            killSpecPermanent = true
            return
          end

          killSpecPermanent = false

          return

        elseif mode == "gameStart" then
          local boolean = command:sub(10)
          if boolean ~= "true" and boolean ~= "false" then
            tfm.exec.chatMessage('<bv>Second parameter invalid, must be true or false<n>', name)
            return
          end

          if boolean == "true" then
            killSpecPermanent = true
            gameStats.killSpec = true
            for name1, data in pairs(tfm.get.room.playerList) do
              if playerInGame[name1] == false then
                tfm.exec.killPlayer(name1)
              end
            end
            return
          end

          killSpecPermanent = false
          gameStats.killSpec = false
        end
      end
    elseif command == "pause" and mode == "gameStart" then

      if gameStats.realMode then
        tfm.exec.chatMessage("<bv>The command !pause isn't available on Volley Real Mode<n>", name)

        return
      end

      local findAdminPermanent = false

      for i = 1, #permanentAdmins do
        local admin = permanentAdmins[i]
        if name == admin then
          findAdminPermanent = true
        end
      end

       if findAdminPermanent then
        if not gameStats.isGamePaused then
          gameStats.isGamePaused = true
          ballOnGame = false
          ballOnGame2 = false
          ballOnGame3 = false
          ballOnGameTwoBalls = {ballOnGame, ballOnGame2, ballOnGame3}

          tfm.exec.removeObject(ball_id)
          tfm.exec.removeObject(ball_id2)
          tfm.exec.removeObject(ball_id3)
          tfm.exec.chatMessage("<bv>Command !pause used by admin "..name.."<n>", nil)

          local timer = math.ceil((duration - os.time())/1000)

          durationTimerPause = timer
          return
        else
          duration = os.time() + durationTimerPause * 1000

          tfm.exec.setGameTime(durationTimerPause, true)

          gameStats.isGamePaused = false
          spawnInitialBall()
        end
      end
    elseif command:sub(1, 4) == "sync" then
      if #command == 4 then
        local lowestSync = 10000
        local newPlayerSync = ""
        for name, data in pairs(tfm.get.room.playerList) do
          local playerSync = tfm.get.room.playerList[name].averageLatency
          if playerSync < lowestSync then
            newPlayerSync = name
            lowestSync = playerSync
          end
        end

        tfm.exec.setPlayerSync(newPlayerSync)
        tfm.exec.chatMessage("<bv>Set new player sync: "..newPlayerSync.." selected by admin "..name.."<n>", nil)
      else
        local permanentAdmin = isPermanentAdmin(name)

        if not permanentAdmin then
          return
        end

        local playerName = command:sub(6)
        local playerOnRoom = false
        local playerSync = 0
        for name1, data in pairs(tfm.get.room.playerList) do
          if string.lower(name1) == playerName then
            playerOnRoom = true
            playerName = name1
            playerSync = tfm.get.room.playerList[name1].averageLatency
          end
        end

        if playerOnRoom then
          tfm.exec.setPlayerSync(playerName)
          tfm.exec.chatMessage("<bv>Set new player sync: "..playerName.." selected by admin "..name.."<n>", nil)
        end

      end

    elseif command == "setsync" then
      windowUISync(name)
    elseif command == "synctfm" then
      tfm.exec.setPlayerSync(nil)

      local playerSync = tfm.exec.getPlayerSync()
      local syncLatency = tfm.get.room.playerList[playerSync].averageLatency

      tfm.exec.chatMessage("<bv>Set new player sync: "..playerSync.."<n>", nil)
    elseif command == "listsync" then
      local permanentAdmin = isPermanentAdmin(name)
      local playersSync = {}

      if not permanentAdmin then
        return
      end

      local str = "Sync list: <br><br>"

      for name1, data in pairs(tfm.get.room.playerList) do
        local syncCondition = textSyncCondition(tfm.get.room.playerList[name1].averageLatency)
        playersSync[#playersSync + 1] = { name = name1, sync = tfm.get.room.playerList[name1].averageLatency, syncCondition = syncCondition }
      end

      table.sort(playersSync, function(a, b) return a.sync < b.sync end)

      for i = 1, #playersSync do
        str = ""..str..""..playersSync[i].name.." - "..playersSync[i].syncCondition.."<br>"
      end

      ui.addPopup(0, 0, str, name, 300, 50, 300, true)
    elseif command:sub(1, 14) == "setplayerforce" and mode == "startGame" then
      local numberForce = tonumber(command:sub(16))
      if type(numberForce) ~= "number" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be a number<n>', name)
        return
      elseif numberForce < 0 or numberForce > 1.05 then
        tfm.exec.chatMessage('<bv>The number to set the force is low or high than allowed, the value must be between (0 the minimum and 1.05 the maximum)<n>', name)
        return
      end

      gameStats.psyhicObjectForce = numberForce

      tfm.exec.chatMessage("<bv>The strength of the player's object has been changed to "..tostring(gameStats.psyhicObjectForce).."<n>", name)
      print("<bv>The strength of the player's object has been changed to "..tostring(gameStats.psyhicObjectForce).."<n>")
    elseif command == "test" and tfm.get.room.isTribeHouse and mode == "startGame" then
      if gameStats.threeTeamsMode then
        playersRed[1].name = "a"
        playersBlue[1].name = "a"
        playersGreen[1].name = "a"
      else
        playersRed[1].name = "a"
        playersRed[2].name = "a"
        playersBlue[1].name = "a"
        playersBlue[2].name = "a"
        playersGreen[1].name = "a"
        playersYellow[1].name = "a"
      end
      
      eventNewGameShowLobbyTexts()
    elseif command:sub(1, 10) == "2teamsmode" and mode == "startGame" then
      if gameStats.teamsMode then
        tfm.exec.chatMessage("<bv>You should disable the 4 teams mode first to enable the 2 teams mode<n>", nil)
        return
      end
      if gameStats.threeTeamsMode then
        tfm.exec.chatMessage("<bv>You should disable the 3 teams mode first to enable the 2 teams mode<n>", nil)
        return
      end
      if gameStats.realMode then
        tfm.exec.chatMessage("<bv>You should disable the real mode first to enable the 2 teams mode<n>", nil)
        return
      end
      local args = split(command)
      if args[2] ~= "true" and args[2] ~= "false" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be true or false<n>', name)
        return
      end

      gameStats.isCustomMap = false
      gameStats.customMapIndex = 0

      if args[2] == "true" then
        if gameStats.twoTeamsMode then
          return
        end
        resetMapsToTest()
        gameStats.twoTeamsMode = true
        resetMapsList()
        tfm.exec.chatMessage("<bv>2-team volley mode activated by admin "..name.."<n>", nil)
        return
      end

      if not gameStats.twoTeamsMode then
        return
      end

      resetMapsToTest()
      resetMapsList()
      gameStats.twoTeamsMode = false
      resetMapsList()
      tfm.exec.chatMessage("<bv>2-team volley mode disabled by admin "..name.."<n>", nil)
    elseif command:sub(1, 8) == "twoballs" and mode == "startGame" then
      local args = split(command)
      print(args[2])
      if gameStats.realMode then
        tfm.exec.chatMessage("<bv>The command two balls isn't available for Volley Real Mode<n>", name)

        return
      end
      if args[2] ~= "true" and args[2] ~= "false" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be true or false<n>', name)
        return
      end
      if args[2] == "true" then
        gameStats.twoBalls = true
        tfm.exec.chatMessage("<bv>Two balls has been enabled by the admin "..name.."<n>", nil)
        return
      end

      gameStats.twoBalls = false
      tfm.exec.chatMessage("<bv>Two balls has been disabled by the admin "..name.."<n>", nil)
    elseif command:sub(1, 10) == "threeballs" and mode == "startGame" then
      local args = split(command)
      print(args[2])
      if not gameStats.threeTeamsMode then
        tfm.exec.chatMessage("<bv>This command is only available for the 3-team mode.<n>", name)

        return
      end
      if args[2] ~= "true" and args[2] ~= "false" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be true or false<n>', name)
        return
      end
      if args[2] == "true" then
        print('ativou')
        gameStats.threeBalls = true
        tfm.exec.chatMessage("<bv>Two balls has been enabled by the admin "..name.."<n>", nil)
        return
      end

      gameStats.threeBalls = false
      tfm.exec.chatMessage("<bv>Two balls has been disabled by the admin "..name.."<n>", nil)
    elseif command:sub(1, 11) == "consumables" and mode == "startGame" then
      local args = split(command)

      if not gameStats.teamsMode and not gameStats.twoTeamsMode and not gameStats.realMode then
        tfm.exec.chatMessage("<bv>The command consumables only works on normal mode<n>", name)
      end

      if args[2] ~= "true" and args[2] ~= "false" then
        tfm.exec.chatMessage('<bv>Second parameter invalid, must be true or false<n>', name)
        return
      end

      if args[2] == "true" then
        gameStats.consumables = true
        tfm.exec.chatMessage("<bv>Consumables on normal mode has enabled by the admin "..name.."<n>", nil)
        return
      end

      gameStats.consumables = false
      tfm.exec.chatMessage("<bv>Consumables on normal mode has disabled by the admin "..name.."<n>", nil)
    elseif command == "settings" then 
      closeRankingUI(name)
      removeUITrophies(name)
      settings[name] = true
      
      updateSettingsUI(name)
    elseif command:sub(1, 2) == "np" and tfm.get.room.isTribeHouse and mode == "startGame" then
      local args = split(command)
      local regexMap = "^@%d%d%d%d%d%d%d$"

      if gameStats.realMode then
        tfm.exec.chatMessage("<bv>There aren't availables maps to test on volley real mode", name)
        return
      end

      if gameStats.setMapName == "extra-large" then
        tfm.exec.chatMessage("<bv>There aren't availables maps to test on extra-large map", name)
        return
      end

      if gameStats.threeTeamsMode then
        if type(args[2]) == "nil" then
          tfm.exec.chatMessage("<bv>Second parameter invalid, must be a tfm map like @3493212<n>", name)
          return
        end

        if string.match(args[2], regexMap) == nil then
          tfm.exec.chatMessage("<bv>Second parameter invalid, must be a tfm map like @3493212<n>", name)
          return
        end

        mapsToTest[1] = args[2]

        if type(args[3]) == "nil" then
          mapsToTest[2] = customMapsThreeTeamsMode[1][2]
          tfm.exec.chatMessage("<bv>Warning: in 4-team mode, the !np command should be !np @map @map @map, but if you only have one map ready and want to test it, the game will set the default map for the other maps<n>", name)
          print("<bv>Warning: in 4-team mode, the !np command should be !np @map @map @map, but if you only have one map ready and want to test it, the game will set the default map for the other maps<n>")
        else
          if string.match(args[3], regexMap) == nil then
            tfm.exec.chatMessage("<bv>Third parameter invalid, must be a tfm map like @3493212<n>", name)

            return
          else
            mapsToTest[2] = args[3]
          end
        end

        tfm.exec.chatMessage("<bv>Test map successfully selected<n>", nil)
        return
      end

      if gameStats.teamsMode then
        if type(args[2]) == "nil" then
          tfm.exec.chatMessage("<bv>Second parameter invalid, must be a tfm map like @3493212<n>", name)
          return
        end

        if string.match(args[2], regexMap) == nil then
          tfm.exec.chatMessage("<bv>Second parameter invalid, must be a tfm map like @3493212<n>", name)
          return
        end

        mapsToTest[1] = args[2]

        if type(args[3]) == "nil" then
          mapsToTest[2] = customMapsFourTeamsMode[34][2]
          tfm.exec.chatMessage("<bv>Warning: in 4-team mode, the !np command should be !np @map @map @map, but if you only have one map ready and want to test it, the game will set the default map for the other maps<n>", name)
          print("<bv>Warning: in 4-team mode, the !np command should be !np @map @map @map, but if you only have one map ready and want to test it, the game will set the default map for the other maps<n>")
        else
          if string.match(args[3], regexMap) == nil then
            tfm.exec.chatMessage("<bv>Third parameter invalid, must be a tfm map like @3493212<n>", name)

            return
          else
            mapsToTest[2] = args[3]
          end
        end

        if type(args[4]) == "nil" then
          mapsToTest[3] = customMapsFourTeamsMode[34][5]
          tfm.exec.chatMessage("<bv>Warning: in 4-team mode, the !np command should be !np @map @map @map, but if you only have one map ready and want to test it, the game will set the default map for the other maps<n>", name)
          print("<bv>Warning: in 4-team mode, the !np command should be !np @map @map @map, but if you only have one map ready and want to test it, the game will set the default map for the other maps<n>")
        else
          if string.match(args[4], regexMap) == nil then
            tfm.exec.chatMessage("<bv>Fourth parameter invalid, must be a tfm map like @3493212<n>", name)

            return
          else
            mapsToTest[3] = args[4]
          end
        end

        tfm.exec.chatMessage("<bv>Test map successfully selected<n>", nil)
        return
      end

      if type(args[2]) == "nil" then
        tfm.exec.chatMessage("<bv>Second parameter invalid, must be a tfm map like @3493212<n>", name)
        return
      end
      if string.match(args[2], regexMap) == nil then
        tfm.exec.chatMessage("<bv>Second parameter invalid, must be a tfm map like @3493212<n>", name)
        return
      end

      mapsToTest[1] = args[2]
      tfm.exec.chatMessage("<bv>Test map successfully selected<n>", nil)
    elseif command:sub(1,2) == "tp" and mode == gameStart then
      local permanentAdmin = isPermanentAdmin(name)
      if not permanentAdmin then
        return
      end

      local args = split(command)
      
      if #args >= 3 then
        local colorValues = {yellow = 200, blue = 400, red = 600, green = 1000}  
        if colorValues[args[2]] then
          args[2] = colorValues[args[2]]
        end

        if type(tonumber(args[2])) ~= "number" or type(tonumber(args[3])) ~= "number" then
          print('<bv>Second or third parameters invalid, must be numbers<n>', name)
          return
        end

        xTarget = math.abs(math.floor(tonumber(args[2])))
        yTarget = math.abs(math.floor(tonumber(args[3])))  
        tfm.exec.movePlayer(name, xTarget, yTarget)
      end
    end
  end
end