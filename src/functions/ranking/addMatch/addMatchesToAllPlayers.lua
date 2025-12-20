function addMatchesToAllPlayers()
  local mode = verifyMode()

  if mode == "Normal mode" then
    for name, value in pairs(playerInGame) do
      if value then
        playersNormalMode[name].matches = playersNormalMode[name].matches + 1
        playersNormalMode[name].winRatio = winRatioPercentage(playersNormalMode[name].wins, playersNormalMode[name].matches)
      end
    end
  elseif mode == "4 teams mode" then
    for name, value in pairs(playerInGame) do
      if value then
        playersFourTeamsMode[name].matches = playersFourTeamsMode[name].matches + 1
        playersFourTeamsMode[name].winRatio = winRatioPercentage(playersFourTeamsMode[name].wins, playersFourTeamsMode[name].matches)
      end
    end
  elseif mode == "3 teams mode" then
    for name, value in pairs(playerInGame) do
      if value then
        playersThreeTeamsMode[name].matches = playersThreeTeamsMode[name].matches + 1
        playersThreeTeamsMode[name].winRatio = winRatioPercentage(playersThreeTeamsMode[name].wins, playersThreeTeamsMode[name].matches)
      end
    end
  elseif mode == "2 teams mode" then
    for name, value in pairs(playerInGame) do
      if value then
        playersTwoTeamsMode[name].matches = playersTwoTeamsMode[name].matches + 1
        playersTwoTeamsMode[name].winRatio = winRatioPercentage(playersTwoTeamsMode[name].wins, playersTwoTeamsMode[name].matches)
      end
    end
  elseif mode == "Real mode" then
    for name, value in pairs(playerInGame) do
      if value then
        playersRealMode[name].matches = playersRealMode[name].matches + 1
        playersRealMode[name].winRatio = winRatioPercentage(playersRealMode[name].wins, playersRealMode[name].matches)
      end
    end
  end
end
