function chooseInitialPlayer()
  local team = math.random(1, 2) == 1 and 'red' or 'blue'
  local roster = team == 'red' and gameState.teams.red or gameState.teams.blue
  gameStats.aceRed, gameStats.aceBlue = false, false
  gameStats[team .. 'ServeIndex'] = math.random(0, #roster - 1)
  if choosePlayerServe(team) then return team end
  return nil
end
