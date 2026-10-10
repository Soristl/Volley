function removePlayerOnSpawnConfig(name, additional)
  if not name or name == '' then return 0 end
  local removed = 0
  local groups = {playersSpawn400, playersSpawn800, playersSpawn1200, playersSpawn1600}
  if additional then groups[#groups+1] = additional end
  for _, markers in ipairs(groups) do
    for _, marker in ipairs(markers) do
      -- Descending removal handles adjacent duplicates without skipping any.
      for index=#marker.players,1,-1 do
        if marker.players[index] == name then
          table.remove(marker.players, index)
          removed = removed + 1
        end
      end
    end
  end
  return removed
end
