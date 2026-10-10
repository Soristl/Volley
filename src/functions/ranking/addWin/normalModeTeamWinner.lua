function normalModeTeamWinner(team)
  if team ~= 'red' and team ~= 'blue' then return end
  recordMatchVictory(playersNormalMode, team, team == 'red' and gameState.teams.red or gameState.teams.blue)
end
