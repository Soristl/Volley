function getQuantityPlayers()
  if gameStats.typeMap == 'large4v4' then return quantityPlayers() end
  local counts={}
  for index,roster in ipairs(teamsPlayersOnGame) do counts[index]=gameTeams.count(roster) end
  return counts
end
