-- Validate team identity against its roster before awarding a victory.
function fourTeamsModeWinner(key, playersOnTeam)
  if not key or key ~= gameTeams.keyForRoster(playersOnTeam) then return end
  recordMatchVictory(playersFourTeamsMode, key, playersOnTeam)
end
