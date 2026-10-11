function twoTeamsModeWinner(team)
  if team ~= 'red' and team ~= 'blue' then return end
  sessionRanking.recordVictory(sessionRanking.stats.two, team, team == 'red' and gameState.teams.red or gameState.teams.blue)
end
