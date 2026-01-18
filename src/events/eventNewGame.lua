function eventNewGame()
  if mode == "gameStart" then
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