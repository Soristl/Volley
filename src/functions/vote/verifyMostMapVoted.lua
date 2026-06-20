function verifyMostMapVoted()
  local mostMapVotedIndex = 1
  local mapsTie = {}

  local maps = configSelectMap()

  for i = 2, #maps do
    if mapsVotes[i] ~= nil then
      if mapsVotes[mostMapVotedIndex] ~= nil then
        if mapsVotes[i] > mapsVotes[mostMapVotedIndex] then
          mostMapVotedIndex = i
        end
      else
        mostMapVotedIndex = i
      end
    end
  end

  mapsTie[#mapsTie + 1] = mostMapVotedIndex

  for i = 1, #maps do
    if mapsVotes[i] ~= nil then
      if mapsVotes[i] == mapsVotes[mostMapVotedIndex] and i ~= mostMapVotedIndex then
        mapsTie[#mapsTie + 1] = i
      end
    end
  end

  if #mapsTie > 1 then
    mostMapVotedIndex = mapsTie[math.random(1, #mapsTie)]
  end

  gameStats.mapIndexSelected = mostMapVotedIndex
end
