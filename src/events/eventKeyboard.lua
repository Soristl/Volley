do
-- KEYS is shared with bindKeys and page input from configuration/keybinds.lua.
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

local TRANSFORM_TEAMS = {
  {key="red", color=0xEF4444},
  {key="blue", color=0x3B82F6},
  {key="yellow", color=0xF59E0B},
  {key="green", color=0x109267}
}

local function finiteNumber(value)
  return type(value) == "number" and value == value and value > -math.huge and value < math.huge
end

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
    addPlayerRoundTimer(name, function()
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

    addPlayerRoundTimer(name, function()
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
      addPlayerRoundTimer(name, function() playerOutOfCourt[name] = true end, 7000, 1, "delay_" .. name)
    end
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

local function getPlayerTransformColor(name)
  -- Remaining teams keep their colors when the court shrinks after elimination.
  if (gameStats.teamsMode or gameStats.threeTeamsMode)
    and (gameStats.typeMap == "large3v3" or gameStats.typeMap == "small") then
    for index, team in ipairs(teamsPlayersOnGame) do
      for _, player in ipairs(team) do
        if player.name == name then
          return gameTeams.color(gameTeams.keyAt(index)) or 0x81348A
        end
      end
    end
  end

  for _, team in ipairs(TRANSFORM_TEAMS) do
    for _, player in ipairs(gameState.teams[team.key]) do
      if player.name == name then return team.color end
    end
  end
  return 0x81348A
end

local function handlePlayerTransform(name, x, y, player, data)
  -- Validate before consuming a serve, killing the mouse or allocating a ground.
  local ping = player.ping or 10
  if not finiteNumber(data.transformDuration) or data.transformDuration < 0 or not finiteNumber(ping)
    or (gameStats.realMode and not finiteNumber(playerForce[name])) then return end
  local additionalForce = 0

  -- 1. Calculate launch force based on real-mode state
  -- NOTE: Conditions are evaluated top-down. Later matches override earlier ones.
  if gameStats.realMode then
    local team = searchPlayerTeam(name)
    local canSpawn = verifyPlayerTeam(name)
    if not canSpawn then return end

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
  playerPressSpace[name] = true
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
    color = getPlayerTransformColor(name),
    miceCollision = false,
    groundCollision = true
  })

  local groundId = playerPhysicId[name]

  -- 3. Schedule cleanup & respawn sequence (ping-compensated)
  -- Compensate for input latency: subtract ~1x ping from the base duration
  -- so high-ping clients perceive the same ~2s window as low-ping clients.
  -- Clamped to prevent timers from firing before network packets arrive.
  local transformDuration = data.transformDuration * 1000
  local transformCooldown = math.max(100, 400 - (ping / 2))

  addPlayerRoundTimer(name, function()
    tfm.exec.removePhysicObject(groundId)
    if playerPhysicId[name] == groundId then playerPhysicId[name] = 0 end
    playerPressSpace[name] = false
    tfm.exec.respawnPlayer(name)
    setCrownToPlayer(name)

    if playerInGame[name] then
      tfm.exec.movePlayer(name, x, y)
    end

    -- Re-enable transform ability after compensated cooldown
    addPlayerRoundTimer(name, function()
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
  if type(name) ~= "string" or not finiteNumber(key) or key % 1 ~= 0 or type(down) ~= "boolean"
    or playerBan[name] or playerLeft[name] then return end
  local player = tfm.get.room.playerList[name]
  local data = players[name]
  if type(player) ~= "table" or type(data) ~= "table" or type(data.offsets) ~= "table" then return end
  if lobbyTransition and lobbyTransition.blocksInput() then
    if key>=0 and key<=3 then playersAfk[name]=os.time() end
    return
  end
  if clubhouse.pageInputKey(name,key,down) then return end
  local offsets = data.offsets
  if not finiteNumber(x) or not finiteNumber(y) or not finiteNumber(xv) or not finiteNumber(yv)
    or not finiteNumber(offsets.x) or not finiteNumber(offsets.y) then return end
  if key == KEYS.PROFILE or key == KEYS.RANK then
    if not down then return end
    local closing=key==KEYS.PROFILE and isOpenProfile[name] or key==KEYS.RANK and openRank[name]
    if not clubhouse.allowInput(name,closing) then return end
  end

  -- 1. Movement & Offset Calculation
  local offsetX = (xv < 0 and -offsets.x) or (xv > 0 and offsets.x) or 0
  local offsetY = (yv < 0 and -offsets.y) or (yv > 0 and offsets.y) or 0

  player.x = offsetX + x
  player.y = offsetY + y

  -- 2. AFK Reset
  if key == 0 or key == 1 or key == 2 or key == 3 then
    playersAfk[name] = os.time()
  end

  -- 3. Profile Key (P)
  if key == KEYS.PROFILE then
    -- Capture state BEFORE cleanUpUI (removeUITrophies resets isOpenProfile)
    local wasOpen = isOpenProfile[name]

    -- Closing is instant; opening has a 2s anti-spam cooldown (spamming crashed the script)
    if wasOpen then
      removeUITrophies(name)
      return
    end
    if profileKeyTime[name] and os.time() - profileKeyTime[name] < 2000 then return end
    profileKeyTime[name] = os.time()

    cleanUpUI(name)
    profileUI(name, name)
    return
  end

  -- 4. Rank Key (L)
  if key == KEYS.RANK then
    if openRank[name] then
      closeRankingUI(name)
    else
      openRankingUI(name)
    end
    return
  end

  -- 5. Game-Specific Logic
  if not playerInGame[name] or gameState.phase ~= "gameStart" or gameStats.isGamePaused or not isGameplayMapReady() then return end

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
    if not handleRealMode(name, key, x) then return end
  end

  if key == KEYS.TRANSFORM and gameStats.canTransform and playerCanTransform[name] and not playerOutOfCourt[name] and not isPlayerDead[name] then
    handlePlayerTransform(name, player.x, player.y, player, data)
  end
end
end
