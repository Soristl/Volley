-- A joining player needs only their own lobby controls. Omitted viewer broadcasts updates.
function eventNewGameShowLobbyTexts(viewer)
  if gameStats.threeTeamsMode then
    for i = 1, 4 do
      clubhouse.teamSeat("Red", i, gameState.teams.red[i].name, viewer)
    end

    for i = 5, 8 do
      clubhouse.teamSeat("Blue", i - 4, gameState.teams.blue[i - 4].name, viewer)
    end

    for i = 9, 12 do
      clubhouse.teamSeat("Green", i - 8, gameState.teams.green[i - 8].name, viewer)
    end

    return
  end

  for i = 1, 3 do
    clubhouse.teamSeat("Red", i, gameState.teams.red[i].name, viewer)
  end
  for i = 4, 6 do
    clubhouse.teamSeat("Blue", i - 3, gameState.teams.blue[i - 3].name, viewer)
  end
  if not gameStats.teamsMode then
    for i = 8, 10 do
      clubhouse.teamSeat("Red", i - 4, gameState.teams.red[i - 4].name, viewer)
    end
    for i = 11, 13 do
      clubhouse.teamSeat("Blue", i - 7, gameState.teams.blue[i - 7].name, viewer)
    end

    return
  end
  for i = 8, 10 do
    clubhouse.teamSeat("Yellow", i - 7, gameState.teams.yellow[i - 7].name, viewer)
  end

  for i = 11, 13 do
    clubhouse.teamSeat("Green", i - 10, gameState.teams.green[i - 10].name, viewer)
  end
end
