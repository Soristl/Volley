function twoTeamsModeWinner(team)
  if team ~= 'red' and team ~= 'blue' then return end
  recordMatchVictory(playersTwoTeamsMode, team, team == 'red' and gameState.teams.red or gameState.teams.blue)
end
