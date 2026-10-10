function eventPlayerDied(name)
  if gameState.phase ~= 'gameStart' or playerBan[name] or playerLeft[name]
    or not tfm.get.room.playerList[name] or isPlayerDead[name] then return end
  local playerName = name
  -- The Real serve lock blocks transformations, not normal death recovery.
  local recoveringDuringServe = gameStats.realMode and gameStats.pendingServeTeam and isGameplayMapReady()
  if playerInGame[playerName] and (gameStats.canTransform or recoveringDuringServe) and not playerPressSpace[name] then
    isPlayerDead[playerName] = true
    
    addPlayerRoundTimer(name, function(i)
      if i == 1 then
        if not playerInGame[playerName] then isPlayerDead[playerName] = false; return end
        tfm.exec.respawnPlayer(playerName)

        if gameStats.teamsMode then
          teleportOnePlayerTeamsMode(playerName)
        elseif gameStats.threeTeamsMode then
          teleportOnePlayerThreeTeamsMode(playerName)
        else
          teleportOnePlayer(playerName)
        end
        isPlayerDead[playerName] = false
      end
    end, 5000, 1, "deadTimer")
  end
end
