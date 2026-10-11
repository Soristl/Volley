function realServe.spawnBall(team)
  if not gameState.match.mode.realMode or gameState.phase ~= 'gameStart' or (team ~= 'red' and team ~= 'blue') then return end
  if realServe.endIfTeamEmpty() then return end
  local server=gameState.match.real[team .. 'PlayerServe']
  if not server or not tfm.get.room.playerList[server] or playerState.left[server] or gameTeams.findRealMember(server) ~= team then
    if not realServe.choosePlayer(team) then return end
  end
  gameState.match.real.redServe,gameState.match.real.blueServe=team=='red',team=='blue'
  gameState.match.real.reduceForce=true
  gameState.match.real.teamWithOutAce=team=='red' and 'blue' or 'red'
  gameBalls.spawn(1,team=='red' and 700 or 1900,50)
  gameState.match.round.canTransform=true
  clubhouse.showScores()
end
