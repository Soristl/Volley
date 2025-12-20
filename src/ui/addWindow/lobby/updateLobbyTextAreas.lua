function updateLobbyTextAreas()
  resetPlayerConfigs()
  initGame = os.time() + 25000

  if gameStats.teamsMode then
    resetTeams = addTimer(function(i)
      if i == 1 then
        playersRed = {
          [1] = {name = ''},
          [2] = {name = ''},
          [3] = {name = ''},
        }
        playersBlue = {
          [1] = {name = ''},
          [2] = {name = ''},
          [3] = {name = ''},
        }
        playersYellow = {
          [1] = {name = ''},
          [2] = {name = ''},
          [3] = {name = ''}
        }

        playersGreen = {
          [1] = {name = ''},
          [2] = {name = ''},
          [3] = {name = ''}
        }
      end
    end, 1000, 1, "resetTeams")
    toggleTeams = addTimer(function(i)
      if i == 1 then
        for i = 1, 3 do
          ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamRed"..i.."'>Join", nil, x[i], y[i], 150, 40, 0xE14747, 0xE14747, 1, false)
        end

        for i = 4, 6 do
          ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamBlue"..i.."'>Join", nil, x[i], y[i], 150, 40, 0x184F81, 0x184F81, 1, false)
        end

        for i = 8, 10 do
          ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamYellow"..(i - 7).."'>Join", nil, x[i - 1], y[i - 1], 150, 40, 0xF59E0B, 0xF59E0B, 1, false)
        end

        for i = 11, 13 do
          ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamGreen"..(i - 10).."'>Join", nil, x[i - 1], y[i - 1], 150, 40, 0x109267, 0x109267, 1, false)
        end
      end
    end, 1500, 1, "toggleTeams")
    canJoin = addTimer(function(i)
      if i == 1 then
        gameStats.canJoin = true
      end
    end, 2500, 1, "canJoin")

    return
  end

  if gameStats.threeTeamsMode then
    resetTeams = addTimer(function(i)
      if i == 1 then
        playersRed = {
          [1] = {name = ''},
          [2] = {name = ''},
          [3] = {name = ''},
          [4] = {name = ''}, 
        }
        playersBlue = {
          [1] = {name = ''},
          [2] = {name = ''},
          [3] = {name = ''},
          [4] = {name = ''},
        }
        playersGreen = {
          [1] = {name = ''},
          [2] = {name = ''},
          [3] = {name = ''},
          [4] = {name = ''}
        }
      end
    end, 1000, 1, "resetTeams")
    toggleTeams = addTimer(function(i)
      if i == 1 then
        for i = 1, 4 do
          ui.addTextArea(threeTeamsMode.id[i], "<p align='center'><font size='14px'><a href='event:joinTeamRed"..i.."'>Join", nil, threeTeamsMode.x[i], threeTeamsMode.y[i], 150, 40, 0xE14747, 0xE14747, 1, false)
        end

        for i = 5, 8 do
          ui.addTextArea(threeTeamsMode.id[i], "<p align='center'><font size='14px'><a href='event:joinTeamBlue"..(i - 4).."'>Join", nil, threeTeamsMode.x[i], threeTeamsMode.y[i], 150, 40, 0x184F81, 0x184F81, 1, false)
        end

        for i = 9, 12 do
          ui.addTextArea(threeTeamsMode.id[i], "<p align='center'><font size='14px'><a href='event:joinTeamGreen"..(i - 8).."'>Join", nil, threeTeamsMode.x[i], threeTeamsMode.y[i], 150, 40, 0x109267, 0x109267, 1, false)
        end
      end
    end, 1500, 1, "toggleTeams")
    canJoin = addTimer(function(i)
      if i == 1 then
        gameStats.canJoin = true
      end
    end, 2500, 1, "canJoin")

    return
  end

  resetTeams = addTimer(function(i)
    if i == 1 then
      playersRed = {
        [1] = {name = ''},
        [2] = {name = ''},
        [3] = {name = ''},
        [4] = {name = ''},
        [5] = {name = ''},
        [6] = {name = ''}
      }
      playersBlue = {
        [1] = {name = ''},
        [2] = {name = ''},
        [3] = {name = ''},
        [4] = {name = ''},
        [5] = {name = ''},
        [6] = {name = ''}
      }
    end
  end, 1000, 1, "resetTeams")

  toggleTeams = addTimer(function(i)
    if i == 1 then
      for i = 1, 3 do
        ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamRed"..i.."'>Join", nil, x[i], y[i], 150, 40, 0xE14747, 0xE14747, 1, false)
      end

      for i = 4, 6 do
        ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamBlue"..i.."'>Join", nil, x[i], y[i], 150, 40, 0x184F81, 0x184F81, 1, false)
      end

      for i = 8, 10 do
        ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamRed"..(i - 4).."'>Join", nil, x[i - 1], y[i - 1], 150, 40, 0xE14747, 0xE14747, 1, false)
      end

      for i = 11, 13 do
        ui.addTextArea(i, "<p align='center'><font size='14px'><a href='event:joinTeamBlue"..(i - 4).."'>Join", nil, x[i - 1], y[i - 1], 150, 40, 0x184F81, 0x184F81, 1, false)
      end
    end
  end, 1500, 1, "toggleTeams")

  canJoin = addTimer(function(i)
    if i == 1 then
      gameStats.canJoin = true
    end
  end, 2500, 1, "canJoin")

end