function normalModeTeamWinner(team)
  if team ~= 'red' and team ~= 'blue' then return end
  sessionRanking.recordVictory(sessionRanking.stats.normal, team, team == 'red' and gameState.teams.red or gameState.teams.blue)
end
