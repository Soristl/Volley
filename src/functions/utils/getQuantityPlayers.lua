function gameTeams.layoutCounts()
  if gameState.match.court.typeMap == 'large4v4' then return gameTeams.countsByTeam() end
  local counts={}
  for index,roster in ipairs(gameState.teamLayout.remaining) do counts[index]=gameTeams.count(roster) end
  return counts
end
