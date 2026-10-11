-- Validate team identity against its roster before awarding a victory.
function sessionRanking.recordThreeTeamWin(key, playersOnTeam)
  if not key or key ~= gameTeams.keyForRoster(playersOnTeam) or key == "yellow" then return end
  sessionRanking.recordVictory(sessionRanking.stats.three, key, playersOnTeam)
end
