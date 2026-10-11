function gameTeams.releaseSpawn(name, additional)
  if not name or name == '' then return 0 end
  local removed = 0
  local groups = {gameState.court.playerSpawns[1], gameState.court.playerSpawns[2], gameState.court.playerSpawns[3], gameState.court.playerSpawns[4]}
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
