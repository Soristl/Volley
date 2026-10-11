function playerRuntime.clearGameplay(name)
  local ground = playerState.physicId[name]
  if ground and ground > 0 then tfm.exec.removePhysicObject(ground) end
  playerState.physicId[name] = 0
  for _, id in ipairs(playerState.consumables.objects[name] or {}) do
    if tfm.get.room.objectList[id] then tfm.exec.removeObject(id) end
  end
  playerState.consumables.objects[name] = nil
  playerState.pressSpace[name] = false
  playerState.canTransform[name] = true
  playerState.consumables.ready[name] = true
  playerState.dead[name] = false
  playerState.outOfCourt[name] = false
  playerState.outOfCourtText[name] = false
end

function playerRuntime.clearMapGameplay()
  for name in pairs(tfm.get.room.playerList) do
    timers.clearPlayer(name)
    playerRuntime.clearGameplay(name)
  end
end

function playerRuntime.removeBannedPlayer(target)
  if gameState.phase == "startGame" then
    gameTeams.releaseLobbySeat(target)
  elseif gameState.match.mode.teamsMode or gameState.match.mode.threeTeamsMode then
    -- Remove membership even during a terrain transition.
    gameTeams.leaveMulti(target)
  else
    gameTeams.leaveStandard(target)
  end

  -- Host departure can arrive later. Cancel both previous player work and
  -- the spectator respawn that leaving a team may just have scheduled.
  timers.clearPlayer(target)
  playerRuntime.clearGameplay(target)
  gameTeams.releaseSpawn(target)
end
