function updateLobbyTexts(name)
  if gameStats.threeTeamsMode then
    for i = 1, 4 do
      if gameState.teams.red[i].name == name then
        gameState.teams.red[i].name = ''

        clubhouse.teamSeat("Red", i, "")

        return
      end
    end

    for i = 5, 8 do
      if gameState.teams.blue[i - 4].name == name then
        gameState.teams.blue[i - 4].name = ''

        clubhouse.teamSeat("Blue", i - 4, "")

        return
      end
    end

    for i = 9, 12 do
      if gameState.teams.green[i - 8].name == name then
        gameState.teams.green[i - 8].name = ''

        clubhouse.teamSeat("Green", i - 8, "")

        return
      end
    end

    return
  end


  for i = 1, 3 do
    if gameState.teams.red[i].name == name then
      gameState.teams.red[i].name = ''
      clubhouse.teamSeat("Red", i, "")
    end
    if gameState.teams.blue[i].name == name then
      gameState.teams.blue[i].name = ''
      clubhouse.teamSeat("Blue", i, "")
    end
  end
  if not gameStats.teamsMode then
    for i = 8, 10 do
      if gameState.teams.red[i - 4].name == name then
        gameState.teams.red[i - 4].name = ''
        clubhouse.teamSeat("Red", i - 4, "")
      end
    end
    for i = 11, 13 do
      if gameState.teams.blue[i - 7].name == name then
        gameState.teams.blue[i - 7].name = ''
        clubhouse.teamSeat("Blue", i - 7, "")
      end
    end
    return
  end
  for i = 8, 10 do
    if gameState.teams.yellow[i - 7].name == name then
      gameState.teams.yellow[i - 7].name = ''
      clubhouse.teamSeat("Yellow", i - 7, "")
    end
  end

  for i = 11, 13 do
    if gameState.teams.green[i - 10].name == name then
      gameState.teams.green[i - 10].name = ''
      clubhouse.teamSeat("Green", i - 10, "")
    end
  end
end
