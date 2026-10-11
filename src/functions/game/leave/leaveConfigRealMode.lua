function realServe.playerLeft(name, team)
  if not gameState.match.mode.realMode or gameState.phase ~= "gameStart" then return end
  if realServe.endIfTeamEmpty() then return end
  if team ~= "red" and team ~= "blue" then return end
  local pending = gameState.match.real.pendingServeTeam
  if pending and pending ~= team then return end
  if not pending and not gameState.match.real[team .. "Serve"] then return end
  if gameState.match.real[team .. "PlayerServe"] ~= name then return end
  gameState.match.real[team == "red" and "aceRed" or "aceBlue"] = false
  gameState.match.real[team .. "PlayerServe"] = ""
  tfm.exec.chatMessage("<ce>[System]: the server left; choosing another player from the same team.<n>", nil)
  realServe.schedule(team)
end
