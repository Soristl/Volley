do
-- KEYS is shared with bindKeys and page input from configuration/keybinds.lua.
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
  clubhouse.closeWindows(name)
end

local function scheduleTransformRecovery(name, x, y, groundId, data, ping)
  -- 3. Schedule cleanup & respawn sequence (ping-compensated)
  -- Compensate for input latency: subtract ~1x ping from the base duration
  -- so high-ping clients perceive the same ~2s window as low-ping clients.
  -- Clamped to prevent timers from firing before network packets arrive.
  local transformDuration = data.transformDuration * 1000
  local transformCooldown = math.max(100, 400 - (ping / 2))

  timers.addPlayerRound(name, function()
    tfm.exec.removePhysicObject(groundId)
    if playerState.physicId[name] == groundId then playerState.physicId[name] = 0 end
    playerState.pressSpace[name] = false
    tfm.exec.respawnPlayer(name)
    gameCrowns.showPlayer(name)

    if playerState.inGame[name] then
      tfm.exec.movePlayer(name, x, y)
    end

    -- Re-enable transform ability after compensated cooldown
    timers.addPlayerRound(name, function()
      playerState.canTransform[name] = true
    end, transformCooldown, 1, "delayOnTransform_" .. name)
  end, transformDuration, 1, "removeGround_" .. name)
end

local function handlePlayerTransform(name, x, y, player, data)
  -- Validate before consuming a serve, killing the mouse or allocating a ground.
  local ping = player.ping or 10
  if not finiteNumber(data.transformDuration) or data.transformDuration < 0 or not finiteNumber(ping)
    or (gameState.match.mode.realMode and not finiteNumber(playerState.force[name])) then return end
  local additionalForce = realServe.prepareTransformForce(name, x, y)
  if additionalForce == nil then return end

  -- 2. Execute transformation
  playerState.pressSpace[name] = true
  playerState.canTransform[name] = false
  playerState.physicId[name] = playerState.nextGroundId
  tfm.exec.killPlayer(name)

  -- Spawn physics object at updated player position
  local height = name.height or 20
  local width = name.width or 20

  tfm.exec.addPhysicObject(playerState.physicId[name], x, y, {
    type = 13,
    width = width,
    height = height,
    restitution = gameState.match.rules.physicObjectForce + additionalForce,
    friction = 0,
    color = gameTeams.transformColor(name),
    miceCollision = false,
    groundCollision = true
  })

  local groundId = playerState.physicId[name]

  scheduleTransformRecovery(name, x, y, groundId, data, ping)

  -- 4. Increment global physics object ID counter
  playerState.nextGroundId = playerState.nextGroundId + 1
end

local function handleSkills(name, key, x, y)
  return
end

local function handleInterfaceShortcut(name, key)
  -- 3. Profile Key (P)
  if key == KEYS.PROFILE then
    -- Capture state BEFORE cleanUpUI (clubhouse.closeProfile resets isOpenProfile)
    local wasOpen = uiState.isOpenProfile[name]

    -- Closing is instant; opening has a 2s anti-spam cooldown (spamming crashed the script)
    if wasOpen then
      clubhouse.closeProfile(name)
      return true
    end
    if not panelInput.consumeProfileOpening(name) then return true end

    cleanUpUI(name)
    clubhouse.profile(name, name)
    return true
  end

  -- 4. Rank Key (L)
  if key == KEYS.RANK then
    if uiState.openRank[name] then
      clubhouse.closeRanking(name)
    else
      clubhouse.openRanking(name)
    end
    return true
  end
  return false
end

local function handleGameplayKey(name, key, x, y, offsetX, player, data)
  -- 5. Game-Specific Logic
  if not playerState.inGame[name] or gameState.phase ~= "gameStart" or gameState.match.round.isGamePaused or not mapLoad.isReady() then return end

  -- Track direction
  if gameState.match.rules.skillsTree then
    handleSkills(name, key, x, y)
  end

  if KEYS.LEFT == key or KEYS.RIGHT == key then
    playerState.lastDirection[name] = key
  end

  if gameState.match.rules.consumables and not gameState.match.mode.teamsMode and not gameState.match.mode.twoTeamsMode and not gameState.match.mode.realMode then
    playerRuntime.handleConsumableInput(name, key, x, y, offsetX)
  end

  if gameState.match.mode.realMode then
    if not realServe.handleInput(name, key, x) then return end
  end

  if key == KEYS.TRANSFORM and gameState.match.round.canTransform and playerState.canTransform[name] and not playerState.outOfCourt[name] and not playerState.dead[name] then
    handlePlayerTransform(name, player.x, player.y, player, data)
  end
end

--[[
  This hook probably is not
  the main cause of lag, but
  still need some cleanup
  -- Vit0rg
]]
function eventKeyboard(name, key, down, x, y, xv, yv)
  if type(name) ~= "string" or not finiteNumber(key) or key % 1 ~= 0 or type(down) ~= "boolean"
    or playerState.ban[name] or playerState.left[name] then return end
  local player = tfm.get.room.playerList[name]
  local data = playerState.data[name]
  if type(player) ~= "table" or type(data) ~= "table" or type(data.offsets) ~= "table" then return end
  if lobbyTransition and lobbyTransition.blocksInput() then
    if key>=0 and key<=3 then playerState.afk[name]=os.time() end
    return
  end
  if clubhouse.pageInputKey(name,key,down) then return end
  local offsets = data.offsets
  if not finiteNumber(x) or not finiteNumber(y) or not finiteNumber(xv) or not finiteNumber(yv)
    or not finiteNumber(offsets.x) or not finiteNumber(offsets.y) then return end
  if key == KEYS.PROFILE or key == KEYS.RANK then
    if not down then return end
    local closing=key==KEYS.PROFILE and uiState.isOpenProfile[name] or key==KEYS.RANK and uiState.openRank[name]
    if not clubhouse.allowInput(name,closing) then return end
  end

  -- 1. Movement & Offset Calculation
  local offsetX = (xv < 0 and -offsets.x) or (xv > 0 and offsets.x) or 0
  local offsetY = (yv < 0 and -offsets.y) or (yv > 0 and offsets.y) or 0

  player.x = offsetX + x
  player.y = offsetY + y

  -- 2. AFK Reset
  if key == 0 or key == 1 or key == 2 or key == 3 then
    playerState.afk[name] = os.time()
  end

  if handleInterfaceShortcut(name, key) then return end

  handleGameplayKey(name, key, x, y, offsetX, player, data)
end
end
