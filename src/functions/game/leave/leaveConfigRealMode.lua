function leaveConfigRealMode(name, team)
  if not gameStats.realMode or gameState.phase ~= "gameStart" then return end
  if endRealMatchIfTeamEmpty() then return end
  if team ~= "red" and team ~= "blue" then return end
  local pending = gameStats.pendingServeTeam
  if pending and pending ~= team then return end
  if not pending and not gameStats[team .. "Serve"] then return end
  if gameStats[team .. "PlayerServe"] ~= name then return end
  gameStats[team == "red" and "aceRed" or "aceBlue"] = false
  gameStats[team .. "PlayerServe"] = ""
  tfm.exec.chatMessage("<ce>[System]: the server left; choosing another player from the same team.<n>", nil)
  scheduleRealServe(team)
end
