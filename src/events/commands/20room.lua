function commandHandlers.cmdTest(args)
  local name = args[1]
  -- not tfm.get.room.isTribeHouse
  -- Removed tribeHouse check, because some
  -- players still do wanna play alone on
  -- empty or dead rooms. @Vit0rg
  if gameState.phase ~= "startGame" then return end

  gameState.teams.red[1].name = "a"
  gameState.teams.blue[1].name = "a"
  gameState.teams.red[2].name = "a"
  gameState.teams.blue[2].name = "a"
  gameState.teams.green[1].name = "a"

  -- Maybe this will break, but the table initialization
  -- was redundant. @Vit0rg
  gameState.teams.yellow[1].name = "a"
  clubhouse.renderLobby()
end

function commandHandlers.cmdNP(args)
  local name = args[1]
  if not tfm.get.room.isTribeHouse or gameState.phase ~= "startGame" then return end

  if gameState.match.mode.realMode or gameState.match.maps.setMapName == "extra-large" then
    tfm.exec.chatMessage(" <j>Not available in this mode<n> ", name)
    return
  end

  local defaultMap = (gameState.match.mode.threeTeamsMode and
        customMapsThreeTeamsMode[1][2]) or
      (gameState.match.mode.teamsMode and
        customMapsFourTeamsMode[34][2]) or
      customMaps[6][1]


  if commandHandlers.validateMap({ name, args[2], 1 }) then
    gameMaps.setTestMap(1, args[2])
  else
    gameMaps.setTestMap(1, defaultMap)
  end

  if commandHandlers.validateMap({ name, args[3], 2 }) then
    gameMaps.setTestMap(2, args[3])
  else
    gameMaps.setTestMap(2, defaultMap)
  end

  if commandHandlers.validateMap({ name, args[4], 3 }) then
    gameMaps.setTestMap(3, args[4])
  else
    gameMaps.setTestMap(3, customMapsFourTeamsMode[34][5])
  end

  gameMaps.announceTestMaps()
  tfm.exec.chatMessage("<vp>Test map(s) loaded<n> ", nil)
end

-- ADMIN COMMANDS
function commandHandlers.cmdAutoSyncSystem(args)
  local name = args[1]
  local toggle = args[2]

  if toggle ~= "true" and toggle ~= "false" then
    tfm.exec.chatMessage('<bv>Must be true or false<n>', name)
    return
  end

  roomConfig.autoSync = (toggle == "true")
  tfm.exec.chatMessage("<n>Auto Sync System " ..
    (roomConfig.autoSync and "<vp>enabled<n2>" or
      "<r>disabled<n2>") .. " by " .. name .. " <n> ",
    nil)

end

function commandHandlers.cmdSync(args)
  local name = args[1]

  -- Auto-sync to lowest latency
  if #args == 2 then
    roomSync.refresh(name)
    return
  end

  -- Manual sync
  if (roomConfig.permissions[name] < 3) then return end

  -- Using a global player list copy would make the lookup so
  -- much better. @Vit0rg
  local target = args[2] or ""
  if target == "" then return end

  for n, _ in pairs(tfm.get.room.playerList) do
    if string.lower(n) == string.lower(target) then
      if not roomSync.requestPlayer(n, name) then return end
      tfm.exec.chatMessage("<vi>Sync set to " .. n .. " by " .. name ..
        " <n> ", nil)
      break
    end
  end
end

