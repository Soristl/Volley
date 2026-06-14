function eventPlayerDied(name)
  local playerName = name
  if playerInGame[playerName] and gameStats.canTransform and not playerPressSpace[name] then
    isPlayerDead[playerName] = true
    
    addTimer(function(i) 
      if i == 1 then
        tfm.exec.respawnPlayer(playerName)

        if gameStats.teamsMode then
          teleportOnePlayerTeamsMode(playerName)

          isPlayerDead[playerName] = false

          return
        end

        if gameStats.threeTeamsMode then
          teleportOnePlayerThreeTeamsMode(playerName)

          isPlayerDead[playerName] = false

          return
        end

        teleportOnePlayer(playerName)

        isPlayerDead[playerName] = false
      end
    end, 5000, 1, "deadTimer")
  end
end