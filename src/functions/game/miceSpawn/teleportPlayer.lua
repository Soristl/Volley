function teleportPlayer(name, mode)
  local xRed = { [1] = 101 }
  local xBlue = { [1] = 700 }

  if gameStats.teamsMode then
    print("b")
    teleportPlayerOnTeamsMode(name)
    return
  end

  if mode == "4v4" then
    xRed = { [1] = 301 }
    xBlue = { [1] = 900 }
  elseif mode == "6v6" then
    xRed = { [1] = 401 }
    xBlue = { [1] = 1500 }
  end
  for i = 1, #playersRed do
    if playersRed[i].name == name then
      if gameStats.twoTeamsMode then
        if twoTeamsPlayerRedPosition[i] == "middle" then
          tfm.exec.movePlayer(name, 600, 334)
          return
        end
        tfm.exec.movePlayer(name, 1400, 334)
        return
      end
      if gameStats.realMode then
        tfm.exec.movePlayer(name, 900, 334)
        return
      end
      tfm.exec.movePlayer(name, xRed[1], 334)
    end
  end
  for i = 1, #playersBlue do
    if playersBlue[i].name == name then
      if gameStats.twoTeamsMode then
        if twoTeamsPlayerBluePosition[i] == "middle" then
          tfm.exec.movePlayer(name, 1000, 334)
          return
        end
        tfm.exec.movePlayer(name, 200, 334)
        return
      end
      if gameStats.realMode then
        tfm.exec.movePlayer(name, 1700, 334)
        return
      end
      tfm.exec.movePlayer(name, xBlue[1], 334)
    end
  end
end
