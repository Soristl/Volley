function normalModeTeamWinner(team)
  if team == "red" then
    for i = 1, #playersRed do
      local player = playersRed[i].name
      if player ~= "a" and player ~= '' then
        playersNormalMode[player].wins = playersNormalMode[player].wins + 1
        playersNormalMode[player].winRatio = winRatioPercentage(playersNormalMode[player].wins,
          playersNormalMode[player].matches)
        playersNormalMode[player].winsRed = playersNormalMode[player].winsRed + 1
      end
    end

    return
  end

  for i = 1, #playersBlue do
    local player = playersBlue[i].name

    if player ~= "a" and player ~= '' then
      playersNormalMode[player].wins = playersNormalMode[player].wins + 1
      playersNormalMode[player].winRatio = winRatioPercentage(playersNormalMode[player].wins,
        playersNormalMode[player].matches)
      playersNormalMode[player].winsBlue = playersNormalMode[player].winsBlue + 1
    end
  end
end
