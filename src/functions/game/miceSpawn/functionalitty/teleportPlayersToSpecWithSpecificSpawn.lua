function gameTeams.placeSpectator(name)
  if #gameState.court.lobbySpawns > 0 then
    local index = math.random(1, #gameState.court.lobbySpawns)

    tfm.exec.movePlayer(name, gameState.court.lobbySpawns[index].x, gameState.court.lobbySpawns[index].y)
  else
    if gameState.match.mode.threeTeamsMode then
      if gameState.match.court.typeMap == "large4v4" then
        tfm.exec.movePlayer(name, 900, 74)
      else
        tfm.exec.movePlayer(name, 600, 74)
      end
    else
      tfm.exec.movePlayer(name, 391, 74)
    end
  end
end
