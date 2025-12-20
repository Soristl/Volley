function threeTeamsModeWinner(teamText, playersOnTeam)
  local team = getTeamName(teamText)

  if team == "Red" then
    for i = 1, #playersOnTeam do
      local player = playersOnTeam[i].name

      if player ~= 'a' and player ~= '' then
        playersThreeTeamsMode[player].wins = playersThreeTeamsMode[player].wins + 1
        playersThreeTeamsMode[player].winRatio = winRatioPercentage(playersThreeTeamsMode[player].wins, playersThreeTeamsMode[player].matches)
        playersThreeTeamsMode[player].winsRed = playersThreeTeamsMode[player].winsRed + 1
      end
    end

    return
  elseif team == "Blue" then
    for i = 1, #playersOnTeam do
      local player = playersOnTeam[i].name

      if player ~= 'a' and player ~= '' then
        playersThreeTeamsMode[player].wins = playersThreeTeamsMode[player].wins + 1
        playersThreeTeamsMode[player].winRatio = winRatioPercentage(playersThreeTeamsMode[player].wins, playersThreeTeamsMode[player].matches)
        playersThreeTeamsMode[player].winsBlue = playersThreeTeamsMode[player].winsBlue + 1
      end
    end

    return
  elseif team == "Green" then
    for i = 1, #playersOnTeam do
      local player = playersOnTeam[i].name

      if player ~= 'a' and player ~= '' then
        playersThreeTeamsMode[player].wins = playersThreeTeamsMode[player].wins + 1
        playersThreeTeamsMode[player].winRatio = winRatioPercentage(playersThreeTeamsMode[player].wins, playersThreeTeamsMode[player].matches)
        playersThreeTeamsMode[player].winsGreen = playersThreeTeamsMode[player].winsGreen + 1
      end
    end

    return
  end
end