function realServe.chooseInitialTeam()
  local team = math.random(1, 2) == 1 and 'red' or 'blue'
  local roster = team == 'red' and gameState.teams.red or gameState.teams.blue
  gameState.match.real.aceRed, gameState.match.real.aceBlue = false, false
  gameState.match.real[team .. 'ServeIndex'] = math.random(0, #roster - 1)
  if realServe.choosePlayer(team) then return team end
  return nil
end
