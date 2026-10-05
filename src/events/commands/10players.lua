function commandHandlers.cmdDisabledOrUnavailable(args)
    tfm.exec.chatMessage('<j>Command unavailable or invalid permissions', args[1])
end
function commandHandlers.cmdSetTransformDuration(args)
  local name = args[1]
  local duration = tonumber(args[2])

  if not duration or duration ~= duration or duration < 3 or duration > 5 then
    tfm.exec.chatMessage('<j>Invalid duration, must be between 3 and 5', name)
    return
  end

  players[name].transformDuration = duration or 5
  tfm.exec.chatMessage('<pt>Transformation duration set to: <n>' .. duration .. ' second(s)', name)
  return 0
end

-- Keep chat lists in small messages instead of sending one oversized block.
function commandHandlers.sendCommandList(text, name)
  local chunk = ""
  for line in (text .. "\n"):gmatch("([^\n]*)\n") do
    if #chunk + #line + 1 > 800 and #chunk > 0 then
      tfm.exec.chatMessage(chunk, name)
      chunk = ""
    end
    chunk = chunk == "" and line or (chunk .. "\n" .. line)
  end
  if #chunk > 0 then tfm.exec.chatMessage(chunk, name) end
end

function commandHandlers.cmdCommands(args)
  local name = args[1]
  local userLevel = USER_PERMISSIONS[name] or 1

  -- Let's assume cumulative (show L1, L2 if admin, etc.)
  local finalBuffer = {}

  local max_depth
  for l = 1, math.min(userLevel, 3) do
    max_depth = #commandHandlers.HELP_TEXTS[l]
    for i = 1, max_depth do
      finalBuffer[#finalBuffer + 1] = commandHandlers.HELP_TEXTS[l][i]
    end
  end

  local result = "<bl>" .. table.concat(finalBuffer, '\n')

  if #result > 0 then
    commandHandlers.sendCommandList(result, name)
  else
    tfm.exec.chatMessage("<j>No commands available.<n>", name)
  end
end

function commandHandlers.cmdJoin(args)
  local name = args[1]

  if playerInGame[name] or gameState.phase ~= "gameStart" or isPlayerDead[name] then return end
  if messagePlayerIsBanned(name) then return end
  if not isGameplayMapReady() or
      ((gameStats.teamsMode or gameStats.threeTeamsMode) and not gameStats.canTransform) then
    tfm.exec.chatMessage('<j>Please wait until the court is ready before joining.<n>', name)
    return
  end

  local player = tfm.get.room.playerList[name]
  if player.isDead then tfm.exec.respawnPlayer(name) end

  showCrownToAllPlayers()

  if gameStats.threeTeamsMode then
    chooseTeamThreeTeamsMode(name)
    return
  end

  if gameStats.teamsMode then
    chooseTeamTeamsMode(name)
    return
  end

  if not gameStats.teamsMode then
    chooseTeam(name)
    return
  end

  tfm.exec.chatMessage("<bv>The join command is disabled now<n>", name)
end

function commandHandlers.cmdLeave(args)
  local name = args[1]
  if not playerInGame[name] or gameState.phase ~= "gameStart" or isPlayerDead[name] then return end
  if messagePlayerIsBanned(name) then return end

  if (gameStats.threeTeamsMode or gameStats.teamsMode) and
      gameStats.canTransform then
    leaveTeamTeamsMode(name)
    return
  end

  if not gameStats.teamsMode and not gameStats.threeTeamsMode then
    leaveTeam(name)
    return
  end
  tfm.exec.chatMessage("<bv>The leave command is disabled now<n>", name)
end

function commandHandlers.cmdLang(args)
  local name = args[1]
  local langCode = args[2]

  if not langCode then return end

  local translations = {
    en = lang.en,
    br = lang.br,
    ar = lang.ar,
    fr = lang.fr,
    pl = lang.pl
  }

  if translations[langCode] then
    playerLanguage[name].tr = translations[langCode]
    clubhouse.refresh(name)
  end
end

function commandHandlers.cmdAdmins(args)
  local name = args[1]
  local buffer_permas = {}
  local buffer_temp = {}
  local buffer_regular = {}

  for admin, permission in pairs(USER_PERMISSIONS) do
    if permission == 2 and admin ~= roomCreator.name then
      buffer_regular[#buffer_regular + 1] = admin
    end
    if permission == 3 then
      buffer_temp[#buffer_temp + 1] = admin
    end
    if permission == 5 then
      buffer_permas[#buffer_permas + 1] = admin
    end
  end

  local lines = {}

  if roomCreator.name then
    local status = (USER_PERMISSIONS[roomCreator.name] or 1) < 2 and " (admin removed)" or ""
    lines[#lines + 1] = " <vp>> Room Creator:\n" .. roomCreator.name .. status
  end

  if #buffer_permas > 0 then
    lines[#lines + 1] = " <vi>> Permanent Admins:\n" ..
        table.concat(buffer_permas, "\n")
  end

  if #buffer_temp > 0 then
    lines[#lines + 1] = " <j>> Temporary Permanent Admins:\n" ..
        table.concat(buffer_temp, "\n")
  end

  if #buffer_regular > 0 then
    lines[#lines + 1] = " <ch>> Regular Admins:\n" ..
        table.concat(buffer_regular, "\n")
  end

  tfm.exec.chatMessage('\n' .. table.concat(lines, "\n\n") .. " \n<n>", name)
end

function commandHandlers.cmdMaps(args)
  local name = args[1]

  if gameStats.realMode then
    tfm.exec.chatMessage("<j>Map voting is unavailable in Real Mode.<n>", name)
    return
  end

  local str = " <vp>Volley maps\n"
  local mapList, indices = availableMaps()

  local lines = {}
  local line = { [1] = '<vp>', [2] = 0, [3] = '<n> - ', [4] = '' }

  for i, map in ipairs(mapList) do
    line[2] = indices[i]
    line[4] = map[3]
    lines[#lines + 1] = table.concat(line, ' ')
  end

  str = str .. table.concat(lines, '\n')
  str = str .. "\n\n<j>To vote type !votemap number, example: !votemap 1 <n> "
  commandHandlers.sendCommandList(str, name)
end

function commandHandlers.cmdBalls(args)
  local name = args[1]

  local str = " <vp>Volley custom balls "
  local line = { [1] = '<vp>', [2] = 0, [3] = '<n> - ', [4] = '' }
  local lines = {}

  for i, ball in ipairs(balls) do
    line[2] = i
    line[4] = ball.name
    lines[#lines + 1] = table.concat(line, ' ')
  end

  str = str .. table.concat(lines, '\n')
  tfm.exec.chatMessage(str .. " <n> ", name)
end

function commandHandlers.cmdVoteMap(args)
  local name = args[1]

  if messagePlayerIsBanned(name) then return end

  -- canVote works as a sparse dictionary, instead of
  -- being a global, it should be attached to a global
  -- player variable. @Vit0rg

  if gameState.phase ~= "startGame" or not canVote[name] then return end

  if gameStats.realMode then
    commandNotAvailable({ "votemap", name })
    return
  end

  local indexMap = tonumber(args[2])
  if not indexMap or type(indexMap) ~= "number" then
    tfm.exec.chatMessage('<vi>Second parameter invalid, must be a number<n>',
      name)
    return
  end

  local maps = configSelectMap()
  indexMap = math.abs(math.floor(indexMap))

  if indexMap < 1 or indexMap > #maps then
    tfm.exec.chatMessage(
      '<vi>Index must be between 1 and ' .. #maps .. '<n>', name)
    return
  end

  if not isMapAvailable(indexMap) then
    tfm.exec.chatMessage('<j>This map is unavailable at the selected size.<n>', name)
    return
  end

  canVote[name] = false
  mapsVotes[indexMap] = (mapsVotes[indexMap] or 0) + 1
  gameStats.totalVotes = gameStats.totalVotes + 1

  clubhouse.refreshMapVotes(indexMap,name)

  verifyMostMapVoted()

  tfm.exec.chatMessage(
    " <bv>" .. name .. " voted for " .. maps[indexMap][3] .. " (" ..
    mapsVotes[indexMap] .. " votes)<n> ", nil)
end

function commandHandlers.cmdCrown(args)
  local name = args[1]

  -- Again, this should be attached to the player
  -- data, not a random global variable.
  -- @Vit0rg
  if args[2] == "true" then
    showCrownImages[name] = true
    showCrownToAllPlayers(name)
    return
  end

  if args[2] == "false" then
    showCrownImages[name] = false
    gameCrowns.clearViewer(name)
    return
  end

  tfm.exec.chatMessage('<vi>Parameter must be true or false<n>', name)
end

function commandHandlers.cmdProfile(args)
  local name = args[1]
  -- The dispatcher appends the command/alias as the last argument.
  local query = #args > 2 and args[2] or name
  local target, reason = resolveProfileTarget(query)
  if not target then
    tfm.exec.chatMessage("<rose>" .. getProfileText(name)[reason] .. "<n>", name)
    return
  end
  if profileKeyTime[name] and os.time() - profileKeyTime[name] < 2000 then return end
  profileKeyTime[name] = os.time()
  closeAllWindows(name)
  profileUI(name, target)
end

function commandHandlers.cmdDiscord(args)
  local name = args[1]

  local msg = "Official Volley Discord:" ..
      "<vp>https://discord.com/invite/pWNTesmNhu"
  if USER_PERMISSIONS[name] and USER_PERMISSIONS[name] > 2 then
    tfm.exec.chatMessage(msg, nil)
  else
    tfm.exec.chatMessage(msg, name)
  end
end
