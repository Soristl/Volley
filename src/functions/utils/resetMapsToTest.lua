-- Test-map overrides stay private. Lobby and mode changes retain their original reset points.
do
  local testMaps

  function gameMaps.clearTestMaps()
    testMaps = {
      [1] = "",
      [2] = "",
      [3] = ""
    }
  end

  function gameMaps.setTestMap(index, value)
    testMaps[index] = value
  end

  function gameMaps.testMapOverride(index)
    return testMaps[index]
  end

  function gameMaps.announceTestMaps()
    for i = 1, #testMaps do tfm.exec.chatMessage(testMaps[i]..'\n', nil) end
  end

  function gameMaps.resetTestMaps()
    if not tfm.get.room.isTribeHouse then
      return
    end

    if testMaps[1] ~= "" then
      tfm.exec.chatMessage(
        "<bv>The test maps were removed due to the game mode change, you need to add the map again with the command !np @map<n>",
        nil)
    end

    gameMaps.clearTestMaps()
  end
end
