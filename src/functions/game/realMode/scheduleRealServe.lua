function realServe.endIfTeamEmpty()
  if not gameState.match.mode.realMode or gameState.phase ~= "gameStart" then return false end
  local counts={red=gameTeams.count(gameState.teams.red,true),blue=gameTeams.count(gameState.teams.blue,true)}
  if counts.red > 0 and counts.blue > 0 then return false end
  gameBalls.remove(1)
  gameState.match.real.pendingServeTeam = nil
  gameState.match.real.redServe, gameState.match.real.blueServe = false, false
  matchLifecycle.finishMatch()
  tfm.exec.chatMessage("<ce>[System]: a team is empty. Returning to the lobby without awarding a win.<n>", nil)
  return true
end

function realServe.schedule(team)
  if not gameState.match.mode.realMode or gameState.phase ~= "gameStart" or (team ~= "red" and team ~= "blue") then return end
  if realServe.endIfTeamEmpty() then return end
  timers.remove("delayTeleport")
  timers.remove("delaySpawnBall")
  timers.remove("delayToVerifyBall")
  gameState.match.real.pendingServeTeam = team
  gameBalls.deactivate(1)
  gameState.match.round.canTransform = false
  gameBalls.remove(1)
  timers.addRound(function()
    if realServe.endIfTeamEmpty() or gameState.match.real.pendingServeTeam ~= team then return end
    if realServe.choosePlayer(team) then realServe.configureTeam(team) end
  end, 4000, 1, "delayTeleport")
  timers.addRound(function()
    if realServe.endIfTeamEmpty() or gameState.match.real.pendingServeTeam ~= team then return end
    realServe.spawnBall(team)
    gameState.match.real.pendingServeTeam = nil
  end, 6000, 1, "delaySpawnBall")
end
