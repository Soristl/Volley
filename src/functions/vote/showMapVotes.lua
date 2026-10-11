function mapVoting.showVotes(maps, index)
  if gameState.voting.counts[index] == nil then
    return 0
  end

  return gameState.voting.counts[index]
end
