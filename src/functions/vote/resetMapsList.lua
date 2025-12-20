function resetMapsList()
  mapsVotes = {}
  gameStats.totalVotes = 0

  for name, data in pairs(tfm.get.room.playerList) do
    canVote[name] = true
    
    if selectMapOpen[name] then
      selectMapPage[name] = 1
      selectMapUI(name)
    end
  end
end