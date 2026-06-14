function twoTeamsModeWinner(team)
  if team == "red" then
    for i = 1, #playersRed do
      local player = playersRed[i].name
      if player ~= "a" and player ~= '' then
        playersTwoTeamsMode[player].wins = playersTwoTeamsMode[player].wins + 1
        playersTwoTeamsMode[player].winRatio = winRatioPercentage(playersTwoTeamsMode[player].wins,
          playersTwoTeamsMode[player].matches)
        playersTwoTeamsMode[player].winsRed = playersTwoTeamsMode[player].winsRed + 1
      end
    end

    return
  end

  for i = 1, #playersBlue do
    local player = playersBlue[i].name

    if player ~= "a" and player ~= '' then
      playersTwoTeamsMode[player].wins = playersTwoTeamsMode[player].wins + 1
      playersTwoTeamsMode[player].winRatio = winRatioPercentage(playersTwoTeamsMode[player].wins,
        playersTwoTeamsMode[player].matches)
      playersTwoTeamsMode[player].winsBlue = playersTwoTeamsMode[player].winsBlue + 1
    end
  end
end
