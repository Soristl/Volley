function spawnBallRealMode(team)
  if not gameStats.realMode or gameState.phase ~= 'gameStart' or (team ~= 'red' and team ~= 'blue') then return end
  if endRealMatchIfTeamEmpty() then return end
  local server=gameStats[team .. 'PlayerServe']
  if not server or not tfm.get.room.playerList[server] or playerLeft[server] or searchPlayerTeam(server) ~= team then
    if not choosePlayerServe(team) then return end
  end
  gameStats.redServe,gameStats.blueServe=team=='red',team=='blue'
  gameStats.reduceForce=true
  gameStats.teamWithOutAce=team=='red' and 'blue' or 'red'
  gameBalls.spawn(1,team=='red' and 700 or 1900,50)
  gameStats.canTransform=true
  showTheScore()
end
