function leaveConfigRealMode(name)
  local quantity = quantityPlayers()

  local team = searchPlayerTeam(name)

  if team == "red" and gameStats.redServe then
    gameStats.aceRed = false
    if quantity.red >= 1 then
      tfm.exec.chatMessage("<ce>[System]: player who was going to serve has left, the system will choose another player to serve<n>", nil)
      ballOnGame = false
      gameStats.canTransform = false
      local delayTeleport = addTimer(function(i)
        if i == 1 then
          choosePlayerServe("red")
          teamServe("red")
        end
      end, 4000, 1, "delayTeleport")
      
      local delaySpawnBall = addTimer(function(i)
        if i == 1 then
          spawnBallRealMode("red")
        end
      end, 6000, 1, "delaySpawnBall")
    end
    
    return
  end

  if quantity.blue >= 1 and gameStats.blueServe then
    gameStats.aceBlue = false
    tfm.exec.chatMessage("<ce>[System]: player who was going to serve has left, the system will choose another player to serve<n>", nil)
    ballOnGame = false
    gameStats.canTransform = false
    local delayTeleport = addTimer(function(i)
      if i == 1 then
        choosePlayerServe("blue")
        teamServe("blue")
      end
    end, 4000, 1, "delayTeleport")
    
    local delaySpawnBall = addTimer(function(i)
      if i == 1 then
        spawnBallRealMode("blue")
      end
    end, 6000, 1, "delaySpawnBall")
  end
end