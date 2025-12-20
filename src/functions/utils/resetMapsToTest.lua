function resetMapsToTest()
  if not tfm.get.room.isTribeHouse then
    return
  end
  
  if mapsToTest[1] ~= "" then
    tfm.exec.chatMessage("<bv>The test maps were removed due to the game mode change, you need to add the map again with the command !np @map<n>", nil)
  end
  
  mapsToTest = {
    [1] = "",
    [2] = "",
    [3] = ""
  }
end