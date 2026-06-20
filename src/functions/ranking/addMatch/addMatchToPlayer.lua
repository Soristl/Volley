function addMatchToPlayer(name)
  playersNormalMode[name].matches = playersNormalMode[name].matches + 1
  playersNormalMode[name].winRatio = winRatioPercentage(playersNormalMode[name].wins, playersNormalMode[name].matches)
end
