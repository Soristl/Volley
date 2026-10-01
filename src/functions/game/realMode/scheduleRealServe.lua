function endRealMatchIfTeamEmpty()
  if not gameStats.realMode or gameState.phase ~= "gameStart" then return false end
  local counts={red=gameTeams.count(gameState.teams.red,true),blue=gameTeams.count(gameState.teams.blue,true)}
  if counts.red > 0 and counts.blue > 0 then return false end
  gameBalls.remove(1)
  gameStats.pendingServeTeam = nil
  gameStats.redServe, gameStats.blueServe = false, false
  beginEndGame()
  tfm.exec.chatMessage("<ce>[System]: a team is empty. Returning to the lobby without awarding a win.<n>", nil)
  return true
end

function scheduleRealServe(team)
  if not gameStats.realMode or gameState.phase ~= "gameStart" or (team ~= "red" and team ~= "blue") then return end
  if endRealMatchIfTeamEmpty() then return end
  removeTimer("delayTeleport")
  removeTimer("delaySpawnBall")
  removeTimer("delayToVerifyBall")
  gameStats.pendingServeTeam = team
  gameBalls.deactivate(1)
  gameStats.canTransform = false
  gameBalls.remove(1)
  addRoundTimer(function()
    if endRealMatchIfTeamEmpty() or gameStats.pendingServeTeam ~= team then return end
    if choosePlayerServe(team) then teamServe(team) end
  end, 4000, 1, "delayTeleport")
  addRoundTimer(function()
    if endRealMatchIfTeamEmpty() or gameStats.pendingServeTeam ~= team then return end
    spawnBallRealMode(team)
    gameStats.pendingServeTeam = nil
  end, 6000, 1, "delaySpawnBall")
end
