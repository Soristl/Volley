function addMatchToPlayerRealMode(name)
  playersRealMode[name].matches = playersRealMode[name].matches + 1
  playersRealMode[name].winRatio = winRatioPercentage(playersRealMode[name].wins, playersRealMode[name].matches)
end
