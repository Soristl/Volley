function eventNewGame()
  if mode == "gameStart" then
    if globalSettings.minimalist and globalSettings.minimalistToggleMap then
      globalSettings.minimalistToggleMap = false

      tfm.exec.chatMessage("<ch>Minimalist mode is enabled, reloading the map to complete the settings.<n>", nil)

      addTimer(function(i) 
        tfm.exec.newGame(tfm.get.room.xmlMapInfo.xml)

        tfm.exec.addPhysicObject (99999, 800, webY, 
        {
          type = 15,
          width = 3000,
          height = 100,
          miceCollision = false,
          groundCollision = false   
        })
      end, 3000, 1)
    end
    showTheScore()
    if gameStats.teamsMode or gameStats.twoTeamsMode then
      if gameStats.isCustomMap then
        ui.setMapName("<j>"..customMapsFourTeamsMode[gameStats.customMapIndex][4].."<n>")

        return
      end

      if gameStats.totalVotes >= 2 then
        ui.setMapName("<j>"..customMapsFourTeamsMode[gameStats.mapIndexSelected][4].."<n>")

        return
      end

      ui.setMapName("<j>Refletz#6472<n>")

      return
    end

    if gameStats.threeTeamsMode then
      if gameStats.isCustomMap then
        ui.setMapName("<j>"..customMapsThreeTeamsMode[gameStats.customMapIndex][4].."<n>")

        return
      end

      if gameStats.totalVotes >= 2 then
        ui.setMapName("<j>"..customMapsThreeTeamsMode[gameStats.mapIndexSelected][4].."<n>")

        return
      end

      ui.setMapName("<j>Refletz#6472<n>")

      return
    end

    if gameStats.isCustomMap then
      ui.setMapName("<j>"..customMaps[gameStats.customMapIndex][4].."<n>")

      return
    end

    if gameStats.totalVotes >= 2 then
      ui.setMapName("<j>"..customMaps[gameStats.mapIndexSelected][4].."<n>")

      return
    end

    ui.setMapName("<j>Refletz#6472<n>")
  end
end