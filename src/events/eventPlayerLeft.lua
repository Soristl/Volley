do
local function clearDepartingPlayer(name)
  lobbyTransition.leave(name)
  mapBackgrounds.leave(name)
  timers.clearPlayer(name, true)
  playerRuntime.clearGameplay(name)
  clubhouse.removePlayerTrophy(name)
  gameCrowns.clearPlayer(name)
  gameTeams.releaseSpawn(name)
  clubhouse.ballSkins.clearPlayer(name)
  clubhouse.clearPlayer(name)
  clubhouse.closeProfile(name)
  clubhouse.closeRanking(name)
  playerState.left[name] = true
  sessionRanking.recordDeparture(name)
  playerState.canTransform[name] = true
  playerState.inGame[name] = false
end

local function removeDepartingPlayerFromTeams(name)
  gameState.voting.eligible[name] = true

  if gameState.match.mode.teamsMode or gameState.match.mode.threeTeamsMode then
    gameTeams.removeMultiMember(name)
  end

  for i = 1, #gameState.teams.red do
    if gameState.teams.red[i].name == name then
      gameState.teams.red[i].name = ''
      gameState.teamLayout.roles.red[i] = ''
      gameTeams.releaseSpawn(name)
      realServe.playerLeft(name, "red")
    end
    if gameState.teams.blue[i].name == name then
      gameState.teams.blue[i].name = ''
      gameState.teamLayout.roles.blue[i] = ''
      gameTeams.releaseSpawn(name)
      realServe.playerLeft(name, "blue")
    end
  end
end

function eventPlayerLeft(name)
  clearDepartingPlayer(name)
  if lobbyTransition.blocksInput() then clubhouse.releaseDepartedState(name);return end
  if gameState.phase == "startGame" then
    gameTeams.releaseLobbySeat(name)
    -- The departing player can still be in playerList during the broadcast.
    clubhouse.clearPlayer(name)
    clubhouse.releaseDepartedState(name)
    return
  elseif gameState.phase ~= "startGame" then
    removeDepartingPlayerFromTeams(name)
  end
  clubhouse.releaseDepartedState(name)
end
end
