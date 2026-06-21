function realModeWinner(team)
  if team == "red" then
    for i = 1, #playersRed do
      local player = playersRed[i].name
      if player ~= "a" and player ~= '' then
        playersRealMode[player].wins = playersRealMode[player].wins + 1
        playersRealMode[player].winRatio = winRatioPercentage(playersRealMode[player].wins,
          playersRealMode[player].matches)
        playersRealMode[player].winsRed = playersRealMode[player].winsRed + 1
      end
    end

    return
  end

  for i = 1, #playersBlue do
    local player = playersBlue[i].name

    if player ~= "a" and player ~= '' then
      playersRealMode[player].wins = playersRealMode[player].wins + 1
      playersRealMode[player].winRatio = winRatioPercentage(playersRealMode[player].wins, playersRealMode[player]
        .matches)
      playersRealMode[player].winsBlue = playersRealMode[player].winsBlue + 1
    end
  end
end
