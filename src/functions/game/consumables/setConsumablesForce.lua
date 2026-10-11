function playerRuntime.setConsumableForce(key, playerMove)
  local speedX = 0
  local speedY = 0
  local yCoord = 0

  if key == 55 or key == 48 then
    yCoord = -65
    if playerMove == 0 then
      speedX = -10
    elseif playerMove == 2 then
      speedX = 10
    end
  elseif key == 57 then
    yCoord = -65
    speedY = -5

    if playerMove == 0 then
      speedX = -5
    elseif playerMove == 2 then
      speedX = 5
    end
  end
  return { speedX, speedY, yCoord }
end

do
  local CONSUMABLES = {
    [55] = { id = 65, name = "pufferfish" },
    [56] = { id = 80, name = "paper plane" },
    [57] = { id = 6, name = "ball" },
    [48] = { id = 34, name = "snow ball" }
  }

  function playerRuntime.handleConsumableInput(name, key, x, y, offsetX)
    -- 1. Selection via emote keys
    if KEYS.CONSUMABLES[key] then
      local cons = CONSUMABLES[key]
      playerState.consumables.key[name] = key
      playerState.consumables.item[name] = cons.id
      local msg = "<bv>You chose the consumable " .. cons.name .. "<n>"
      tfm.exec.chatMessage(msg, name)
    end

    -- 2. Spawning logic
    if key == KEYS.SPAWN_ITEM then
      if not playerState.consumables.ready[name] then
        tfm.exec.chatMessage("<bv>You need wait 5 seconds to spawn a new consumable<n>", name)
        return
      end

      -- Lock ability immediately to prevent frame-perfect spam
      playerState.consumables.ready[name] = false

      -- Cooldown reset (player-specific timer)
      timers.addPlayerRound(name, function()
        playerState.consumables.ready[name] = true
        tfm.exec.chatMessage("<bv>You can spawn a new consumable<n>", name)
      end, 5000, 1, "enablePlayerConsumable_" .. name)

      local speed = playerRuntime.setConsumableForce(playerState.consumables.key[name], playerState.lastDirection[name])

      -- Spawn object
      local spawnX = x + offsetX + (offsetX / 2)
      local id = tfm.exec.addShamanObject(playerState.consumables.item[name], spawnX, y + speed[3], 0, speed[1], speed[2], false)

      -- Auto-cleanup (player-specific queue)
      playerState.consumables.objects[name] = playerState.consumables.objects[name] or {}
      table.insert(playerState.consumables.objects[name], id)

      timers.addPlayerRound(name, function()
        local queue = playerState.consumables.objects[name]
        if queue and #queue > 0 then
          local removedId = table.remove(queue, 1)
          if removedId then tfm.exec.removeObject(removedId) end
        end
      end, 15000, 1, "removeShamanObject_" .. name)
    end
  end
end
