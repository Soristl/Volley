do
local function clearDepartingPlayer(name)
  lobbyTransition.leave(name)
  mapBackgrounds.leave(name)
  clearPlayerTimers(name, true)
  clearPlayerGameplay(name)
  removePlayerTrophy(name)
  gameCrowns.clearPlayer(name)
  gameTeams.releaseSpawn(name)
  clubhouse.ballSkins.clearPlayer(name)
  clubhouse.clearPlayer(name)
  clubhouse.closeProfile(name)
  clubhouse.closeRanking(name)
  playerLeft[name] = true
  playerLastMatchCount[name] = countMatches
  playerCanTransform[name] = true
  playerInGame[name] = false
end

local function removeDepartingPlayerFromTeams(name)
  canVote[name] = true

  if gameStats.teamsMode or gameStats.threeTeamsMode then
    gameTeams.removeMultiMember(name)
  end

  for i = 1, #gameState.teams.red do
    if gameState.teams.red[i].name == name then
      gameState.teams.red[i].name = ''
      twoTeamsPlayerRedPosition[i] = ''
      gameTeams.releaseSpawn(name)
      realServe.playerLeft(name, "red")
    end
    if gameState.teams.blue[i].name == name then
      gameState.teams.blue[i].name = ''
      twoTeamsPlayerBluePosition[i] = ''
      gameTeams.releaseSpawn(name)
      realServe.playerLeft(name, "blue")
    end
  end
end

function eventPlayerLeft(name)
  clearDepartingPlayer(name)
  if lobbyTransition.blocksInput() then clearDepartedPlayerUiState(name);return end
  if gameState.phase == "startGame" then
    gameTeams.releaseLobbySeat(name)
    -- The departing player can still be in playerList during the broadcast.
    clubhouse.clearPlayer(name)
    clearDepartedPlayerUiState(name)
    return
  elseif gameState.phase ~= "startGame" then
    removeDepartingPlayerFromTeams(name)
  end
  clearDepartedPlayerUiState(name)
end
end
