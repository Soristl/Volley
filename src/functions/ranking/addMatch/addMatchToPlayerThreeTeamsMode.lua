function addMatchToPlayerThreeTeamsMode(name)
  playersThreeTeamsMode[name].matches = playersThreeTeamsMode[name].matches + 1
  playersThreeTeamsMode[name].winRatio = winRatioPercentage(playersThreeTeamsMode[name].wins, playersThreeTeamsMode[name].matches)
end