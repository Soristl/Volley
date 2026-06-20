function teleportPlayerOnTeamsMode(name)
  local x = { [1] = 200, [2] = 600, [3] = 1000 }

  if gameStats.typeMap == "large4v4" then
    for i = 1, #playersYellow do
      if playersYellow[i].name == name then
        tfm.exec.movePlayer(name, 200, 334)

        return
      end
    end
    for i = 1, #playersRed do
      if playersRed[i].name == name then
        tfm.exec.movePlayer(name, 600, 334)

        return
      end
    end
    for i = 1, #playersBlue do
      if playersBlue[i].name == name then
        tfm.exec.movePlayer(name, 1000, 334)

        return
      end
    end

    for i = 1, #playersGreen do
      if playersGreen[i].name == name then
        tfm.exec.movePlayer(name, 1400, 334)

        return
      end
    end
  else
    for i = 1, #teamsPlayersOnGame do
      for j = 1, #teamsPlayersOnGame[i] do
        if teamsPlayersOnGame[i][j].name == name then
          print(x[i])
          tfm.exec.movePlayer(name, x[i], 334)
          return
        end
      end
    end
  end
end
