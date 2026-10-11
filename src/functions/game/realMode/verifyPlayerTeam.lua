do
local touchRules = {
  {team="red", quantity="redQuantitySpawn", limit="redLimitSpawn", server="redPlayerServe", last="lastPlayerRed"},
  {team="blue", quantity="blueQuantitySpawn", limit="blueLimitSpawn", server="bluePlayerServe", last="lastPlayerBlue"},
}

function realServe.canTouchBall(name)
  if playerState.outOfCourt[name] then return end

  -- Keep red before blue and read the current rosters after team changes.
  for _, rule in ipairs(touchRules) do
    local roster = gameState.teams[rule.team]
    for i = 1, #roster do
      if roster[i].name == name then
        local quantity, limit = gameState.match.real[rule.quantity], gameState.match.real[rule.limit]
        if quantity == limit then return false end
        if quantity < limit then
          if limit == 1 and name ~= gameState.match.real[rule.server] and gameState.match.real[rule.last] == name then
            return false
          end
          gameState.match.real[rule.quantity] = quantity + 1
          gameState.match.real[rule.last] = name
          clubhouse.showScores()
          return true
        end
      end
    end
  end
end
local FORCE_CONFIG = {
  [49] = { value = 0, msg = "Your strength changed to normal" },
  [50] = { value = -0.2, msg = "Your strength has been reduced by 20%" },
  [51] = { value = -0.45, msg = "Your strength has been reduced by 45%" },
  [52] = { value = -1, msg = "Your strength has been reduced by 100%" }
}

function realServe.handleInput(name, key, x)
  -- 1. Force Adjustment
  if KEYS.FORCE[key] then
    local cfg = FORCE_CONFIG[key]
    playerState.force[name] = cfg.value
    tfm.exec.chatMessage("<bv>" .. cfg.msg .. "<n>", name)
  end

  -- 2. Court Boundary & Timer Management
  local isOutOfBounds = (x <= 599 or x >= 2001)

  if isOutOfBounds then
    if not playerState.outOfCourt[name] and not playerState.outOfCourtText[name] then
      playerState.outOfCourtText[name] = true
      local warning =
      "<bv>you are outside the court you have 7 seconds to make an action, otherwise you will not be able to use the TRANSFORM key outside the court<n>"
      tfm.exec.chatMessage(warning, name)
      timers.addPlayerRound(name, function() playerState.outOfCourt[name] = true end, 7000, 1, "delay_" .. name)
    end
  else
    timers.remove("delay_" .. name)
    playerState.outOfCourtText[name] = false
    playerState.outOfCourt[name] = false
  end

  -- 3. Serve Permission Check
  if (gameState.match.real.redServe and name ~= gameState.match.real.redPlayerServe) or
      (gameState.match.real.blueServe and name ~= gameState.match.real.bluePlayerServe) then
    return false -- Block further execution
  end

  return true -- Allow execution to continue
end

-- A refused real-mode transform returns nil; zero remains a valid force.
function realServe.prepareTransformForce(name, x, y)
  local additionalForce = 0

  -- 1. Calculate launch force based on real-mode state
  -- NOTE: Conditions are evaluated top-down. Later matches override earlier ones.
  if gameState.match.mode.realMode then
    local team = gameTeams.findRealMember(name)
    local canSpawn = realServe.canTouchBall(name)
    if not canSpawn then return end

    -- Base team force
    if team == "red" and gameState.match.real.redQuantitySpawn >= 0 then
      additionalForce = playerState.force[name]
    elseif team == "blue" and gameState.match.real.blueQuantitySpawn >= 0 then
      additionalForce = playerState.force[name]
    end

    -- Serve override (consumes serve state & sets fixed force)
    if gameState.match.real.redServe then
      gameState.match.real.redServe = false
      additionalForce = 0.34
    elseif gameState.match.real.blueServe then
      gameState.match.real.blueServe = false
      additionalForce = 0.34
    end

    -- Max spawn quantity override
    if gameState.match.real.redQuantitySpawn == 3 then
      additionalForce = 0.2 + playerState.force[name]
    elseif gameState.match.real.blueQuantitySpawn == 3 then
      additionalForce = 0.2 + playerState.force[name]
    end

    -- Ace penalty override
    if gameState.match.real.reduceForce and team == gameState.match.real.teamWithOutAce then
      gameState.match.real.reduceForce = false
      additionalForce = -0.45 + playerState.force[name]
    end

    -- Check proximity to ball for gameplay triggers
    realServe.recordNearbyTouch(name, x, y)
  end
  return additionalForce
end
end
