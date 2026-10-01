-- A joining player needs only their own lobby controls. Omitted viewer broadcasts updates.
function eventNewGameShowLobbyTexts(viewer)
  if gameStats.threeTeamsMode then
    for i = 1, 4 do
      if gameState.teams.red[i].name == "" then
        clubhouse.joinArea(threeTeamsMode.id[i],
          "<p align='center'><font size='14px'><a href='event:joinTeamRed" .. i .. "'>Join", viewer, threeTeamsMode.x[i],
          threeTeamsMode.y[i], 150, 40, 0xE14747, 0xE14747, 1, false)
      else
        clubhouse.joinArea(threeTeamsMode.id[i],
          "<p align='center'><font size='14px'><a href='event:leaveTeamRed" .. i .. "'>" .. gameState.teams.red[i].name .. "", viewer,
          threeTeamsMode.x[i], threeTeamsMode.y[i], 150, 40, 0x871F1F, 0x871F1F, 1, false)
      end
    end

    for i = 5, 8 do
      if gameState.teams.blue[i - 4].name == "" then
        clubhouse.joinArea(threeTeamsMode.id[i],
          "<p align='center'><font size='14px'><a href='event:joinTeamBlue" .. (i - 4) .. "'>Join", viewer,
          threeTeamsMode.x[i], threeTeamsMode.y[i], 150, 40, 0x184F81, 0x184F81, 1, false)
      else
        clubhouse.joinArea(threeTeamsMode.id[i],
          "<p align='center'><font size='14px'><a href='event:leaveTeamBlue" ..
          (i - 4) .. "'>" .. gameState.teams.blue[i - 4].name .. "", viewer, threeTeamsMode.x[i], threeTeamsMode.y[i], 150, 40,
          0x0B3356, 0x0B3356, 1, false)
      end
    end

    for i = 9, 12 do
      if gameState.teams.green[i - 8].name == "" then
        clubhouse.joinArea(threeTeamsMode.id[i],
          "<p align='center'><font size='14px'><a href='event:joinTeamGreen" .. (i - 8) .. "'>Join", viewer,
          threeTeamsMode.x[i], threeTeamsMode.y[i], 150, 40, 0x109267, 0x109267, 1, false)
      else
        clubhouse.joinArea(threeTeamsMode.id[i],
          "<p align='center'><font size='14px'><a href='event:leaveTeamGreen" ..
          (i - 8) .. "'>" .. gameState.teams.green[i - 8].name .. "", viewer, threeTeamsMode.x[i], threeTeamsMode.y[i], 150, 40,
          0x0C6346, 0x0C6346, 1, false)
      end
    end

    return
  end

  for i = 1, 3 do
    if gameState.teams.red[i].name == "" then
      clubhouse.joinArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamRed" .. i .. "'>Join", viewer, x[i],
        y[i], 150, 40, 0xE14747, 0xE14747, 1, false)
    else
      clubhouse.joinArea(i,
        "<p align='center'><font size='14px'><a href='event:leaveTeamRed" .. i .. "'>" .. gameState.teams.red[i].name .. "", viewer,
        x[i], y[i], 150, 40, 0x871F1F, 0x871F1F, 1, false)
    end
  end
  for i = 4, 6 do
    if gameState.teams.blue[i - 3].name == "" then
      clubhouse.joinArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamBlue" .. i .. "'>Join", viewer, x[i],
        y[i], 150, 40, 0x184F81, 0x184F81, 1, false)
    else
      clubhouse.joinArea(i,
        "<p align='center'><font size='14px'><a href='event:leaveTeamBlue" .. i .. "'>" .. gameState.teams.blue[i - 3].name .. "",
        viewer, x[i], y[i], 150, 40, 0x0B3356, 0x0B3356, 1, false)
    end
  end
  if not gameStats.teamsMode then
    for i = 8, 10 do
      if gameState.teams.red[i - 4].name == "" then
        clubhouse.joinArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamRed" .. (i - 4) .. "'>Join", viewer,
          x[i - 1], y[i - 1], 150, 40, 0xE14747, 0xE14747, 1, false)
      else
        clubhouse.joinArea(i,
          "<p align='center'><font size='14px'><a href='event:leaveTeamRed" .. (i - 4) ..
          "'>" .. gameState.teams.red[i - 4].name .. "", viewer, x[i - 1], y[i - 1], 150, 40, 0x871F1F, 0x871F1F, 1, false)
      end
    end
    for i = 11, 13 do
      if gameState.teams.blue[i - 7].name == "" then
        clubhouse.joinArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamBlue" .. (i - 4) .. "'>Join", viewer,
          x[i - 1], y[i - 1], 150, 40, 0x184F81, 0x184F81, 1, false)
      else
        clubhouse.joinArea(i,
          "<p align='center'><font size='14px'><a href='event:leaveTeamBlue" ..
          (i - 4) .. "'>" .. gameState.teams.blue[i - 7].name .. "", viewer, x[i - 1], y[i - 1], 150, 40, 0x0B3356, 0x0B3356, 1,
          false)
      end
    end

    return
  end
  for i = 8, 10 do
    if gameState.teams.yellow[i - 7].name == "" then
      clubhouse.joinArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamYellow" .. (i - 7) .. "'>Join", viewer,
        x[i - 1], y[i - 1], 150, 40, 0xF59E0B, 0xF59E0B, 1, false)
    else
      clubhouse.joinArea(i,
        "<p align='center'><font size='14px'><a href='event:leaveTeamYellow" ..
        (i - 7) .. "'>" .. gameState.teams.yellow[i - 7].name .. "", viewer, x[i - 1], y[i - 1], 150, 40, 0xB57200, 0xB57200, 1,
        false)
    end
  end

  for i = 11, 13 do
    if gameState.teams.green[i - 10].name == "" then
      clubhouse.joinArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamGreen" .. (i - 10) .. "'>Join", viewer,
        x[i - 1], y[i - 1], 150, 40, 0x109267, 0x109267, 1, false)
    else
      clubhouse.joinArea(i,
        "<p align='center'><font size='14px'><a href='event:leaveTeamGreen" ..
        (i - 10) .. "'>" .. gameState.teams.green[i - 10].name .. "", viewer, x[i - 1], y[i - 1], 150, 40, 0x0C6346, 0x0C6346, 1,
        false)
    end
  end
end
