function addMatchToPlayerTwoTeamsMode(name)
  playersTwoTeamsMode[name].matches = playersTwoTeamsMode[name].matches + 1
  playersTwoTeamsMode[name].winRatio = winRatioPercentage(playersTwoTeamsMode[name].wins,
    playersTwoTeamsMode[name].matches)
end
