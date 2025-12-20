function toggleMap()
  gameStats.canTransform = false
  disablePlayersCanTransform(1500)
  ballOnGame = false

  if gameStats.typeMap == "large3v3" then
    ui.removeTextArea(8998991)

    if gameStats.teamsMode then
      if mapsToTest[2] ~= "" then
        tfm.exec.newGame(mapsToTest[2])
        local foundMap = addTimer(function(i)
          if i == 1 then
            foundBallSpawnsOnMap(mapsToTest[2], false)
            foundMiceSpawnsOnMap(mapsToTest[2], false)
          end
        end, 1000)
      else
        if gameStats.isCustomMap then
          tfm.exec.newGame(customMapsFourTeamsMode[gameStats.customMapIndex][2])
          foundBallSpawnsOnMap(customMapsFourTeamsMode[gameStats.customMapIndex][2], false)
          foundMiceSpawnsOnMap(customMapsFourTeamsMode[gameStats.customMapIndex][2], false)
        elseif gameStats.totalVotes >= 2 then
          tfm.exec.newGame(customMapsFourTeamsMode[gameStats.mapIndexSelected][2])
          foundBallSpawnsOnMap(customMapsFourTeamsMode[gameStats.mapIndexSelected][2], false)
          foundMiceSpawnsOnMap(customMapsFourTeamsMode[gameStats.mapIndexSelected][2], false)
        else
          tfm.exec.newGame(customMapsFourTeamsMode[34][2])
        end
      end
    elseif gameStats.threeTeamsMode then
      if mapsToTest[2] ~= "" then
        tfm.exec.newGame(mapsToTest[2])
        local foundMap = addTimer(function(i)
          if i == 1 then
            foundBallSpawnsOnMap(mapsToTest[2], false)
            foundMiceSpawnsOnMap(mapsToTest[2], false)
          end
        end, 1000)
      else
        if gameStats.isCustomMap then
          tfm.exec.newGame(customMapsThreeTeamsMode[gameStats.customMapIndex][2])
          foundBallSpawnsOnMap(customMapsThreeTeamsMode[gameStats.customMapIndex][2], false)
          foundMiceSpawnsOnMap(customMapsThreeTeamsMode[gameStats.customMapIndex][2], false)
        elseif gameStats.totalVotes >= 2 then
            tfm.exec.newGame(customMapsThreeTeamsMode[gameStats.mapIndexSelected][2])
            foundBallSpawnsOnMap(customMapsThreeTeamsMode[gameStats.mapIndexSelected][2], false)
            foundMiceSpawnsOnMap(customMapsThreeTeamsMode[gameStats.mapIndexSelected][2], false)
        else
          tfm.exec.newGame(customMaps[6][2])
        end
      end
    end
    
    teleportPlayersWithTypeMap(true)
    showTheScore()
    delaySpawnBall = addTimer(function(i)
      if i == 1 then
        spawnInitialBall()
      end
    end, 1500)
    
    tfm.exec.addPhysicObject (99999, 800, 460, {
      type = 15,
      width = 3000,
      height = 100,
      miceCollision = false,
      groundCollision = false
    })
    
    showCrownToAllPlayers()
    
    return
  elseif gameStats.typeMap == "small" then
    ui.removeTextArea(8998991)
    ui.removeTextArea(899899)
    if mapsToTest[3] ~= '' then
      tfm.exec.newGame(mapsToTest[3])
      local foundMap = addTimer(function(i)
        if i == 1 then
          foundBallSpawnsOnMap(mapsToTest[3], false)
          foundMiceSpawnsOnMap(mapsToTest[3], false)
        end
      end, 1000)
    else
      if gameStats.isCustomMap then
        tfm.exec.newGame(customMapsFourTeamsMode[gameStats.customMapIndex][5])
        foundBallSpawnsOnMap(customMapsFourTeamsMode[gameStats.customMapIndex][5], false)
        foundMiceSpawnsOnMap(customMapsFourTeamsMode[gameStats.customMapIndex][5], false)
      elseif gameStats.totalVotes >= 2 then
        tfm.exec.newGame(customMapsFourTeamsMode[gameStats.mapIndexSelected][5])
        foundBallSpawnsOnMap(customMapsFourTeamsMode[gameStats.mapIndexSelected][5], false)
        foundMiceSpawnsOnMap(customMapsFourTeamsMode[gameStats.mapIndexSelected][5], false)
      else
        tfm.exec.newGame(customMaps[6][1])
      end
    end
    
    showTheScore()
    
    if mapsToTest[2] ~= '' or mapsToTest[3] ~= '' then
      delaySpawnBall = addTimer(function(i)
        if i == 1 then
          spawnInitialBall()
          teleportPlayersWithTypeMap(false)
        end
      end, 1500)
    else
      spawnInitialBall()
      teleportPlayersWithTypeMap(false)
    end
    tfm.exec.addPhysicObject (99999, 800, 460, {
      type = 15,
      width = 3000,
      height = 100,
      miceCollision = false,
      groundCollision = false
    })
    
    showCrownToAllPlayers()
  end
end