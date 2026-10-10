function realModeWinner(team)
  if team ~= 'red' and team ~= 'blue' then return end
  recordMatchVictory(playersRealMode, team, team == 'red' and gameState.teams.red or gameState.teams.blue)
end
