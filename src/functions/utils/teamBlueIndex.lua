function gameTeams.blueSeatIndex(index)
  if gameState.match.mode.threeTeamsMode then
    return index
  end

  return index - 3
end
