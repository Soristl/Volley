function addMatchToPlayerFourTeamsMode(name)
  playersFourTeamsMode[name].matches = playersFourTeamsMode[name].matches + 1
  playersFourTeamsMode[name].winRatio = winRatioPercentage(playersFourTeamsMode[name].wins,
    playersFourTeamsMode[name].matches)
end
