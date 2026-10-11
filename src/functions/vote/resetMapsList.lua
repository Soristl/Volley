function resetMapsList()
  mapsVotes = {}
  gameStats.totalVotes = 0

  for name, data in pairs(tfm.get.room.playerList) do
    canVote[name] = true

    if uiState.selectMapOpen[name] then
      uiState.selectMapPage[name] = 1
      clubhouse.mapSelector(name)
    end
  end
end
