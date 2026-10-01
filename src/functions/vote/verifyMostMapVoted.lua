function verifyMostMapVoted()
  local _, indices = availableMaps()
  local ties, highest = {}, -1
  for _, index in ipairs(indices) do
    local votes = mapsVotes[index] or 0
    if votes > highest then highest, ties = votes, {index}
    elseif votes == highest then ties[#ties+1] = index end
  end
  gameStats.mapIndexSelected = #ties > 0 and ties[math.random(1, #ties)] or 0
end
