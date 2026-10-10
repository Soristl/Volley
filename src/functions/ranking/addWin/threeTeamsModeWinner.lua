-- Validate team identity against its roster before awarding a victory.
function threeTeamsModeWinner(key, playersOnTeam)
  if not key or key ~= gameTeams.keyForRoster(playersOnTeam) or key == "yellow" then return end
  recordMatchVictory(playersThreeTeamsMode, key, playersOnTeam)
end
