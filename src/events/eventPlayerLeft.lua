function eventPlayerLeft(name)
  playerLeft[name] = true
  playerLastMatchCount[name] = countMatches
  playerCanTransform[name] = true
  playerInGame[name] = false
  if mode == "startGame" then
    updateLobbyTexts(name)

    return
  elseif mode ~= "startGame" then
    canVote[name] = true

    if gameStats.teamsMode or gameStats.threeTeamsMode then
      leaveTeamTeamsModeConfig(name)
    end

    for i = 1, #playersRed do
      if playersRed[i].name == name then
        playersRed[i].name = ''
        twoTeamsPlayerRedPosition[i] = ''
        removePlayerOnSpawnConfig(name)
        leaveConfigRealMode(name)
      end
      if playersBlue[i].name == name then
        playersBlue[i].name = ''
        twoTeamsPlayerBluePosition[i] = ''
        removePlayerOnSpawnConfig(name)
        leaveConfigRealMode(name)
      end
    end
  end
end