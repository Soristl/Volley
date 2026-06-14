function fourTeamsModeWinner(teamText, playersOnTeam)
  local team = getTeamName(teamText)

  if team == "Yellow" then
    for i = 1, #playersOnTeam do
      local player = playersOnTeam[i].name

      if player ~= 'a' and player ~= '' then
        playersFourTeamsMode[player].wins = playersFourTeamsMode[player].wins + 1
        playersFourTeamsMode[player].winRatio = winRatioPercentage(playersFourTeamsMode[player].wins,
          playersFourTeamsMode[player].matches)
        playersFourTeamsMode[player].winsYellow = playersFourTeamsMode[player].winsYellow + 1
      end
    end

    return
  elseif team == "Red" then
    for i = 1, #playersOnTeam do
      local player = playersOnTeam[i].name

      if player ~= 'a' and player ~= '' then
        playersFourTeamsMode[player].wins = playersFourTeamsMode[player].wins + 1
        playersFourTeamsMode[player].winRatio = winRatioPercentage(playersFourTeamsMode[player].wins,
          playersFourTeamsMode[player].matches)
        playersFourTeamsMode[player].winsRed = playersFourTeamsMode[player].winsRed + 1
      end
    end

    return
  elseif team == "Blue" then
    for i = 1, #playersOnTeam do
      local player = playersOnTeam[i].name

      if player ~= 'a' and player ~= '' then
        playersFourTeamsMode[player].wins = playersFourTeamsMode[player].wins + 1
        playersFourTeamsMode[player].winRatio = winRatioPercentage(playersFourTeamsMode[player].wins,
          playersFourTeamsMode[player].matches)
        playersFourTeamsMode[player].winsBlue = playersFourTeamsMode[player].winsBlue + 1
      end
    end

    return
  elseif team == "Green" then
    for i = 1, #playersOnTeam do
      local player = playersOnTeam[i].name

      if player ~= 'a' and player ~= '' then
        playersFourTeamsMode[player].wins = playersFourTeamsMode[player].wins + 1
        playersFourTeamsMode[player].winRatio = winRatioPercentage(playersFourTeamsMode[player].wins,
          playersFourTeamsMode[player].matches)
        playersFourTeamsMode[player].winsGreen = playersFourTeamsMode[player].winsGreen + 1
      end
    end

    return
  end
end