function commandHandlers.cmdLobby(args)
  local name = args[1]

  -- Keep recovery available during map loading, serve preparation and pause.
  -- The command dispatcher still enforces permissions.
  if gameState.phase ~= "gameStart" and gameState.phase ~= "showRules" then return end

  gameBalls.clear()

  timers.remove('verifyBallCoordinates')

  -- Cleanup UI
  ui.removeTextArea(0)
  ui.removeTextArea(1)
  ui.removeTextArea(899899)
  ui.removeTextArea(8998991)

  matchLifecycle.finishMatch()

  -- One single state variable holding the mode
  -- name would prevent this crime against the
  -- computers.
  -- Also, there is no need to update rankings
  -- in the case that the match was suspended.
  -- @Vit0rg

  -- if gameStats.teamsMode then
  --   updateRankingFourTeamsMode()
  -- elseif gameStats.threeTeamsMode then
  --   updateRankingThreeTeamsMode()
  -- elseif gameStats.twoTeamsMode then
  --   updateRankingTwoTeamsMode()
  -- elseif gameStats.realMode then
  --   updateRankingRealMode()
  -- else
  --   updateRankingNormalMode()
  -- end

  tfm.exec.chatMessage("<bv>Lobby reset by " .. name ..
    ". Restarting in 5s<n> ", nil)
end

function commandHandlers.cmdResetTimer(args)
  local name = args[1]
  if gameState.phase ~= "startGame" then return end

  gameState.lobbyDeadline = os.time() + 15000
  tfm.exec.chatMessage("<bv>resettimer enabled by " .. name .. " <n> ", nil)
end

function commandHandlers.cmdSkipTimer(args)
  local name = args[1]
  if gameState.phase ~= "startGame" then return end

  gameState.lobbyDeadline = os.time() + 5000
  tfm.exec.chatMessage(" <bv>skiptimer enabled by " .. name .. " <n> ", nil)
end

function commandHandlers.cmdSetDuration(args)
  local name = args[1]
  local durationSec = #args == 2 and gameRound.defaultDuration() or tonumber(args[2])
  if not durationSec or durationSec ~= durationSec or durationSec < 1 or durationSec % 1 ~= 0
      or durationSec * 1000 == math.huge then
    tfm.exec.chatMessage("<j>Usage: !setduration <positive integer seconds>; omit to reset.<n>", name)
    return
  end
  gameRound.setDuration(durationSec)
  tfm.exec.chatMessage("<bv>Duration set to " .. durationSec .. "s by " .. name .. "<n>", nil)
end

function commandHandlers.cmdSetMaxPlayers(args)
  local name = args[1]
  local maxPlayers = tonumber(args[2])

  if not maxPlayers then return end

  maxPlayers = math.abs(math.floor(maxPlayers))
  if maxPlayers >= 6 and maxPlayers <= 20 then
    tfm.exec.setRoomMaxPlayers(maxPlayers)
    tfm.exec.chatMessage("<bv>" ..
      playerState.language[name].tr.messageSetMaxPlayers ..
      " " .. maxPlayers .. " by " .. name .. " <n> ",
      nil)
  else
    tfm.exec.chatMessage(playerState.language[name].tr.messageMaxPlayersAlert,
      name)
  end
end

function commandHandlers.cmdSetMap(args)
  local name = args[1]
  local mapType = args[2]

  if gameState.phase ~= "startGame" then return end

  if gameState.match.mode.teamsMode or gameState.match.mode.twoTeamsMode or gameState.match.mode.threeTeamsMode or gameState.match.mode.realMode then
    roomConfig.commandUnavailable({ "setmap", name })
    return
  end

  if mapType ~= "small" and mapType ~= "large" and mapType ~= "extra-large" then
    tfm.exec.chatMessage(
      " <bv>Invalid map size: small, large, or extra-large<n> ", name)
    return
  end

  gameMaps.resetTestMaps()

  gameState.match.maps.setMapName = mapType
  gameMaps.refreshSizeSelection()
  tfm.exec.chatMessage(" <bv>" .. mapType .. " map selected by " .. name ..
    " <n> ", nil)
end

