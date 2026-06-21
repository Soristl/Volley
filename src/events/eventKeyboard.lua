local KEYS = {
  LEFT        = 0,
  UP          = 1,
  RIGHT       = 2,
  DOWN        = 3,
  -- Z        = 90
  -- X        = 88
  -- C        = 67
  -- V        = 86
  -- AFK      = { [0] = true, [1] = true, [2] = true, [3] = true },
  PROFILE     = 80,
  RANK        = 76,
  TRANSFORM   = 32,
  CONSUMABLES = { [55] = true, [56] = true, [57] = true, [48] = true },
  FORCE       = { [49] = true, [50] = true, [51] = true, [52] = true },
  SPAWN_ITEM  = 77
}

local CONSUMABLES = {
  [55] = { id = 65, name = "pufferfish" },
  [56] = { id = 80, name = "paper plane" },
  [57] = { id = 6, name = "ball" },
  [48] = { id = 34, name = "snow ball" }
}

local FORCE_CONFIG = {
  [49] = { value = 0, msg = "Your strength changed to normal" },
  [50] = { value = -0.2, msg = "Your strength has been reduced by 20%" },
  [51] = { value = -0.45, msg = "Your strength has been reduced by 45%" },
  [52] = { value = -1, msg = "Your strength has been reduced by 100%" }
}

--[[
  These helper functions should
  be into a proper folder.
  I also don't know why the windows
  are not into an enum or a lookup
  table
  -- Vit0rg
]]
local function cleanUpUI(name)
  closeAllWindows(name)
  closeRankingUI(name)
  removeButtons(25, name)
  removeButtons(26, name)
  removeUITrophies(name)
end

local function handleConsumables(name, key, x, y, offsetX)
  -- 1. Selection via emote keys
  if KEYS.CONSUMABLES[key] then
    local cons = CONSUMABLES[key]
    playerConsumableKey[name] = key
    playerConsumableItem[name] = cons.id
    local msg = "<bv>You chose the consumable " .. cons.name .. "<n>"
    tfm.exec.chatMessage(msg, name)
  end

  -- 2. Spawning logic
  if key == KEYS.SPAWN_ITEM then
    if not playerConsumable[name] then
      tfm.exec.chatMessage("<bv>You need wait 5 seconds to spawn a new consumable<n>", name)
      return
    end

    -- Lock ability immediately to prevent frame-perfect spam
    playerConsumable[name] = false

    -- Cooldown reset (player-specific timer)
    addTimer(function()
      playerConsumable[name] = true
      tfm.exec.chatMessage("<bv>You can spawn a new consumable<n>", name)
    end, 5000, 1, "enablePlayerConsumable_" .. name)

    local speed = setConsumablesForce(playerConsumableKey[name], playerLeftRight[name])

    -- Spawn object
    local spawnX = x + offsetX + (offsetX / 2)
    local id = tfm.exec.addShamanObject(playerConsumableItem[name], spawnX, y + speed[3], 0, speed[1], speed[2], false)

    -- Auto-cleanup (player-specific queue)
    playerConsumables[name] = playerConsumables[name] or {}
    table.insert(playerConsumables[name], id)

    addTimer(function()
      local queue = playerConsumables[name]
      if queue and #queue > 0 then
        local removedId = table.remove(queue, 1)
        if removedId then tfm.exec.removeObject(removedId) end
      end
    end, 15000, 1, "removeShamanObject_" .. name)
  end
end

local function handleRealMode(name, key, x)
  -- 1. Force Adjustment
  if KEYS.FORCE[key] then
    local cfg = FORCE_CONFIG[key]
    playerForce[name] = cfg.value
    tfm.exec.chatMessage("<bv>" .. cfg.msg .. "<n>", name)
  end

  -- 2. Court Boundary & Timer Management
  local isOutOfBounds = (x <= 599 or x >= 2001)

  if isOutOfBounds then
    if not playerOutOfCourt[name] and not showOutOfCourtText[name] then
      showOutOfCourtText[name] = true
      local warning =
      "<bv>you are outside the court you have 7 seconds to make an action, otherwise you will not be able to use the TRANSFORM key outside the court<n>"
      tfm.exec.chatMessage(warning, name)
    end
    addTimer(function() playerOutOfCourt[name] = true end, 7000, 1, "delay_" .. name)
  else
    removeTimer("delay_" .. name)
    showOutOfCourtText[name] = false
    playerOutOfCourt[name] = false
  end

  -- 3. Serve Permission Check
  if (gameStats.redServe and name ~= gameStats.redPlayerServe) or
      (gameStats.blueServe and name ~= gameStats.bluePlayerServe) then
    return false -- Block further execution
  end

  return true -- Allow execution to continue
end

