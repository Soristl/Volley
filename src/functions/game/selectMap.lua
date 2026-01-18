function selectMap()
  local maps = {
    [1] = customMaps[6][1],
    [2] = customMaps[6][2],
    [3] = '<C><P L="1800" F="0" G="0,4" MEDATA="13,1;;;;-0;0:::1-"/><Z><S><S T="7" X="900" Y="400" L="1800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="901" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-10" Y="200" L="20" H="2000" P="0,0,0.2,0,0,0,0,0" o="FF0000" m=""/><S T="12" X="1810" Y="200" L="20" H="2000" P="0,0,0.2,0,0,0,0,0" o="FF0000" m=""/><S T="13" X="300" Y="359" L="10" P="0,0,0,0,0,0,0,0" o="324650" c="4"/><S T="13" X="1500" Y="359" L="10" P="0,0,0,0,0,0,0,0" o="324650" c="4"/><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="1" X="900" Y="-5" L="1800" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="12" X="900" Y="95" L="1800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFF200" c="3" m=""/><S T="12" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" o="FFF200" c="3" m=""/><S T="12" X="1495" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" o="FFF200" c="3" m=""/><S T="12" X="900" Y="225" L="1800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFF200" c="3" m=""/><S T="12" X="900" Y="240" L="10" H="40" P="0,0,0,0,0,0,0,0" o="FFF200" c="3" m=""/><S T="12" X="900" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" o="FF0000" m=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="900" Y="460" L="2600" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1550" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="900" Y="-800" L="1840" H="20" P="0,0,0,0.2,0,0,0,0" o="FF0000" m=""/><S T="12" X="900" Y="1190" L="1840" H="20" P="0,0,0,0.2,0,0,0,0" o="FF0000" m=""/></S><D><P X="1499" Y="365" T="10" P="1,0"/><P X="299" Y="365" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>'
  }

  if gameStats.realMode then
    tfm.exec.newGame('<C><P L="2600" F="0" G="0,4" MEDATA=";0,1;;;-0;0:::1-"/><Z><S><S T="7" X="1300" Y="400" L="2600" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N=""/><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0"/><S T="1" X="1300" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0"/><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495"/><S T="12" X="-10" Y="200" L="20" H="2000" P="0,0,0.2,0,0,0,0,0" o="FF0000" m=""/><S T="12" X="2610" Y="200" L="20" H="2000" P="0,0,0.2,0,0,0,0,0" o="FF0000" m=""/><S T="13" X="700" Y="359" L="10" P="0,0,0,0,0,0,0,0" o="324650" c="4"/><S T="13" X="1900" Y="359" L="10" P="0,0,0,0,0,0,0,0" o="324650" c="4"/><S T="1" X="1300" Y="-5" L="2600" H="10" P="0,0,0,0.2,0,0,0,0" c="3"/><S T="12" X="1300" Y="95" L="2600" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFF200" c="3" m=""/><S T="12" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" o="FFF200" c="3" m=""/><S T="12" X="2295" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" o="FFF200" c="3" m=""/><S T="12" X="1200" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1300" Y="225" L="2600" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFF200" c="3" m=""/><S T="12" X="1300" Y="240" L="10" H="40" P="0,0,0,0,0,0,0,0" o="FFF200" c="3" m=""/><S T="12" X="1300" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" o="FF0000" N="" m=""/><S T="12" X="600" Y="770" L="10" H="840" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" N=""/><S T="12" X="2000" Y="770" L="10" H="840" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" N=""/><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3"/><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3"/><S T="12" X="1300" Y="460" L="3400" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N=""/><S T="12" X="1400" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4"/><S T="12" X="1300" Y="-800" L="2640" H="20" P="0,0,0,0.2,0,0,0,0" o="FF0000" m=""/><S T="12" X="1300" Y="1190" L="2640" H="20" P="0,0,0,0.2,0,0,0,0" o="FF0000" m=""/><S T="12" X="600" Y="355" L="10" H="10" P="0,0,20,0.2,45,0,0,0" o="FFFFFF" c="2"/><S T="12" X="2000" Y="355" L="10" H="10" P="0,0,20,0.2,45,0,0,0" o="FFFFFF" c="2"/></S><D><P X="1900" Y="365" T="10" P="1,0"/><P X="700" Y="365" T="10" P="1,0"/><DS X="365" Y="-141"/></D><O/><L/></Z></C>')
    return
  end

  if gameStats.threeTeamsMode then
    if mapsToTest[1] ~= "" then
      tfm.exec.newGame(mapsToTest[1])
      local foundMap = addTimer(function(i)
        if i == 1 then
          foundBallSpawnsOnMap(mapsToTest[1], false)
          foundMiceSpawnsOnMap(mapsToTest[1], false)
        end
      end, 1000)

      return
    end
    
    if gameStats.isCustomMap then
      tfm.exec.newGame(customMapsThreeTeamsMode[gameStats.customMapIndex][1])
      local foundMap = addTimer(function(i)
        if i == 1 then
          foundBallSpawnsOnMap(customMapsThreeTeamsMode[gameStats.customMapIndex][1], false)
          foundMiceSpawnsOnMap(customMapsThreeTeamsMode[gameStats.customMapIndex][1], false)
        end
      end, 1000)
      
      return
    end

    if gameStats.totalVotes == 1 then
      tfm.exec.chatMessage('<bv>It is necessary that at least 2 players have used the !votemap command for a map to be selected<n>', nil)
    end
    if gameStats.totalVotes >= 2 then
      tfm.exec.newGame(customMapsThreeTeamsMode[gameStats.mapIndexSelected][1])
      local foundMap = addTimer(function(i)
        if i == 1 then
          foundBallSpawnsOnMap(customMapsThreeTeamsMode[gameStats.mapIndexSelected][1], false)
          foundMiceSpawnsOnMap(customMapsThreeTeamsMode[gameStats.mapIndexSelected][1], false)
        end
      end, 1000)
      tfm.exec.chatMessage("<bv>The "..customMapsThreeTeamsMode[gameStats.mapIndexSelected][3].." map (created by "..customMapsThreeTeamsMode[gameStats.mapIndexSelected][4]..") was selected ("..tostring(mapsVotes[gameStats.mapIndexSelected]).." votes)<n>", nil)
      print("<bv>The "..customMapsThreeTeamsMode[gameStats.mapIndexSelected][3].." map (created by "..customMapsThreeTeamsMode[gameStats.mapIndexSelected][4]..") was selected ("..tostring(mapsVotes[gameStats.mapIndexSelected]).." votes)<n>")

      return
    end

    tfm.exec.newGame(customMapsThreeTeamsMode[1][1])

    return
  end

  if gameStats.teamsMode then
    if mapsToTest[1] ~= "" then
      tfm.exec.newGame(mapsToTest[1])
      local foundMap = addTimer(function(i)
        if i == 1 then
          foundBallSpawnsOnMap(mapsToTest[1], false)
          foundMiceSpawnsOnMap(mapsToTest[1], false)
        end
      end, 1000)

      return
    end
    if gameStats.isCustomMap then
      tfm.exec.newGame(customMapsFourTeamsMode[gameStats.customMapIndex][1])
      local foundMap = addTimer(function(i)
        if i == 1 then
          foundBallSpawnsOnMap(customMapsFourTeamsMode[gameStats.customMapIndex][1], false)
          foundMiceSpawnsOnMap(customMapsFourTeamsMode[gameStats.customMapIndex][1], false)
        end
      end, 1000)

      return
    end
    if gameStats.totalVotes == 1 then
      tfm.exec.chatMessage('<bv>It is necessary that at least 2 players have used the !votemap command for a map to be selected<n>', nil)
    end
    if gameStats.totalVotes >= 2 then
      tfm.exec.newGame(customMapsFourTeamsMode[gameStats.mapIndexSelected][1])
      local foundMap = addTimer(function(i)
        if i == 1 then
          foundBallSpawnsOnMap(customMapsFourTeamsMode[gameStats.mapIndexSelected][1], false)
          foundMiceSpawnsOnMap(customMapsFourTeamsMode[gameStats.mapIndexSelected][1], false)
        end
      end, 1000)
      
      tfm.exec.chatMessage("<bv>The "..customMapsFourTeamsMode[gameStats.mapIndexSelected][3].." map (created by "..customMapsFourTeamsMode[gameStats.mapIndexSelected][4]..") was selected ("..tostring(mapsVotes[gameStats.mapIndexSelected]).." votes)<n>", nil)
      print("<bv>The "..customMapsFourTeamsMode[gameStats.mapIndexSelected][3].." map (created by "..customMapsFourTeamsMode[gameStats.mapIndexSelected][4]..") was selected ("..tostring(mapsVotes[gameStats.mapIndexSelected]).." votes)<n>")

      return
    end
    tfm.exec.newGame(customMapsFourTeamsMode[34][1])
    return
  end

  if gameStats.twoTeamsMode then
    if mapsToTest[1] ~= "" then
      tfm.exec.newGame(mapsToTest[1])
      local foundMap = addTimer(function(i)
        if i == 1 then
          foundBallSpawnsOnMap(mapsToTest[1], false)
          foundMiceSpawnsOnMap(mapsToTest[1], false)
        end
      end, 1000)

      return
    end
    if gameStats.isCustomMap then
      tfm.exec.newGame(customMapsFourTeamsMode[gameStats.customMapIndex][1])
      local foundMap = addTimer(function(i)
        if i == 1 then
          foundBallSpawnsOnMap(customMapsFourTeamsMode[gameStats.customMapIndex][1], false)
          foundMiceSpawnsOnMap(customMapsFourTeamsMode[gameStats.customMapIndex][1], false)
        end
      end, 1000)
      
      return
    end
    if gameStats.totalVotes == 1 then
      tfm.exec.chatMessage('<bv>It is necessary that at least 2 players have used the !votemap command for a map to be selected<n>', nil)
    end
    if gameStats.totalVotes >= 2 then
      tfm.exec.newGame(customMapsFourTeamsMode[gameStats.mapIndexSelected][1])
      local foundMap = addTimer(function(i)
        if i == 1 then
          foundBallSpawnsOnMap(customMapsFourTeamsMode[gameStats.mapIndexSelected][1], false)
          foundMiceSpawnsOnMap(customMapsFourTeamsMode[gameStats.mapIndexSelected][1], false)
        end
      end, 1000)
      
      tfm.exec.chatMessage("<bv>The "..customMapsFourTeamsMode[gameStats.mapIndexSelected][3].." map (created by "..customMapsFourTeamsMode[gameStats.mapIndexSelected][4]..") was selected ("..tostring(mapsVotes[gameStats.mapIndexSelected]).." votes)<n>", nil)
      print("<bv>The "..customMapsFourTeamsMode[gameStats.mapIndexSelected][3].." map (created by "..customMapsFourTeamsMode[gameStats.mapIndexSelected][4]..") was selected ("..tostring(mapsVotes[gameStats.mapIndexSelected]).." votes)<n>")

      return
    end
    tfm.exec.newGame(customMapsFourTeamsMode[34][1])
    return
  end

  if gameStats.setMapName == "" then
    if gameStats.gameMode == "3v3" then
      if mapsToTest[1] ~= "" then
        tfm.exec.newGame(mapsToTest[1])
        local foundMap = addTimer(function(i)
          if i == 1 then
            foundBallSpawnsOnMap(mapsToTest[1], false)
            foundMiceSpawnsOnMap(mapsToTest[1], false)
          end
        end, 1000)

        return
      end
      if gameStats.isCustomMap then
        tfm.exec.newGame(customMaps[gameStats.customMapIndex][1])
        local foundMap = addTimer(function(i)
          if i == 1 then
            foundBallSpawnsOnMap(customMaps[gameStats.customMapIndex][1], false)
            foundMiceSpawnsOnMap(customMaps[gameStats.customMapIndex][1], false)
          end
        end, 1000)
      else
        if gameStats.totalVotes == 1 then
          tfm.exec.chatMessage('<bv>It is necessary that at least 2 players have used the !votemap command for a map to be selected<n>', nil)
        end
        if gameStats.totalVotes >= 2 then
          tfm.exec.newGame(customMaps[gameStats.mapIndexSelected][1])
          local foundMap = addTimer(function(i)
            if i == 1 then
              foundBallSpawnsOnMap(customMaps[gameStats.mapIndexSelected][1], false)
              foundMiceSpawnsOnMap(customMaps[gameStats.mapIndexSelected][1], false)
            end
          end, 1000)
          
          tfm.exec.chatMessage("<bv>The "..customMaps[gameStats.mapIndexSelected][3].." map (created by "..customMaps[gameStats.mapIndexSelected][4]..") was selected ("..tostring(mapsVotes[gameStats.mapIndexSelected]).." votes)<n>", nil)
          print("<bv>The "..customMaps[gameStats.mapIndexSelected][3].." map (created by "..customMaps[gameStats.mapIndexSelected][4]..") was selected ("..tostring(mapsVotes[gameStats.mapIndexSelected]).." votes)<n>")
        else
          tfm.exec.newGame(maps[1])
        end

      end

    else
      if mapsToTest[1] ~= "" then
        tfm.exec.newGame(mapsToTest[1])
        local foundMap = addTimer(function(i)
          if i == 1 then
            foundBallSpawnsOnMap(mapsToTest[1], true)
            foundMiceSpawnsOnMap(mapsToTest[1], true)
          end
        end, 1000)

        return
      end
      if gameStats.isCustomMap then
        tfm.exec.newGame(customMaps[gameStats.customMapIndex][2])
        local foundMap = addTimer(function(i)
          if i == 1 then
            foundBallSpawnsOnMap(customMaps[gameStats.customMapIndex][2], true)
            foundMiceSpawnsOnMap(customMaps[gameStats.customMapIndex][2], true)
          end
        end, 1000)
      else
        if gameStats.totalVotes == 1 then
          tfm.exec.chatMessage('<bv>It is necessary that at least 2 players have used the !votemap command for a map to be selected<n>', nil)
        end
        if gameStats.totalVotes >= 2 then
          tfm.exec.newGame(customMaps[gameStats.mapIndexSelected][2])
          local foundMap = addTimer(function(i)
            if i == 1 then
              foundBallSpawnsOnMap(customMaps[gameStats.mapIndexSelected][2], true)
              foundMiceSpawnsOnMap(customMaps[gameStats.mapIndexSelected][2], true)
            end
          end, 1000)
          
          tfm.exec.chatMessage("<bv>The "..customMaps[gameStats.mapIndexSelected][3].." map (created by "..customMaps[gameStats.mapIndexSelected][4]..") was selected ("..tostring(mapsVotes[gameStats.mapIndexSelected]).." votes)<n>", nil)
        else
          tfm.exec.newGame(maps[2])
        end
      end
    end
  else
    if gameStats.setMapName == "small" then
      gameStats.gameMode = "3v3"
      gameStats.redX = 399
      gameStats.blueX = 401
      if mapsToTest[1] ~= "" then
        tfm.exec.newGame(mapsToTest[1])
        local foundMap = addTimer(function(i)
          if i == 1 then
            foundBallSpawnsOnMap(mapsToTest[1], false)
            foundMiceSpawnsOnMap(mapsToTest[1], false)
          end
        end, 1000)

        return
      end
      if gameStats.isCustomMap then
        tfm.exec.newGame(customMaps[gameStats.customMapIndex][1])
        local foundMap = addTimer(function(i)
          if i == 1 then
            foundBallSpawnsOnMap(customMaps[gameStats.customMapIndex][1], false)
            foundMiceSpawnsOnMap(customMaps[gameStats.customMapIndex][1], false)
          end
        end, 1000)
      else
        if gameStats.totalVotes == 1 then
          tfm.exec.chatMessage('<bv>It is necessary that at least 2 players have used the !votemap command for a map to be selected<n>', nil)
        end
        if gameStats.totalVotes >= 2 then
          tfm.exec.newGame(customMaps[gameStats.mapIndexSelected][1])
          local foundMap = addTimer(function(i)
            if i == 1 then
              foundBallSpawnsOnMap(customMaps[gameStats.mapIndexSelected][1], false)
              foundMiceSpawnsOnMap(customMaps[gameStats.mapIndexSelected][1], false)
            end
          end, 1000)
          tfm.exec.chatMessage("<bv>The "..customMaps[gameStats.mapIndexSelected][3].." map (created by "..customMaps[gameStats.mapIndexSelected][4]..") was selected ("..tostring(mapsVotes[gameStats.mapIndexSelected]).." votes)<n>", nil)
        else
          tfm.exec.newGame(maps[1])
        end
      end
    elseif gameStats.setMapName == "large" then
      gameStats.gameMode = "4v4"
      gameStats.redX = 599
      gameStats.blueX = 601
      if mapsToTest[1] ~= "" then
        tfm.exec.newGame(mapsToTest[1])
        local foundMap = addTimer(function(i)
          if i == 1 then
            foundBallSpawnsOnMap(mapsToTest[1], true)
            foundMiceSpawnsOnMap(mapsToTest[1], true)
          end
        end, 1000)
        return
      end
      
      if gameStats.isCustomMap then
        tfm.exec.newGame(customMaps[gameStats.customMapIndex][2])
        local foundMap = addTimer(function(i)
          if i == 1 then
            foundBallSpawnsOnMap(customMaps[gameStats.customMapIndex][2], true)
            foundMiceSpawnsOnMap(customMaps[gameStats.customMapIndex][2], true)
          end
        end, 1000)
      else
        if gameStats.totalVotes == 1 then
          tfm.exec.chatMessage('<bv>It is necessary that at least 2 players have used the !votemap command for a map to be selected<n>', nil)
        end
        if gameStats.totalVotes >= 2 then
          tfm.exec.newGame(customMaps[gameStats.mapIndexSelected][2])
          local foundMap = addTimer(function(i)
            if i == 1 then
              foundBallSpawnsOnMap(customMaps[gameStats.mapIndexSelected][2], true)
              foundMiceSpawnsOnMap(customMaps[gameStats.mapIndexSelected][2], true)
            end
          end, 1000)
          tfm.exec.chatMessage("<bv>The "..customMaps[gameStats.mapIndexSelected][3].." map (created by "..customMaps[gameStats.mapIndexSelected][4]..") was selected ("..tostring(mapsVotes[gameStats.mapIndexSelected]).." votes)<n>", nil)
        else
          tfm.exec.newGame(maps[2])
        end
      end
    elseif gameStats.setMapName == "extra-large" then
      gameStats.gameMode = "6v6"
      gameStats.redX = 899
      gameStats.blueX = 901

      tfm.exec.newGame(maps[3])
    end
  end
end