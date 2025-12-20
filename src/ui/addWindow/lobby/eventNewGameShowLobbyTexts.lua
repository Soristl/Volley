function eventNewGameShowLobbyTexts()
  if gameStats.threeTeamsMode then
    for i = 1, 4 do
      if playersRed[i].name == "" then
        ui.addTextArea(threeTeamsMode.id[i], "<p align='center'><font size='14px'><a href='event:joinTeamRed"..i.."'>Join", nil, threeTeamsMode.x[i], threeTeamsMode.y[i], 150, 40, 0xE14747, 0xE14747, 1, false)
      else
        ui.addTextArea(threeTeamsMode.id[i], "<p align='center'><font size='14px'><a href='event:leaveTeamRed"..i.."'>"..playersRed[i].name.."", nil, threeTeamsMode.x[i], threeTeamsMode.y[i], 150, 40, 0x871F1F, 0x871F1F, 1, false)
      end
    end

    for i = 5, 8 do
      if playersBlue[i - 4].name == "" then
        ui.addTextArea(threeTeamsMode.id[i], "<p align='center'><font size='14px'><a href='event:joinTeamBlue"..(i - 4).."'>Join", nil, threeTeamsMode.x[i], threeTeamsMode.y[i], 150, 40, 0x184F81, 0x184F81, 1, false)
      else
        ui.addTextArea(threeTeamsMode.id[i], "<p align='center'><font size='14px'><a href='event:leaveTeamBlue"..(i - 4).."'>"..playersBlue[i - 4].name.."", nil, threeTeamsMode.x[i], threeTeamsMode.y[i], 150, 40, 0x0B3356, 0x0B3356, 1, false)
      end
    end

    for i = 9, 12 do
      if playersGreen[i - 8].name == "" then
        ui.addTextArea(threeTeamsMode.id[i], "<p align='center'><font size='14px'><a href='event:joinTeamGreen"..(i - 8).."'>Join", nil, threeTeamsMode.x[i], threeTeamsMode.y[i], 150, 40, 0x109267, 0x109267, 1, false)
      else
        ui.addTextArea(threeTeamsMode.id[i], "<p align='center'><font size='14px'><a href='event:leaveTeamGreen"..(i - 8).."'>"..playersGreen[i - 8].name.."", nil, threeTeamsMode.x[i], threeTeamsMode.y[i], 150, 40, 0x0C6346, 0x0C6346, 1, false)
      end
    end

    return
  end

  for i = 1, 3 do
    if playersRed[i].name == "" then
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamRed"..i.."'>Join", nil, x[i], y[i], 150, 40, 0xE14747, 0xE14747, 1, false)
    else
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:leaveTeamRed"..i.."'>"..playersRed[i].name.."", nil, x[i], y[i], 150, 40, 0x871F1F, 0x871F1F, 1, false)
    end
  end
  for i= 4, 6 do
    if playersBlue[i - 3].name == "" then
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamBlue"..i.."'>Join", nil, x[i], y[i], 150, 40, 0x184F81, 0x184F81, 1, false)
    else
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:leaveTeamBlue"..i.."'>"..playersBlue[i - 3].name.."", nil, x[i], y[i], 150, 40, 0x0B3356, 0x0B3356, 1, false)
    end
  end
  if not gameStats.teamsMode then
    for i = 8, 10 do
      if playersRed[i - 4].name == "" then
        ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamRed"..(i - 4).."'>Join", nil, x[i - 1], y[i - 1], 150, 40, 0xE14747, 0xE14747, 1, false)
      else
        ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:leaveTeamRed"..(i - 4).."'>"..playersRed[i - 4].name.."", nil, x[i - 1], y[i - 1], 150, 40, 0x871F1F, 0x871F1F, 1, false)
      end
    end
    for i = 11, 13 do
      if playersBlue[i - 7].name == "" then
        ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamBlue"..(i - 4).."'>Join", nil, x[i - 1], y[i - 1], 150, 40, 0x184F81, 0x184F81, 1, false)
      else
        ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:leaveTeamBlue"..(i - 4).."'>"..playersBlue[i - 7].name.."", nil, x[i - 1], y[i- 1], 150, 40, 0x0B3356, 0x0B3356, 1, false)
      end
    end

    return
  end
  for i = 8, 10 do
    if playersYellow[i - 7].name == "" then
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamYellow"..(i - 7).."'>Join", nil, x[i - 1], y[i - 1], 150, 40, 0xF59E0B, 0xF59E0B, 1, false)
    else
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:leaveTeamYellow"..(i - 7).."'>"..playersYellow[i - 7].name.."", nil, x[i - 1], y[i - 1], 150, 40, 0xB57200, 0xB57200, 1, false)
    end
  end

  for i = 11, 13 do
    if playersGreen[i - 10].name == "" then
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamGreen"..(i - 10).."'>Join", nil, x[i - 1], y[i - 1], 150, 40, 0x109267, 0x109267, 1, false)
    else
      ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:leaveTeamGreen"..(i - 10).."'>"..playersGreen[i - 10].name.."", nil, x[i - 1], y[i - 1], 150, 40, 0x0C6346, 0x0C6346, 1, false)
    end
  end
end