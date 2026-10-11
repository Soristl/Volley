function eventPlayerDied(name)
  if gameState.phase ~= 'gameStart' or playerState.ban[name] or playerState.left[name]
    or not tfm.get.room.playerList[name] or playerState.dead[name] then return end
  local playerName = name
  -- The Real serve lock blocks transformations, not normal death recovery.
  local recoveringDuringServe = gameState.match.mode.realMode and gameState.match.real.pendingServeTeam and mapLoad.isReady()
  if playerState.inGame[playerName] and (gameState.match.round.canTransform or recoveringDuringServe) and not playerState.pressSpace[name] then
    playerState.dead[playerName] = true
    
    timers.addPlayerRound(name, function(i)
      if i == 1 then
        if not playerState.inGame[playerName] then playerState.dead[playerName] = false; return end
        tfm.exec.respawnPlayer(playerName)

        if gameState.match.mode.teamsMode then
          gameTeams.placeFourMember(playerName)
        elseif gameState.match.mode.threeTeamsMode then
          gameTeams.placeThreeMember(playerName)
        else
          gameTeams.placeStandardMember(playerName)
        end
        playerState.dead[playerName] = false
      end
    end, 5000, 1, "deadTimer")
  end
end
