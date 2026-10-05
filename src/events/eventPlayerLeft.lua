function eventPlayerLeft(name)
  lobbyTransition.leave(name)
  mapBackgrounds.leave(name)
  clearPlayerTimers(name, true)
  clearPlayerGameplay(name)
  removePlayerTrophy(name)
  gameCrowns.clearPlayer(name)
  removePlayerOnSpawnConfig(name)
  clubhouse.ballSkins.clearPlayer(name)
  clubhouse.clearPlayer(name)
  removeUITrophies(name)
  closeRankingUI(name)
  playerLeft[name] = true
  playerLastMatchCount[name] = countMatches
  playerCanTransform[name] = true
  playerInGame[name] = false
  if lobbyTransition.blocksInput() then clearDepartedPlayerUiState(name);return end
  if gameState.phase == "startGame" then
    updateLobbyTexts(name)
    -- The departing player can still be in playerList during the broadcast.
    clubhouse.clearPlayer(name)
    clearDepartedPlayerUiState(name)
    return
  elseif gameState.phase ~= "startGame" then
    canVote[name] = true

    if gameStats.teamsMode or gameStats.threeTeamsMode then
      leaveTeamTeamsModeConfig(name)
    end

    for i = 1, #gameState.teams.red do
      if gameState.teams.red[i].name == name then
        gameState.teams.red[i].name = ''
        twoTeamsPlayerRedPosition[i] = ''
        removePlayerOnSpawnConfig(name)
        leaveConfigRealMode(name, "red")
      end
      if gameState.teams.blue[i].name == name then
        gameState.teams.blue[i].name = ''
        twoTeamsPlayerBluePosition[i] = ''
        removePlayerOnSpawnConfig(name)
        leaveConfigRealMode(name, "blue")
      end
    end
  end
  clearDepartedPlayerUiState(name)
end
