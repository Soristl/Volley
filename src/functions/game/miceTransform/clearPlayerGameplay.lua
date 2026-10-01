function clearPlayerGameplay(name)
  local ground = playerPhysicId[name]
  if ground and ground > 0 then tfm.exec.removePhysicObject(ground) end
  playerPhysicId[name] = 0
  for _, id in ipairs(playerConsumables[name] or {}) do
    if tfm.get.room.objectList[id] then tfm.exec.removeObject(id) end
  end
  playerConsumables[name] = nil
  playerPressSpace[name] = false
  playerCanTransform[name] = true
  playerConsumable[name] = true
  isPlayerDead[name] = false
  playerOutOfCourt[name] = false
  showOutOfCourtText[name] = false
end

function clearMapPlayerGameplay()
  for name in pairs(tfm.get.room.playerList) do
    clearPlayerTimers(name)
    clearPlayerGameplay(name)
  end
end