local function handlePlayerTransform(name, x, y)
  local additionalForce = 0
  playerPressSpace[name] = true

  -- 1. Calculate launch force based on real-mode state
  -- NOTE: Conditions are evaluated top-down. Later matches override earlier ones.
  if gameStats.realMode then
    local team = searchPlayerTeam(name)
    local canSpawn = verifyPlayerTeam(name)

    -- Base team force
    if team == "red" and gameStats.redQuantitySpawn >= 0 then
      additionalForce = playerForce[name]
    elseif team == "blue" and gameStats.blueQuantitySpawn >= 0 then
      additionalForce = playerForce[name]
    end

    -- Serve override (consumes serve state & sets fixed force)
    if gameStats.redServe then
      gameStats.redServe = false
      additionalForce = 0.34
    elseif gameStats.blueServe then
      gameStats.blueServe = false
      additionalForce = 0.34
    end

    -- Block transformation if team spawn limit is reached
    if not canSpawn then return end

    -- Max spawn quantity override
    if gameStats.redQuantitySpawn == 3 then
      additionalForce = 0.2 + playerForce[name]
    elseif gameStats.blueQuantitySpawn == 3 then
      additionalForce = 0.2 + playerForce[name]
    end

    -- Ace penalty override
    if gameStats.reduceForce and team == gameStats.teamWithOutAce then
      gameStats.reduceForce = false
      additionalForce = -0.45 + playerForce[name]
    end

    -- Check proximity to ball for gameplay triggers
    playerNearOfTheBall(name, x, y)
  end

  -- 2. Execute transformation
  playerCanTransform[name] = false
  playerPhysicId[name] = countId
  tfm.exec.killPlayer(name)

  -- Spawn physics object at updated player position
  local height = name.height or 20
  local width = name.width or 20

  tfm.exec.addPhysicObject(playerPhysicId[name], x, y, {
    type = 13,
    width = width,
    height = height,
    restitution = gameStats.physicObjectForce + additionalForce,
    friction = 0,
    color = 0x81348A,
    miceCollision = false,
    groundCollision = true
  })

  local groundId = playerPhysicId[name]

  -- 3. Schedule cleanup & respawn sequence (ping-compensated)
  local ping = tfm.get.room.playerList[name].ping or 10
  -- Compensate for input latency: subtract ~1x ping from the base duration
  -- so high-ping clients perceive the same ~2s window as low-ping clients.
  -- Clamped to prevent timers from firing before network packets arrive.
  local transformDuration = players[name].transformDuration * 1000
  local transformCooldown = math.max(100, 400 - (ping / 2))

  print(transformDuration)

  addTimer(function()
    tfm.exec.removePhysicObject(groundId)
    playerPressSpace[name] = false
    tfm.exec.respawnPlayer(name)
    setCrownToPlayer(name)

    if playerInGame[name] then
      tfm.exec.movePlayer(name, x, y)
    end

    -- Re-enable transform ability after compensated cooldown
    addTimer(function()
      playerCanTransform[name] = true
    end, transformCooldown, 1, "delayOnTransform_" .. name)
  end, transformDuration, 1, "removeGround_" .. name)

  -- 4. Increment global physics object ID counter
  countId = countId + 1
end

local function handleSkills(name, key, x, y)
  return
end

--[[
  This hook probably is not
  the main cause of lag, but
  still need some cleanup
  -- Vit0rg
]]
function eventKeyboard(name, key, down, x, y, xv, yv)
  -- Shouldn't the player data be memoized?
  local player = tfm.get.room.playerList[name]
  if not player then return end

  -- 1. Movement & Offset Calculation
  local _offsets = { x = players[name].offsets.x, y = players[name].offsets.y }
  local offsetX = (xv < 0 and -_offsets.x) or (xv > 0 and _offsets.x) or 0
  local offsetY = (yv < 0 and -_offsets.y) or (yv > 0 and _offsets.y) or 0

  player.x = offsetX + x
  player.y = offsetY + y

  -- 2. AFK Reset
  if KEYS[key] then
    playersAfk[name] = os.time()
    -- Why this UI cleanup is here?
    removePlayerTrophy(name)
  end

  -- 3. Profile Key (P)
  if key == KEYS.PROFILE then
    cleanUpUI(name)
    if isOpenProfile[name] then
      closeWindow(24, name)
      closeWindow(25, name)
      return
    end
    profileUI(name, name)
    return
  end

  -- 4. Rank Key (L)
  if key == KEYS.RANK then
    if openRank[name] then
      openRank[name] = false
      cleanUpUI(name)
      ui.removeTextArea(99992, name)
      closeWindow(266, name)
    else
      openRank[name] = true
      ui.addWindow(24, "<p align='center'><font size='16px'>", name, 125, 60, 650, 300, 1, false, true,
        playerLanguage[name].tr.closeUIText)
      ui.addTextArea(9999543, "<p align='center'>Room Ranking", name, 17, 168, 100, 20, 0x142b2e, 0x8a583c, 1, true)
      ui.addTextArea(9999544, "<p align='center'><n2>Global Ranking<n>", name, 17, 268, 100, 18, 0x142b2e, 0x8a583c, 1,
        true)
      showMode(playerRankingMode[name], name)
    end
    return
  end

  -- 5. Game-Specific Logic
  if not playerInGame[name] or mode ~= "gameStart" then return end

  -- Track direction
  if gameStats.skillsTree then
    handleSkills(name, key, x, y)
  end

  if KEYS.LEFT == key or KEYS.RIGHT == key then
    playerLeftRight[name] = key
  end

  if gameStats.consumables and not gameStats.teamsMode and not gameStats.twoTeamsMode and not gameStats.realMode then
    handleConsumables(name, key, x, y, offsetX)
  end

  if gameStats.realMode then
    handleRealMode(name, key, x)
  end

  if key == KEYS.TRANSFORM and gameStats.canTransform and playerCanTransform[name] and not playerOutOfCourt[name] and not isPlayerDead[name] then
    handlePlayerTransform(name, player.x, player.y)
  end
end
