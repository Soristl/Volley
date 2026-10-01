function commandHandlers.cmdBroadcast(args)
  local name = args[1]

  -- args[1] = player name, args[#args] = command name, message = args[2..#args-1]
  if #args < 3 then return end

  local text = table.concat(args, " ", 2, #args - 1)

  local message = "<vi>[#Volley Announcement]: " .. text

  if USER_PERMISSIONS[name] and USER_PERMISSIONS[name] > 2 then
    tfm.exec.chatMessage(message, nil)
  end
end
function commandHandlers.cmdPromoteInactivePerm(args)
  local name = args[1]

  -- If already an active permanent admin, do nothing
  if USER_PERMISSIONS[name] == 5 then return end

  if USER_PERMISSIONS[name] == 4 then
    USER_PERMISSIONS[name] = 5
    tfm.exec.chatMessage("<vi>" ..
      "You reactivated permanent admin powers<n> ",
      name)
    return
  end
end
function commandHandlers.cmdKick(args)
  local name = args[1]
  if #args ~= 3 then
    tfm.exec.chatMessage('<j>Usage: !kick Player#0000<n>', name)
    return
  end
  local target = commandHandlers.resolveAdminTarget(args[2])
  if not target or not tfm.get.room.playerList[target] or playerLeft[target] then
    tfm.exec.chatMessage('<j>Player not found or already departed.<n>', name)
    return
  end

  if USER_PERMISSIONS[target] ~= nil and USER_PERMISSIONS[target] > 3 then return end

  tfm.exec.kickPlayer(target)
  tfm.exec.chatMessage("<vi>" .. name .. " kicked " .. target .. " <n> ", nil)
end

-- The main leave functions needs to be
-- unified into just one single function.
-- There is absolutely no need to keep separated
-- functions instead of using the gameStats to
-- change behaviour.
-- @Vit0rg

function commandHandlers.cmdForceLeave(args)
  local name = args[1]
  if #args ~= 3 then
    tfm.exec.chatMessage('<j>Usage: !fleave Player#0000<n>', name)
    return
  end
  local target = commandHandlers.resolveAdminTarget(args[2])
  if not target or not tfm.get.room.playerList[target] or playerLeft[target] then
    tfm.exec.chatMessage('<j>Player not found or already departed.<n>', name)
    return
  end

  if gameState.phase ~= "gameStart" or not target or (USER_PERMISSIONS[target] or 1) == 5 then
    return
  end
  if not gameTeams.find(target) then
    tfm.exec.chatMessage('<j>This player is not in a team.<n>', name)
    return
  end

  if (gameStats.teamsMode or gameStats.threeTeamsMode) and
      gameStats.canTransform then
    leaveTeamTeamsMode(target)
    tfm.exec.chatMessage("<vi>" .. target .. " force leave by " .. name ..
      " <n> ", nil)
    return
  end

  if not gameStats.teamsMode and not gameStats.threeTeamsMode then
    leaveTeam(target);
    return tfm.exec.chatMessage("<vi>" .. target .. " force leave by " ..
      name .. " <n> ", nil)
  end

  tfm.exec.chatMessage("<vi>Force leave disabled<n> ", name)
end

function commandHandlers.resolveBanTarget(target)
  local known = commandHandlers.resolveAdminTarget(target)
  if known then return known end
  local lowerTarget = target:lower()
  for player in pairs(playerBan) do
    if player:lower() == lowerTarget then return player end
  end
  -- Preserve the ability to ban an explicitly named offline player.
  return target
end

function commandHandlers.cmdBan(args)
  local name = args[1]
  if #args ~= 3 then
    tfm.exec.chatMessage('<j>Usage: !ban Player#0000<n>', name)
    return
  end
  local target = commandHandlers.resolveBanTarget(args[2])

  if not gameStats.banCommandIsEnabled or not target or
      (USER_PERMISSIONS[target] or 1) > 3 then
    return
  end

  -- target must be attached to an id.
  playerBan[target] = true
  playerBanHistory[target] = name
  if tfm.get.room.playerList[target] and not playerLeft[target] then
    tfm.exec.chatMessage("<vi>Banned by " .. name .. " <n> ", target)
    tfm.exec.kickPlayer(target)
  end
  tfm.exec.chatMessage("<vi>" .. name .. " banned " .. target .. " <n> ", nil)
  if not tfm.get.room.playerList[target] or playerLeft[target] then return end

  if gameState.phase == "startGame" then
    updateLobbyTexts(target)
  elseif gameStats.teamsMode or gameStats.threeTeamsMode then
    -- Remove membership even during a terrain transition.
    leaveTeamTeamsMode(target)
  else
    leaveTeam(target)
  end

  -- Host departure can arrive later. Cancel both previous player work and
  -- the spectator respawn that leaving a team may just have scheduled.
  clearPlayerTimers(target)
  clearPlayerGameplay(target)
  removePlayerOnSpawnConfig(target)
end

function commandHandlers.cmdUnban(args)
  local name = args[1]
  if #args ~= 3 then
    tfm.exec.chatMessage('<j>Usage: !unban Player#0000<n>', name)
    return
  end
  local target = commandHandlers.resolveBanTarget(args[2])

  if not target or not playerBan[target] then return end

  playerBan[target] = false
  tfm.exec
      .chatMessage("<vi>" .. name .. " unbanned " .. target .. " <n> ", nil)
end

function commandHandlers.cmdStopTimer(args)
  local name = args[1]
  if gameState.phase ~= "startGame" then return end

  if not gameStats.stopTimer then
    gameStats.stopTimer = true
    tfm.exec.chatMessage("<vi>Stoptimer enabled by " .. name .. " <n> ", nil)
    return
  end

  gameState.lobbyDeadline = os.time() + (gameStats.initTimer * 1000)
  gameStats.stopTimer = false
  tfm.exec.chatMessage("<vi>Stoptimer disabled by " .. name .. " <n> ", nil)
end

function commandHandlers.cmdKillSpec(args)
  local name = args[1]
  local kill = args[2]

  if kill ~= "true" and kill ~= "false" then
    tfm.exec
        .chatMessage('<j>Second argument must be true or false<n>', name)
    return
  end

  killSpecPermanent = (kill == "true")
  gameStats.killSpec = killSpecPermanent

  if gameState.phase == "gameStart" and killSpecPermanent then
    for n, _ in pairs(tfm.get.room.playerList) do
      if not playerInGame[n] then tfm.exec.killPlayer(n) end
    end
  elseif gameState.phase == "gameStart" and isGameplayMapReady() then
    -- Revive only dead spectators; active players keep their own respawn delay.
    -- During loading, the normal map placement restores spectators instead.
    teleportPlayersToSpec(true)
  end
end

function commandHandlers.cmdPause(args)
  local name = args[1]
  if gameState.phase ~= "gameStart" or gameStats.realMode then return end

  if not gameStats.isGamePaused then
    if not isGameplayMapReady() or not gameStats.canTransform then
      tfm.exec.chatMessage('<j>Wait until the court is ready before pausing.<n>', name)
      return
    end
    gameStats.isGamePaused = true
    setGameplayTimersPaused(true)

    gameBalls.clear()

    tfm.exec.chatMessage("<vi>Game paused by " .. name .. " <n> ", nil)
    durationTimerPause = math.max(0, math.ceil((duration - os.time()) / 1000))
    return
  end

  duration = os.time() + durationTimerPause * 1000
  tfm.exec.setGameTime(durationTimerPause, true)
  gameStats.isGamePaused = false
  setGameplayTimersPaused(false)
  -- A departure during pause may have queued a reduced court. Its map
  -- preparation owns the next ball; do not spawn one on the old terrain.
  if isGameplayMapReady() and gameStats.canTransform then spawnInitialBall() end
end
