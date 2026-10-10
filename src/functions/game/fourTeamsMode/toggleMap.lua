function toggleMap()
  removeTimer("deadTimer")
  gameStats.canTransform = false

  if not gameStats.minimalist then
    disablePlayersCanTransform(3500)
  end

  ballOnGame = false

  globalSettings.minimalistToggleMap = true

  if gameStats.typeMap == "large3v3" then
    ui.removeTextArea(8998991)

    if gameStats.teamsMode then
      if mapsToTest[2] ~= "" then
        configMap.mapSelected = mapsToTest[2]
        tfm.exec.newGame(mapsToTest[2])
        print(mapsToTest[2])
      else
        if gameStats.isCustomMap then
          configMap.mapSelected = customMapsFourTeamsMode[gameStats.customMapIndex][2]
          tfm.exec.newGame(customMapsFourTeamsMode[gameStats.customMapIndex][2])
        elseif gameStats.totalVotes >= 2 then
          configMap.mapSelected = customMapsFourTeamsMode[gameStats.mapIndexSelected][2]
          tfm.exec.newGame(customMapsFourTeamsMode[gameStats.mapIndexSelected][2])
        else
          configMap.mapSelected = customMapsFourTeamsMode[34][2]
          tfm.exec.newGame(customMapsFourTeamsMode[34][2])
        end
      end
    elseif gameStats.threeTeamsMode then
      if mapsToTest[2] ~= "" then
        configMap.mapSelected = mapsToTest[2]
        tfm.exec.newGame(mapsToTest[2])
      else
        if gameStats.isCustomMap then
          configMap.mapSelected = customMapsThreeTeamsMode[gameStats.customMapIndex][2]
          tfm.exec.newGame(customMapsThreeTeamsMode[gameStats.customMapIndex][2])
        elseif gameStats.totalVotes >= 2 then
          configMap.mapSelected = customMapsThreeTeamsMode[gameStats.mapIndexSelected][2]
          tfm.exec.newGame(customMapsThreeTeamsMode[gameStats.mapIndexSelected][2])
        else
          configMap.mapSelected = customMaps[6][2]
          tfm.exec.newGame(customMaps[6][2])
        end
      end
    end

    return
  elseif gameStats.typeMap == "small" then
    ui.removeTextArea(8998991)
    ui.removeTextArea(899899)
    if mapsToTest[3] ~= '' then
      configMap.mapSelected = mapsToTest[3]
      tfm.exec.newGame(mapsToTest[3])
    else
      if gameStats.isCustomMap then
        configMap.mapSelected = customMapsFourTeamsMode[gameStats.customMapIndex][5]
        tfm.exec.newGame(customMapsFourTeamsMode[gameStats.customMapIndex][5])
      elseif gameStats.totalVotes >= 2 then
        configMap.mapSelected = customMapsFourTeamsMode[gameStats.mapIndexSelected][5]
        tfm.exec.newGame(customMapsFourTeamsMode[gameStats.mapIndexSelected][5])
      else
        configMap.mapSelected = customMaps[6][1]
        tfm.exec.newGame(customMaps[6][1])
      end
    end
  end
end
