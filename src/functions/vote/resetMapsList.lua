function mapVoting.resetMapList()
  gameState.voting.counts = {}
  gameState.match.maps.totalVotes = 0

  for name, data in pairs(tfm.get.room.playerList) do
    gameState.voting.eligible[name] = true

    if uiState.selectMapOpen[name] then
      uiState.selectMapPage[name] = 1
      clubhouse.mapSelector(name)
    end
  end
end
