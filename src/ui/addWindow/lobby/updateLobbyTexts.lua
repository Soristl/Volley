function updateLobbyTexts(name)
  if gameStats.threeTeamsMode then
    for i = 1, 4 do
      if gameState.teams.red[i].name == name then
        gameState.teams.red[i].name = ''

        clubhouse.joinArea(threeTeamsMode.id[i],
          "<p align='center'><font size='14px'><a href='event:joinTeamRed" .. i .. "'>Join", nil, threeTeamsMode.x[i],
          threeTeamsMode.y[i], 150, 40, 0xE14747, 0xE14747, 1, false)

        return
      end
    end

    for i = 5, 8 do
      if gameState.teams.blue[i - 4].name == name then
        gameState.teams.blue[i - 4].name = ''

        clubhouse.joinArea(threeTeamsMode.id[i],
          "<p align='center'><font size='14px'><a href='event:joinTeamBlue" .. (i - 4) .. "'>Join", nil,
          threeTeamsMode.x[i], threeTeamsMode.y[i], 150, 40, 0x184F81, 0x184F81, 1, false)

        return
      end
    end

    for i = 9, 12 do
      if gameState.teams.green[i - 8].name == name then
        gameState.teams.green[i - 8].name = ''

        clubhouse.joinArea(threeTeamsMode.id[i],
          "<p align='center'><font size='14px'><a href='event:joinTeamGreen" .. (i - 8) .. "'>Join", nil,
          threeTeamsMode.x[i], threeTeamsMode.y[i], 150, 40, 0x109267, 0x109267, 1, false)

        return
      end
    end

    return
  end


  for i = 1, 3 do
    if gameState.teams.red[i].name == name then
      gameState.teams.red[i].name = ''
      clubhouse.joinArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamRed" .. i .. "'>Join", nil, x[i],
        y[i], 150, 40, 0xE14747, 0xE14747, 1, false)
    end
    if gameState.teams.blue[i].name == name then
      gameState.teams.blue[i].name = ''
      clubhouse.joinArea(i + 3, "<p align='center'><font size='14px'><a href='event:joinTeamBlue" .. (i + 3) .. "'>Join", nil,
        x[i + 3], y[i + 3], 150, 40, 0x184F81, 0x184F81, 1, false)
    end
  end
  if not gameStats.teamsMode then
    for i = 8, 10 do
      if gameState.teams.red[i - 4].name == name then
        gameState.teams.red[i - 4].name = ''
        clubhouse.joinArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamRed" .. (i - 4) .. "'>Join", nil,
          x[i - 1], y[i - 1], 150, 40, 0xE14747, 0xE14747, 1, false)
      end
    end
    for i = 11, 13 do
      if gameState.teams.blue[i - 7].name == name then
        gameState.teams.blue[i - 7].name = ''
        clubhouse.joinArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamBlue" .. (i - 4) .. "'>Join", nil,
          x[i - 1], y[i - 1], 150, 40, 0x184F81, 0x184F81, 1, false)
      end
    end
    return
  end
  for i = 8, 10 do
    if gameState.teams.yellow[i - 7].name == name then
      gameState.teams.yellow[i - 7].name = ''
      clubhouse.joinArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamYellow" .. (i - 7) .. "'>Join", nil,
        x[i - 1], y[i - 1], 150, 40, 0xF59E0B, 0xF59E0B, 1, false)
    end
  end

  for i = 11, 13 do
    if gameState.teams.green[i - 10].name == name then
      gameState.teams.green[i - 10].name = ''
      clubhouse.joinArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamGreen" .. (i - 10) .. "'>Join", nil,
        x[i - 1], y[i - 1], 150, 40, 0x109267, 0x109267, 1, false)
    end
  end
end