function commandHandlers.cmdWinScore(args)
  local name = args[1]
  local winscore = tonumber(args[2])
  if not winscore or winscore ~= winscore or winscore == math.huge or winscore < 1 or winscore % 1 ~= 0 then
    tfm.exec.chatMessage("<j>Usage: !winscore <positive integer><n>", name)
    return
  end
  if gameState.match.mode.teamsMode or gameState.match.mode.threeTeamsMode then return end
  if gameState.phase == "startGame" then
    if gameState.match.mode.realMode then return end
  elseif gameState.phase ~= "gameStart" or (roomConfig.permissions[name] or 1) < 3 then
    return
  end
  if winscore <= gameState.scores.red or winscore <= gameState.scores.blue then
    tfm.exec.chatMessage("<j>Winscore must exceed both teams' scores.<n>", name)
    return
  end
  gameState.match.rules.winscore = winscore
  tfm.exec.chatMessage("<bv>Winscore changed to <j>" .. winscore .. "<n2> by " .. name .. "<n>", nil)
end

function commandHandlers.cmdSetScore(args)
  if gameState.phase ~= "gameStart" then return end

  local name = args[1]
  local target = args[2]
  local newScore = tonumber(args[3])

  if not target
     or (gameState.match.mode.teamsMode or gameState.match.mode.threeTeamsMode) then
    return
  end

  -- Team Score
  local targets = { ['red'] = '<r>', ['blue'] = '<bv>' }

  if gameState.match.mode.teamsMode and (roomConfig.permissions[name] < 3) then
    roomConfig.commandUnavailable({ "setscore", name })
    return
  end

  if not newScore or newScore ~= newScore or newScore < 0 or newScore % 1 ~= 0 or newScore >= gameState.match.rules.winscore then
    tfm.exec.chatMessage("<j>Invalid score. Must be lower than the winscore (" .. gameState.match.rules.winscore .. ")<n> ", name)
    return
  end

  if targets[target] then
    gameScores.set(target, newScore)
    tfm.exec.chatMessage(targets[target] .. target .. " score set to " .. newScore .."<n2> by " .. name .. " <n> ", nil)
    clubhouse.showScores()
  end

  -- Player Score:
  -- Removed, it will be attached to a future level system.
  -- @Vit0rg
end

function commandHandlers.cmdSetLifes(args)
  local name = args[1]

  if gameState.phase ~= "startGame"
      or roomConfig.permissions[name] < 3
      or (not gameState.match.mode.teamsMode and not gameState.match.mode.threeTeamsMode) then
    return
  end

  local lifes = tonumber(args[2])

  local maxLifes = 10
  if not lifes or lifes ~= lifes or lifes < 1 or lifes % 1 ~= 0 or lifes >= maxLifes then
    tfm.exec.chatMessage("<j>Invalid score. Must be lower than (" .. maxLifes .. ")<n> ", name)
    return
  end

  gameState.lives = { [1] = { yellow = gameState.match.mode.threeTeamsMode and 0 or lifes }, [2] = { red = lifes }, [3] = { blue = lifes }, [4] = { green = lifes } }
end

function commandHandlers.cmdPassword(args)
  local name = args[1]
  -- The dispatcher appends the command name after the actual arguments.
  if #args == 2 then
    tfm.exec.setRoomPassword("")
    tfm.exec.chatMessage(playerState.language[name].tr.passwordRemoved, nil)
    return
  end
  if #args > 4 or (#args == 4 and args[3] ~= "true" and args[3] ~= "false") then
    tfm.exec.chatMessage("<j>Usage: !password <password> [true|false]<n>", name)
    return
  end
  local secret = #args == 4 and args[3] == "true"
  if secret and (roomConfig.permissions[name] or 1) <= 3 then
    tfm.exec.chatMessage("<j>A secret password requires permanent-admin permission.<n>", name)
    return
  end
  tfm.exec.setRoomPassword(args[2])
  if secret then
    tfm.exec.chatMessage("<bv>" .. name .. " set a secret password.<n>", nil)
  else
    tfm.exec.chatMessage("<bv>" .. playerState.language[name].tr.newPassword .. " " .. args[2] .. " by " .. name .. "<n>", nil)
  end
end
