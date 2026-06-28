-- HELPER FUNCTIONS
local function validateMap(args)
  local name = args[1]
  local map = args[2]
  local index = args[3]

  local regexMap = "^@%d%d%d%d%d%d%d$"

  if not map or not string.match(map, regexMap) then
    tfm.exec.chatMessage(" <bv>Parameter " .. index ..
      " invalid. Use @1234567<n> ", name)
    return false
  end

  return true
end

local function split(str)
  local t = {}
  for word in str:gmatch("%S+") do t[#t + 1] = word end
  return t
end

-- Validate team mode conflicts
local function checkModeConflict(args)
  local name = args[1]
  local modeToEnable = args[2]

  if gameStats.teamsMode and modeToEnable ~= "teamsMode" then
    tfm.exec.chatMessage("<bv>You should disable the 4 teams mode first<n>",
      name)
    return true
  end
  if gameStats.twoTeamsMode and modeToEnable ~= "twoTeamsMode" then
    tfm.exec.chatMessage("<bv>You should disable the 2 teams mode first<n>",
      name)
    return true
  end
  if gameStats.threeTeamsMode and modeToEnable ~= "threeTeamsMode" then
    tfm.exec.chatMessage("<bv>You should disable the 3 teams mode first<n>",
      name)
    return true
  end
  if gameStats.realMode and modeToEnable ~= "realMode" then
    tfm.exec.chatMessage("<bv>You should disable the real mode first<n>",
      name)
    return true
  end
  return false
end

local HELP_TEXTS = {
  { "<bl>commands <n2> = commands",    "<bl>c <n2> = commands",   "<bl>join <n2> = join",              "<bl>j <n2> = join",        "<bl>leave <n2> = leave",        "<bl>l <n2> = leave",       "<bl>lang <n2> = lang",          "<bl>la <n2> = lang",       "<bl>admins <n2> = admins",              "<bl>ads <n2> = admins",       "<bl>balls <n2> = balls",  "<bl>ba <n2> = balls", "<bl>votemap <n2> = votemap",   "<bl>vm <n2> = votemap",  "<bl>crown <n2> = crown",       "<bl>cr <n2> = crown",           "<bl>profile <n2> = profile",   "<bl>pr <n2> = profile",         "<bl>discord <n2> = discord", "<bl>dc <n2> = discord",       "<bl>maps <n2> = maps",   "<bl>m <n2> = maps" },
  { "<d>resettimer <n2> = resettimer", "<d>re <n2> = resettimer", "<d>setduration <n2> = setduration", "<d>sd <n2> = setduration", "<d>skiptimer <n2> = skiptimer", "<d>skip <n2> = skiptimer", "<d>stoptimer <n2> = stoptimer", "<d>stop <n2> = stoptimer", "<d>setmaxplayers <n2> = setmaxplayers", "<d>smp <n2> = setmaxplayers", "<d>setmap <n2> = setmap", "<d>sm <n2> = setmap", "<d>winscore <n2> = winscore",  "<d>w <n2> = winscore",   "<d>pw <n2> = pw",              "<d>randommap <n2> = randommap", "<d>ra <n2> = randommap",       "<d>custommap <n2> = custommap", "<d>cm <n2> = custommap",     "<d>setscore <n2> = setscore", "<d>ssc <n2> = setscore", "<d>4teamsmode <n2> = 4teamsmode", "<d>fom <n2> = 4teamsmode", "<d>2teamsmode <n2> = 2teamsmode", "<d>twm <n2> = 2teamsmode", "<d>3teamsmode <n2> = 3teamsmode", "<d>thm <n2> = 3teamsmode", "<d>realmode <n2> = realmode", "<d>rm <n2> = realmode", "<d>admin <n2> = admin", "<d>a <n2> = admin", "<d>unadmin <n2> = unadmin", "<d>ua <n2> = unadmin", "<d>randomball <n2> = randomball", "<d>rb <n2> = randomball", "<d>customball <n2> = customball", "<d>cb <n2> = customball", "<d>lobby <n2> = lobby", "<d>lo <n2> = lobby", "<d>autosyncsys <n2> = autosyncsystem", "<d>asy <n2> = autosyncsystem", "<d>sync <n2> = sync", "<d>sy <n2> = sync", "<d>setsync <n2> = setsync", "<d>ssy <n2> = setsync", "<d>synctfm <n2> = synctfm", "<d>syt <n2> = synctfm", "<d>setplayerforce <n2> = setplayerforce", "<d>spf <n2> = setplayerforce", "<d>np <n2> = np", "<d>test <n2> = test", "<d>t <n2> = test", "<d>twoballs <n2> = twoballs", "<d>twb <n2> = twoballs", "<d>threeballs <n2> = threeballs", "<d>thb <n2> = threeballs", "<d>consumables <n2> = consumables", "<d>co <n2> = consumables", "<d>settings <n2> = settings", "<d>se <n2> = settings" },
  { "<vi>padmin <n2> = padmin",        "<vi>pa <n2> = padmin",    "<vi>pause <n2> = pause",            "<vi>p <n2> = pause",       "<vi>kick <n2> = kick",          "<vi>ki <n2> = kick",       "<vi>fleave <n2> = fleave",      "<vi>fl <n2> = fleave",     "<vi>ban <n2> = ban",                    "<vi>b <n2> = ban",            "<vi>unban <n2> = unban",  "<vi>ub <n2> = unban", "<vi>killspec <n2> = killspec", "<vi>ks <n2> = killspec", "<vi>teleport <n2> = teleport", "<vi>tp <n2> = teleport",        "<vi>listsync <n2> = listsync", "<vi>lsy <n2> = listsync", "<vi>setlifes <n2> = setlifes", "<vi>sl <n2> = sl" }
}

-- NORMAL COMMANDS
local function cmdDisabledOrUnavailable(args)
    tfm.exec.chatMessage('<j>Command unavailable or invalid permissions', args[1])
end
local function cmdsetOffset(args)
  if #args < 3 then
    tfm.exec.chatMessage(
      '<j>Offset: x y\n<vi>Offset is the distance to the position where you will transform, in pixels.', name)
    return
  end

  local name = args[1]
  local x = tonumber(args[2]) or 15
  local y = tonumber(args[3]) or 1

  if x == 'false' then
    tfm.exec.chatMessage('<j>Offset reset to default.', name)
    local OFFSETS = { x = 15, y = 5 }
    players[name].offsets = { 15, 1 }
    return
  end

  if x < -25 or x > 25 then
    tfm.exec.chatMessage('<j>Second argument must be a number between -25 and 25.', name)
    return
  end

  if y < 1 or y > 5 then
    tfm.exec.chatMessage('<j>Third argument must be a number between 1 and 5.', name)
    return
  end

  players[name].offsets.x = x
  players[name].offsets.y = y
  tfm.exec.chatMessage('<pt>Offset set to: <n>x: ' .. x .. ' y: ' .. y, name)
end

local function cmdSetTransformDuration(args)
  local name = args[1]
  local duration = tonumber(args[2])

  if duration < 3 or duration > 5 then
    tfm.exec.chatMessage('<j>Invalid duration, must be between 3 and 5', name)
    return
  end

  players[name].transformDuration = duration or 5
  tfm.exec.chatMessage('<pt>Transformation duration set to: <n>' .. duration .. ' second(s)', name)
  return 0
end

local function cmdCommands(args)
  local name = args[1]
  local userLevel = USER_PERMISSIONS[name] or 1

  -- Let's assume cumulative (show L1, L2 if admin, etc.)
  local finalBuffer = {}

  local max_depth
  for l = 1, math.min(userLevel, 3) do
    max_depth = #HELP_TEXTS[l]
    for i = 1, max_depth do
      finalBuffer[#finalBuffer + 1] = HELP_TEXTS[l][i]
    end
  end

  local result = "<bl>" .. table.concat(finalBuffer, '\n')

  if #result > 0 then
    tfm.exec.chatMessage(result, name)
  else
    tfm.exec.chatMessage("<j>No commands available.<n>", name)
  end
end

local function cmdJoin(args)
  local name = args[1]

  if playerInGame[name] or mode ~= "gameStart" or isPlayerDead[name] then return end
  if messagePlayerIsBanned(name) then return end

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

local function cmdLeave(args)
  local name = args[1]
  if not playerInGame[name] or mode ~= "gameStart" or isPlayerDead[name] then return end
  if messagePlayerIsBanned(name) then return end

  if (gameStats.threeTeamsMode or gameStats.teamsMode) and
      gameStats.canTransform then
    leaveTeamTeamsMode(name)
    return
  end

  if not gameStats.teamsMode then
    leaveTeam(name)
    return
  end
  tfm.exec.chatMessage("<bv>The leave command is disabled now<n>", name)
end

local function cmdLang(args)
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
  end
end

local function cmdAdmins(args)
  local name = args[1]
  local buffer_permas = {}
  local buffer_temp = {}
  local buffer_regular = {}

  for admin, permission in pairs(USER_PERMISSIONS) do
    if permission == 2 then
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

local function cmdMaps(args)
  local name = args[1]

  local str = " <vp>Volley maps\n"
  local mapList = gameStats.twoTeamsMode and customMapsFourTeamsMode or
      gameStats.threeTeamsMode and customMapsThreeTeamsMode or
      gameStats.teamsMode and customMapsFourTeamsMode or
      customMaps

  local lines = {}
  local line = { [1] = '<vp>', [2] = 0, [3] = '<n> - ', [4] = '' }

  for i, map in ipairs(mapList) do
    line[2] = i
    line[4] = map[3]
    lines[#lines + 1] = table.concat(line, ' ')
  end

  str = str .. table.concat(lines, '\n')
  str = str .. "\n\n<j>To vote type !votemap number, example: !votemap 1 <n> "
  tfm.exec.chatMessage(str, name)
end

local function cmdBalls(args)
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

local function cmdVoteMap(args)
  local name = args[1]

  if messagePlayerIsBanned(name) then return end

  -- canVote works as a sparse dictionary, instead of
  -- being a global, it should be attached to a global
  -- player variable. @Vit0rg

  if mode ~= "startGame" or not canVote[name] then return end

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

  canVote[name] = false
  mapsVotes[indexMap] = (mapsVotes[indexMap] or 0) + 1
  gameStats.totalVotes = gameStats.totalVotes + 1

  -- Update UI for voters
  -- The UI system needs to be reviewed too.
  -- It looks so verbose and inefficient. @Vit0rg
  for n, _ in pairs(tfm.get.room.playerList) do
    if selectMapPage[name] == selectMapPage[n] and selectMapOpen[n] then
      selectMapUI(n)
    end
  end

  verifyMostMapVoted()

  tfm.exec.chatMessage(
    " <bv>" .. name .. " voted for " .. maps[indexMap][3] .. " (" ..
    mapsVotes[indexMap] .. " votes)<n> ", nil)
end

local function cmdCrown(args)
  local name = args[1]

  -- Again, this should be attached to the player
  -- data, not a random global variable.
  -- @Vit0rg
  if args[2] == "true" then
    showCrownImages[name] = true
    return
  end

  if args[2] == "false" then
    showCrownImages[name] = false
    return
  end

  tfm.exec.chatMessage('<vi>Parameter must be true or false<n>', name)
end

local function cmdProfile(args)
  local name = args[1]
  local target = args[2]

  -- Update the Buttons with the id variable later,
  -- not a magical number. @Vit0rg
  closeRankingUI(name)
  removeButtons(25, name)
  removeButtons(26, name)
  removeUITrophies(name)

  if not target then
    profileUI(name, name)
    return
  end

  for n, _ in pairs(playerAchievements) do
    if string.lower(n) == string.lower(target) then
      profileUI(name, n)
      break
    end
  end
end

local function cmdDiscord(args)
  local name = args[1]

  local msg = "Official Volley Discord:" ..
      "<vp>https://discord.com/invite/pWNTesmNhu"
  if USER_PERMISSIONS[name] and USER_PERMISSIONS[name] > 2 then
    tfm.exec.chatMessage(msg, nil)
  else
    tfm.exec.chatMessage(msg, name)
  end
end

local function cmdTest(args)
  local name = args[1]
  -- not tfm.get.room.isTribeHouse
  -- Removed tribeHouse check, because some
  -- players still do wanna play alone on
  -- empty or dead rooms. @Vit0rg
  if mode ~= "startGame" then return end

  playersRed[1].name = "a"
  playersBlue[1].name = "a"
  playersRed[2].name = "a"
  playersBlue[2].name = "a"
  playersGreen[1].name = "a"

  -- Maybe this will break, but the table initialization
  -- was redundant. @Vit0rg
  playersYellow[1].name = "a"
  eventNewGameShowLobbyTexts()
end

local function cmdNP(args)
  local name = args[1]
  if not tfm.get.room.isTribeHouse or mode ~= "startGame" then return end

  if gameStats.realMode or gameStats.setMapName == "extra-large" then
    tfm.exec.chatMessage(" <j>Not available in this mode<n> ", name)
    return
  end

  local defaultMap = (gameStats.threeTeamsMode and
        customMapsThreeTeamsMode[1][2]) or
      (gameStats.teamsMode and
        customMapsFourTeamsMode[34][2]) or
      customMaps[6][1]

  mapsToTest[1] = (validateMap({ name, args[2], 1 }) and args[2]) or defaultMap

  mapsToTest[2] = validateMap({ name, args[3], 2 }) or defaultMap
  mapsToTest[3] = validateMap({ name, args[4], 3 }) or
      customMapsFourTeamsMode[34][5]

  for i = 1, #mapsToTest do tfm.exec.chatMessage(mapsToTest[i]..'\n', nil) end
  tfm.exec.chatMessage("<vp>Test map(s) loaded<n> ", nil)
end

-- ADMIN COMMANDS
local function cmdAutoSyncSystem(args)
  local name = args[1]
  local toggle = args[2]

  if toggle ~= "true" and toggle ~= "false" then
    tfm.exec.chatMessage('<bv>Must be true or false<n>', name)
    return
  end

  autosync = (toggle == "true")
  tfm.exec.chatMessage("<n>Auto Sync System " ..
    (autosync and "<vp>enabled<n2>" or
      "<r>disabled<n2>") .. " by " .. name .. " <n> ",
    nil)

end

local function cmdSync(args)
  local name = args[1]

  -- Auto-sync to lowest latency
  if #args == 2 then
    tfm.exec.chatMessage('<j> Sync set by:'..name, nil)
    refletzSyncSystem()
    return
  end

  -- Manual sync
  if (USER_PERMISSIONS[name] < 3) then return end

  -- Using a global player list copy would make the lookup so
  -- much better. @Vit0rg
  local target = args[2] or ""
  if target == "" then return end

  for n, _ in pairs(tfm.get.room.playerList) do
    if string.lower(n) == string.lower(target) then
      tfm.exec.setPlayerSync(n)
      tfm.exec.chatMessage("<vi>Sync set to " .. n .. " by " .. name ..
        " <n> ", nil)
      break
    end
  end
end

local function cmdLobby(args)
  local name = args[1]

  if mode ~= "gameStart" or not gameStats.canTransform then return end

  ballOnGame = false
  ballOnGame2 = false
  ballOnGame3 = false

  tfm.exec.removeObject(ball_id)
  tfm.exec.removeObject(ball_id2)
  tfm.exec.removeObject(ball_id3)

  removeTimer('verifyBallCoordinates')

  -- Cleanup UI
  ui.removeTextArea(0)
  ui.removeTextArea(1)
  ui.removeTextArea(899899)
  ui.removeTextArea(8998991)

  mode = "endGame"
  gameTimeEnd = os.time() + 5000

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

local function cmdResetTimer(args)
  local name = args[1]
  if mode ~= "startGame" then return end

  initGame = os.time() + 15000
  tfm.exec.chatMessage("<bv>resettimer enabled by " .. name .. " <n> ", nil)
end

local function cmdSkipTimer(args)
  local name = args[1]
  if mode ~= "startGame" then return end

  initGame = os.time() + 10000
  tfm.exec.chatMessage(" <bv>skiptimer enabled by " .. name .. " <n> ", nil)
  tfm.exec.chatMessage(
    "<vi>Yes, now it is 10s, fix your dopamine addiction and let the script load in peace.")
end

local function cmdSetDuration(args)
  local name = args[1]
  local durationSec = args[2]

  durationSec = tonumber(args[2])

  if not durationSec or type(durationSec) ~= "number" then
    durationSec = durationDefault
    tfm.exec.chatMessage("<bv>Duration reset to default (" ..
      durationDefault .. "s) by " .. name .. " <n> ",
      nil)
  else
    durationSec = math.abs(math.floor(durationSec))
    tfm.exec.chatMessage(
      "<bv>Duration set to " .. durationSec .. "s by " .. name .. " <n> ",
      nil)
  end

  -- Why is the duration stuff outside of the
  -- global gameStats state tracker?
  -- @Vit0rg
  duration = os.time() + durationSec * 1000
  durationTimerPause = durationSec

  tfm.exec.setGameTime(durationTimerPause, true)
end

local function cmdSetMaxPlayers(args)
  local name = args[1]
  local maxPlayers = tonumber(args[2])

  if not maxPlayers then return end

  maxPlayers = math.abs(math.floor(maxPlayers))
  if maxPlayers >= 6 and maxPlayers <= 20 then
    tfm.exec.setRoomMaxPlayers(maxPlayers)
    tfm.exec.chatMessage("<bv>" ..
      playerLanguage[name].tr.messageSetMaxPlayers ..
      " " .. maxPlayers .. " by " .. name .. " <n> ",
      nil)
  else
    tfm.exec.chatMessage(playerLanguage[name].tr.messageMaxPlayersAlert,
      name)
  end
end

local function cmdSetMap(args)
  local name = args[1]
  local mapType = args[2]

  if mode ~= "startGame" then return end

  if gameStats.teamsMode then
    commandNotAvailable({ "setmap", name })
    return
  end

  if mapType ~= "small" and mapType ~= "large" and mapType ~= "extra-large" then
    tfm.exec.chatMessage(
      " <bv>Invalid map size: small, large, or extra-large<n> ", name)
    return
  end

  if mapType == "small" or mapType == "large" then resetMapsToTest() end

  gameStats.setMapName = mapType
  tfm.exec.chatMessage(" <bv>" .. mapType .. " map selected by " .. name ..
    " <n> ", nil)
end

local function cmdWinScore(args)
  local name = args[1]
  local winscore = tonumber(args[2])

  if mode == "startGame" and not gameStats.realMode then
    tfm.exec.chatMessage(
      "<bv>Winscore changed to <j>" .. winscore .. "<n2> by " .. name .. "<n> ",
      nil)
      return
  end

  -- To make possible to change winscore on tournaments
  if mode ~= "gameStart" or gameStats.teamsMode or USER_PERMISSIONS[name] < 3 then
    return
  end

  if not winscore then return end
  winscore = math.abs(math.floor(winscore))

  if winscore > teamsScores['red'] 
     and winscore > teamsScores['blue'] 
     and winscore > 0 then
    gameStats.winscore = winscore
    tfm.exec.chatMessage(
      "<bv>Winscore changed to<j> " .. winscore .. "<n2> by " .. name .. "<n> ",
      nil)
  end
end

local function cmdSetScore(args)
  if mode == "startGame" then return end

  local name = args[1]
  local target = args[2]
  local newScore = tonumber(args[3])

  if not target
     or (gameStats.teamsMode or gameStats.threeTeamsMode) then
    return
  end

  -- Team Score
  local targets = { ['red'] = '<r>', ['blue'] = '<bv>' }

  if gameStats.teamsMode and (USER_PERMISSIONS[name] < 3) then
    commandNotAvailable({ "setscore", name })
    return
  end

  if not newScore or newScore >= gameStats.winscore then
    tfm.exec.chatMessage("<j>Invalid score. Must be lower than the winscore (" .. gameStats.winscore .. ")<n> ", name)
    return
  end

  if targets[target] then
    teamsScores[target] = newScore
    tfm.exec.chatMessage(targets[target] .. target .. " score set to " .. newScore .."<n2> by " .. name .. " <n> ", nil)
    showTheScore()
  end

  -- Player Score:
  -- Removed, it will be attached to a future level system.
  -- @Vit0rg
end

local function cmdSetLifes(args)
  local name = args[1]

  if mode ~= "startGame" 
      or USER_PERMISSIONS[name] < 3
      or (not gameStats.teamsMode and not gameStats.threeTeamsMode) then
    return
  end

  local lifes = tonumber(args[2])

  local maxLifes = 10
  if not lifes or lifes >= maxLifes then
    tfm.exec.chatMessage("<j>Invalid score. Must be lower than (" .. maxLifes .. ")<n> ", name)
    return
  end

  teamsLifes = { [1] = { yellow = lifes }, [2] = { red = lifes }, [3] = { blue = lifes }, [4] = { green = lifes } }
end

local function cmdPassword(args)
  local name = args[1]
  local password = args[2] or ""
  local isSecret = args[3] or false

  if args[2] == "" then
    tfm.exec.setRoomPassword()
    tfm.exec.chatMessage(playerLanguage[name].tr.passwordRemoved, nil)
    return
  end

  tfm.exec.setRoomPassword(password)

  if isSecret and USER_PERMISSIONS[name] and USER_PERMISSIONS[name] > 3 then
    tfm.exec.chatMessage(" <bv>" .. name .. "set a secret password.", nil)
    return
  end

  tfm.exec.chatMessage(
    " <bv>" .. playerLanguage[name].tr.newPassword .. " " .. password ..
    " by " .. name .. " <n> ", nil)
end

local function cmdAdmin(args)
  local name = args[1]
  local target = args[2]

  local permission = USER_PERMISSIONS[target] or 1

  if not target or permission > 1 then return end

  -- This loop approach will be outdated when
  -- we are sure that the playerList is
  -- always updated on join and leave events.
  -- @Vit0rg
  for n, _ in pairs(tfm.get.room.playerList) do
    if string.lower(n) == string.lower(target) then
      USER_PERMISSIONS[n] = 2
      tfm.exec.chatMessage("<bv>" .. n .. " made admin by " .. name ..
        " <n> ", nil)
      break
    end
  end
end

local function cmdUnadmin(args)
  local name = args[1]
  local target = args[2]

  if not target then return end
  if USER_PERMISSIONS[target] > 2 then return end

  -- Unadmin All (Perm Admin only)
  if USER_PERMISSIONS[name] > 2 then
    if target == "all" then
      for admin, _ in pairs(USER_PERMISSIONS) do
        if USER_PERMISSIONS[admin] == 2 then
          USER_PERMISSIONS[admin] = 1
        end
      end

      tfm.exec.chatMessage(
        "<rose>Admin list reset by " .. name .. " <n> ", nil)
      return
    end

    if USER_PERMISSIONS[target] < 4 then
      USER_PERMISSIONS[target] = 1
      tfm.exec.chatMessage(
        "<vi>" .. target .. " removed from admin by " .. name .. " <n> ",
        nil)
    end
  end

  if USER_PERMISSIONS[target] < 3 then
    USER_PERMISSIONS[target] = 1
    tfm.exec.chatMessage("<vi>" .. target .. " removed from admin by " ..
      name .. " <n> ", nil)
  end
end

local function cmdRandomMap(args)
  local name = args[1]
  local isRandom = args[2]

  if isRandom ~= "true" and isRandom ~= "false" then
    tfm.exec.chatMessage('<bv>Must be true or false<n>', name)
    return
  end

  if mode ~= "startGame" then return end

  if gameStats.realMode then
    commandNotAvailable({ " <bv>Not available in Real Mode<n> ", name })
    return
  end

  -- Cooldown for spam prevention
  local randomMapCommand = true
  addTimer(function() randomMapCommand = false end, 5000, 1,
    "randomMapCommandDelay")

  gameStats.isCustomMap = isRandom

  if isRandom == "false" then
    gameStats.customMapIndex = 0
    tfm.exec.chatMessage(
      "<bv>Random map deactivated by:" .. name .. " <n> ", nil)
    return
  end

  local list = (gameStats.twoTeamsMode and customMapsFourTeamsMode) or
      (gameStats.threeTeamsMode and customMapsThreeTeamsMode) or
      customMaps

  local index = math.random(1, #list)
  gameStats.customMapIndex = index
  local mapInfo = list[index]
  tfm.exec.chatMessage('<bv>' .. mapInfo[3] .. ' (by ' .. mapInfo[4] ..
    ') selected randomly<n> ', nil)

  -- Seriously, the UI update idea with the iteration is so
  -- bad that removing it seems to be the best optimization.
  -- If not even React could figure out a way to properly
  -- handle UI updates, imagine a dead game with an outdated
  -- API. @Vit0rg

  -- for n, _ in pairs(tfm.get.room.playerList) do
  --  if selectMapOpen[n] then selectMapUI(n) end
  -- end
end

local function cmdRandomBall(args)
  local name = args[1]
  local isRandom = args[2]

  if mode ~= "startGame" then return end

  if isRandom ~= "true" and isRandom ~= "false" then
    tfm.exec.chatMessage('<bv>Must be true or false<n>', name)
    return
  end

  local randomBallCommand = true
  if mode ~= "startGame" or not randomBallCommand then return end
  -- Cooldown for spam prevention
  addTimer(function() randomBallCommand = false end, 5000, 1,
    "randomBallCommandDelay")

  if isRandom ~= "true" and isRandom ~= "false" then
    tfm.exec.chatMessage('<bv>Must be true or false<n>', name)
    return
  end

  gameStats.customBall = isRandom

  if isRandom == "true" then
    local index = math.random(1, #balls)
    gameStats.customBallId = index
    tfm.exec.chatMessage("<bv>Random ball: " .. balls[index].name ..
      " enabled by " .. name .. " <n> ", nil)
    return
  end

  gameStats.customBallId = 11
  tfm.exec.chatMessage("<bv>Random ball deactivated by " .. name .. " <n> ",
    nil)
end

local function cmdCustomMap(args)
  local name = args[1]
  local isCustomMap = args[2]

  if mode ~= "startGame" then return end

  if gameStats.realMode then
    commandNotAvailable({ "<bv>Not available in Real Mode<n> ", name })
    return
  end

  if isCustomMap ~= "false" and (type(tonumber(isCustomMap)) ~= "number") then
    tfm.exec.chatMessage('<j>Second argument must be a number or false<n>', name)
    return
  end

  if isCustomMap == "false" then
    gameStats.isCustomMap = false
    gameStats.customMapIndex = 1
    return
  end

  local list = gameStats.twoTeamsMode and customMapsFourTeamsMode or
      gameStats.threeTeamsMode and customMapsThreeTeamsMode or
      customMaps

  local index = math.floor(isCustomMap)
  if index < 1 or index > #list then
    tfm.exec.chatMessage('<j>Index out of range (1-' .. #list .. ')<n>',
      name)
    return
  end

  gameStats.isCustomMap = true
  gameStats.customMapIndex = index
  local mapInfo = list[index]
  tfm.exec.chatMessage(' <vp>' .. mapInfo[3] .. '<n2> (by ' .. mapInfo[4] ..
    ') selected by <d>' .. name .. ' <n> ', nil)

  -- Same case of randommap UI update. @Vit0rg
  -- for n, _ in pairs(tfm.get.room.playerList) do
  --  if selectMapOpen[n] then selectMapUI(n) end
  -- end
end

local function cmdCustomBall(args)
  local name = 1
  local index = math.abs(math.floor(args[2]))

  if mode ~= "startGame" then return end

  if not index or index < 1 or index > #balls then
    tfm.exec.chatMessage('<bv>Invalid ball index (1-' .. #balls .. ')<n>',
      name)
    return
  end

  -- One interesting optimization is to use a
  -- single function to handle custommap and randommap,
  -- same with customball and randommap.
  -- I started doing it, but gonna leave it to
  -- someone else. @Vit0rg

  gameStats.customBall = true
  gameStats.customBallId = index
  tfm.exec.chatMessage(" <bv>Ball: " .. balls[gameStats.customBallId].name ..
    " selected by " .. name .. " <n> ", nil)
end

local function cmdTwoBalls(args)
  if mode ~= "startGame" or gameStats.realMode then return end
  local name = args[1]
  local toggle = args[2]

  if toggle ~= "true" and toggle ~= "false" then
    tfm.exec.chatMessage('<bv>Must be true or false<n>', name)
    return
  end

  gameStats.twoBalls = (toggle == "true")
  tfm.exec.chatMessage("<n>Two balls " ..
    (gameStats.twoBalls and "<vp>enabled<n2>" or
      "<r>disabled<n2>") .. " by " .. name .. " <n> ",
    nil)
end

local function cmdThreeBalls(args)
  if mode ~= "startGame" or not gameStats.threeTeamsMode then return end
  local name = args[1]
  local toggle = args[2]

  if toggle ~= "true" and toggle ~= "false" then
    tfm.exec.chatMessage('<bv>Must be true or false<n>', name)
    return
  end

  gameStats.threeBalls = (toggle == "true")
  tfm.exec.chatMessage("<n>Three balls " ..
    (gameStats.threeBalls and "<vp>enabled<n2>" or
      "<r>disabled<n2>") .. " by " .. name .. " <n> ",
    nil)
end

local function cmdSetPlayerForce(args)
  if mode ~= "startGame" then return end

  local name = args[1]
  local force = tonumber(args[2])

  if not force or force < 0 or force > 1.05 then
    tfm.exec.chatMessage('<j>Force must be between 0 and 1.05<n>', name)
    return
  end

  gameStats.physicObjectForce = force
  tfm.exec.chatMessage(
    "<n>Player force set to <bv>" .. force .. "<n2> by " .. name .. " <n> ",
    name)
end

local function cmdConsumables(args)
  if mode ~= "startGame" then return end
  local name = args[1]

  if gameStats.teamsMode or gameStats.twoTeamsMode or gameStats.realMode then
    tfm.exec
        .chatMessage("<j>Consumables only work in normal mode<n> ", name)
    return
  end

  local toggle = tostring(args[2])
  if toggle ~= "true" and toggle ~= "false" then
    tfm.exec.chatMessage('<bv>Must be true or false<n>', name)
    return
  end

  gameStats.consumables = (toggle == "true")
  tfm.exec.chatMessage(" <n>Consumables " ..
    (gameStats.consumables and "<vp>enabled<n2>" or
      "<r>disabled<n2>") .. " by " .. name .. " <n> ",
    nil)
end

local function cmdSetTeamMode(args)
  local name = args[1]
  local toggle = args[2]

  if toggle ~= 'true' and toggle ~= 'false' then
    tfm.exec.chatMessage(
      '<j> The second argument must be true or false.\nExample: 4teamsmode true')
    return
  end

  local command_to_mode =
  {
    ["4teamsmode"] = 'teamsMode',
    ["fourteamsmode"] = 'teamsMode',
    ["fom"] = 'teamsMode',
    ["2teamsmode"] = 'twoTeamsMode',
    ["twoteamsmode"] = 'twoTeamsMode',
    ["twm"] = 'twoTeamsMode',
    ["3teamsmode"] = 'threeTeamsMode',
    ["threeteamsmode"] = 'threeTeamsMode',
    ["thm"] = 'threeTeamsMode',
    ["realmode"] = 'realMode',
    ["rm"] = 'realMode',
  }
  local _mode = command_to_mode[args[3]] or ''

  local modes = {
    ['twoTeamsMode'] = {
      alias = '2-team mode',
      TeamsColors = { 0xEF4444, 0x3B82F6 }
    },
    ['threeTeamsMode'] = {
      alias = '3-team mode',
      TeamsColors = { 0xEF4444, 0x3B82F6, 0x109267 },
      -- The fact that we need to use this hackish way instead
      -- of a dynamic assignment is a proof that the whole system
      -- came up to a point where decoupling and implementing
      -- Dependency Injection techniques is more than due.
      -- Change one line, everything breaks.
      -- @Vit0rg
      teamsLifes = {[1] = {yellow = 0 }, [2] = { red = 5 }, [3] = { blue = 5 }, [4] = { green = 5 } }
    },
    ['teamsMode'] = {
      alias = '4-team mode',
      TeamsColors = { 0xF59E0B, 0xEF4444, 0x3B82F6, 0x109267 },
      teamsLifes = {
        [1] = { yellow = 3 },
        [2] = { red = 3 },
        [3] = { blue = 3 },
        [4] = { green = 3 }
      }
    },
    ['realMode'] = { alias = 'Real mode' }
  }

  if not modes[_mode] then
    tfm.exec.chatMessage(
      '<vi>Critical error, mode not implemented or wrong argument.')
    return
  end


  if gameStats[_mode] and toggle == true then
    tfm.exec.chatMessage('<j> Mode already enabled: ' .. _mode)
    return
  end

  if checkModeConflict({ name, _mode }) then return end

  gameStats.canJoin = false
  gameStats.isCustomMap = false
  gameStats.customMapIndex = 0

  if toggle == 'true' then
    gameStats[_mode] = true
  end

  if not gameStats[_mode] and not toggle then return end

  if toggle == 'false' then
    gameStats[_mode] = false
  end

  getTeamsColorsName = modes[_mode].TeamsColors or
      modes['twoTeamsMode'].TeamsColors
  teamsLifes = modes[_mode].teamsLifes
  resetMapsToTest()
  resetMapsList()
  updateLobbyTextAreas()

  tfm.exec.chatMessage(" <n>" .. modes[_mode].alias ..
    (toggle == 'true' and " <vp>enabled<n2>" or
      " <r>disabled<n2>") .. " by " .. name ..
    " <n2> ", nil)
end

local function cmdSettings(args)
  local name = args[1]

  closeRankingUI(name)
  removeUITrophies(name)
  settings[name] = true
  updateSettingsUI(name)
end

-- PERMANENT ADMIN COMMANDS
local function cmdBroadcast(args)
  local name = args[1]
  if #args > 2 then
    local categories =
    {
      ['a'] = '<vi>',
      ['t'] = '<v>',
      ['w'] = '<j>'
    }

    local category = categories[args[2]] or categories['general']
    local message = "\n" .. category .. args[3]
  end

  local message = "<vi>[Announcement]\n" .. args[2]

  if USER_PERMISSIONS[name] and USER_PERMISSIONS[name] > 2 then
    tfm.exec.chatMessage(message, nil)
  end
end
local function cmdPromoteInactivePerm(args)
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
local function cmdKick(args)
  local name = args[1]
  local target = args[2]

  if not target then return end

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

local function cmdForceLeave(args)
  local name = args[1]
  local target = args[2]

  if mode ~= "gameStart" or not target or (USER_PERMISSIONS[target] or 1) == 5 then
    return
  end

  if (gameStats.teamsMode or gameStats.threeTeamsMode) and
      gameStats.canTransform then
    leaveTeamTeamsMode(target)
    tfm.exec.chatMessage("<vi>" .. target .. " force leave by " .. name ..
      " <n> ", nil)
    return
  end

  if not gameStats.teamsMode then
    leaveTeam(target);
    return tfm.exec.chatMessage("<vi>" .. target .. " force leave by " ..
      name .. " <n> ", nil)
  end

  tfm.exec.chatMessage("<vi>Force leave disabled<n> ", name)
end

local function cmdBan(args)
  local name = args[1]
  local target = args[2]

  if not gameStats.banCommandIsEnabled or not target or
      (USER_PERMISSIONS[target] or 1) > 3 then
    return
  end

  -- target must be attached to an id.
  playerBan[target] = true
  playerBanHistory[target] = name
  tfm.exec.kickPlayer(target)
  tfm.exec.chatMessage("<vi>Banned by " .. name .. " <n> ", target)
  tfm.exec.chatMessage("<vi>" .. name .. " banned " .. target .. " <n> ", nil)

  if mode == "startGame" then
    updateLobbyTexts(target)
    return
  end

  if (gameStats.teamsMode or gameStats.threeTeamsMode) and
      gameStats.canTransform then
    leaveTeamTeamsMode(target)
    return
  end

  if not gameStats.teamsMode then
    leaveTeam(target)
    return
  end
end

local function cmdUnban(args)
  local name = args[1]
  local target = args[2]

  if not target or not playerBan[target] then return end

  playerBan[target] = false
  tfm.exec
      .chatMessage("<vi>" .. name .. " unbanned " .. target .. " <n> ", nil)
end

local function cmdStopTimer(args)
  local name = args[1]
  if mode ~= "startGame" then return end

  if not gameStats.stopTimer then
    gameStats.stopTimer = true
    tfm.exec.chatMessage("<vi>Stoptimer enabled by " .. name .. " <n> ", nil)
    return
  end

  initGame = os.time() + (gameStats.initTimer * 1000)
  gameStats.stopTimer = false
  tfm.exec.chatMessage("<vi>Stoptimer disabled by " .. name .. " <n> ", nil)
end

local function cmdKillSpec(args)
  local name = args[1]
  local kill = args[2]

  if kill ~= "true" and kill ~= "false" then
    tfm.exec
        .chatMessage('<j>Second argument must be true or false<n>', name)
    return
  end

  killSpecPermanent = (kill == "true")
  gameStats.killSpec = kill

  if mode == "gameStart" and killSpecPermanent then
    for n, _ in pairs(tfm.get.room.playerList) do
      if not playerInGame[n] then tfm.exec.killPlayer(n) end
    end
  end
end

local function cmdPause(args)
  local name = args[1]
  if mode ~= "gameStart" or gameStats.realMode then return end

  if not gameStats.isGamePaused then
    gameStats.isGamePaused = true

    ballOnGame = false

    tfm.exec.removeObject(ball_id)

    if ball_id2 then
      ballOnGame2 = false
      tfm.exec.removeObject(ball_id2)
    end
    if ball_id3 then
      ballOnGame3 = false
      tfm.exec.removeObject(ball_id3)
    end

    tfm.exec.chatMessage("<vi>Game paused by " .. name .. " <n> ", nil)
    durationTimerPause = math.ceil((duration - os.time()) / 1000)
    return
  end

  duration = os.time() + durationTimerPause * 1000
  tfm.exec.setGameTime(durationTimerPause, true)
  gameStats.isGamePaused = false
  spawnInitialBall()
end

local function cmdListSync(args)
  local target = args[1]

  -- Another useless loop if the global copy of players state is updated
  -- on the right times: @Vit0rg
  local players = {}

  for player, data in pairs(tfm.get.room.playerList) do
    local latency = data.averageLatency
    players[#players + 1] = {
      name = player,
      sync = latency,
      status = getSyncGrade(latency)
    }
  end

  table.sort(players, function(a, b) return a.sync < b.sync end)

  local str =
  "<font size = '+4' color = '#babd2f'>Sync list: <br><br><font color ='#c2c2da' size = '-2'>"

  local buffer = {}
  local r = 00
  local g = 00
  for i = 1, #players do
    r = math.min(255, players[i].sync)
    g = math.max(0, (255 - players[i].sync))

    local hexColor = string.format("%02x%02x00", r, g)

    buffer[#buffer + 1] = string.format(
      "<font color='#c2c2da'>%s - <font color = '#%s'> %s",
      players[i].name, hexColor, players[i].status)
  end

  str = str .. table.concat(buffer, "\n")

  ui.addPopup(0, 0, str, target, 300, 50, 300, true)
end

local function cmdSetSync(args)
  local name = args[1]
  windowUISync({ name })
end

local function cmdSyncTFM(args)
  local name = args[1]
  -- tfm.exec.setPlayerSync('none')

  local syncPlayer = tfm.exec.getPlayerSync(nil)

  if syncPlayer and tfm.get.room.playerList[syncPlayer] then
    tfm.exec.chatMessage(" <vi>Sync set to TFM default.", nil)
  end
end

local function cmdTeleport(args)
  if #args < 2 then
    tfm.exec.chatMessage('<j> Command needs at least 2 arguments.')
    return
  end

  local name = args[1]
  local target = name

  local colorValues = { yellow = 200, blue = 400, red = 600, green = 1000 }

  local x = colorValues[args[2]] or tonumber(args[2]) or 600
  local y = tonumber(args[3]) or 350

  if #args == 4 then
    target = args[2]
    x = colorValues[args[3]] or tonumber(args[3]) or 600
    y = (colorValues[args[4]] or tonumber(args[4])) or 350
  end

  tfm.exec.movePlayer(target, x, y)
  tfm.exec.chatMessage("<vi>" .. name .. " teleported the player " .. target .. "<n>",
    nil)
end

-- Dispatcher (Unified Command Table)
COMMANDS = {
  -- Everyone (Level 1)
  {
    ["commands"] = cmdCommands,
    ["c"] = cmdCommands,
    ["join"] = cmdJoin,
    ["j"] = cmdJoin,
    ["leave"] = cmdLeave,
    ["l"] = cmdLeave,
    ["lang"] = cmdLang,
    ["la"] = cmdLang,
    ["admins"] = cmdAdmins,
    ["ads"] = cmdAdmins,
    ["balls"] = cmdBalls,
    ["b"] = cmdBalls,
    ["votemap"] = cmdVoteMap,
    ["vm"] = cmdVoteMap,
    ["crown"] = cmdCrown,
    ["cr"] = cmdCrown,
    ["profile"] = cmdProfile,
    ["pr"] = cmdProfile,
    ["discord"] = cmdDiscord,
    ["dc"] = cmdDiscord,
    ["maps"] = cmdMaps,
    ["m"] = cmdMaps,
    ["setoffset"] = cmdDisabledOrUnavailable,
    ["so"] = cmdDisabledOrUnavailable,
    ["settransformduration"] = cmdSetTransformDuration,
    ["sd"] = cmdSetTransformDuration,
  },
  -- Admin Commands (Level 2)
  {
    ["resettimer"] = cmdResetTimer,
    ["re"] = cmdResetTimer,
    ["setduration"] = cmdSetDuration,
    ["sd"] = cmdSetDuration,
    ["skiptimer"] = cmdSkipTimer,
    ["skip"] = cmdSkipTimer,
    ["stoptimer"] = cmdStopTimer,
    ["stop"] = cmdStopTimer,
    ["setmaxplayers"] = cmdSetMaxPlayers,
    ["smp"] = cmdSetMaxPlayers,
    ["setmap"] = cmdSetMap,
    ["sm"] = cmdSetMap,
    ["winscore"] = cmdWinScore,
    ["w"] = cmdWinScore,
    ["pw"] = cmdPassword,
    ["randommap"] = cmdRandomMap,
    ["ra"] = cmdRandomMap,
    ["custommap"] = cmdCustomMap,
    ["cm"] = cmdCustomMap,
    ["setscore"] = cmdSetScore,
    ["ssc"] = cmdSetScore,

    ["4teamsmode"] = cmdSetTeamMode,
    ["fourteamsmode"] = cmdSetTeamMode,
    ["fom"] = cmdSetTeamMode,
    ["2teamsmode"] = cmdSetTeamMode,
    ["twoteamsmode"] = cmdSetTeamMode,
    ["twm"] = cmdSetTeamMode,
    ["3teamsmode"] = cmdSetTeamMode,
    ["threeteamsmode"] = cmdSetTeamMode,
    ["thm"] = cmdSetTeamMode,
    ["realmode"] = cmdSetTeamMode,
    ["rm"] = cmdSetTeamMode,

    ["admin"] = cmdAdmin,
    ["a"] = cmdAdmin,
    ["unadmin"] = cmdUnadmin,
    ["ua"] = cmdUnadmin,

    ["randomball"] = cmdRandomBall,
    ["rb"] = cmdRandomBall,
    ["customball"] = cmdCustomBall,
    ["cb"] = cmdCustomBall,

    ["lobby"] = cmdLobby,
    ["lo"] = cmdLobby,

    ["autosyncsys"] = cmdAutoSyncSystem,
    ["asy"] = cmdAutoSyncSystem,
    ["sync"] = cmdSync,
    ["sy"] = cmdSync,
    ["setsync"] = cmdSetSync,
    ["ssy"] = cmdSetSync,
    ["synctfm"] = cmdSyncTFM,
    ["syt"] = cmdSyncTFM,

    ["setplayerforce"] = cmdSetPlayerForce,
    ["spf"] = cmdSetPlayerForce,
    ["np"] = cmdNP,
    ["test"] = cmdTest,
    ["t"] = cmdTest,

    ["twoballs"] = cmdTwoBalls,
    ["twb"] = cmdTwoBalls,
    ["threeballs"] = cmdThreeBalls,
    ["thb"] = cmdThreeBalls,

    ["consumables"] = cmdConsumables,
    ["co"] = cmdConsumables,

    ["settings"] = cmdSettings,
    ["se"] = cmdSettings
  },
  -- Permanent Admins Only (Level 3+)
  {
    ["announcement"] = cmdBroadcast,
    ["a"] = cmdBroadcast,
    ["padmin"] = cmdPromoteInactivePerm,
    ["pa"] = cmdPromoteInactivePerm,
    ["pause"] = cmdPause,
    ["p"] = cmdPause,
    ["setlifes"] = cmdSetLifes,
    ["sl"] = cmdSetLifes,
    ["kick"] = cmdKick,
    ["ki"] = cmdKick,
    ["fleave"] = cmdForceLeave,
    ["fl"] = cmdForceLeave,
    ["ban"] = cmdBan,
    ["ba"] = cmdBan,
    ["unban"] = cmdUnban,
    ["ub"] = cmdUnban,
    ["killspec"] = cmdKillSpec,
    ["ks"] = cmdKillSpec,
    ["teleport"] = cmdTeleport,
    ["tp"] = cmdTeleport,
    ["listsync"] = cmdListSync,
    ["lsy"] = cmdListSync
  }
}

-- Main handler
function eventChatCommand(name, c)
  local args = split(c)
  local cmdName = string.lower(args[1])
  args[1] = name

  local userLevel = USER_PERMISSIONS[name] or 1
  local max_depth = math.min(userLevel, 3)


  local handler = nil
  for i = 1, max_depth do
    if COMMANDS[i] and COMMANDS[i][cmdName] then
      handler = COMMANDS[i][cmdName]
      break
    end
  end

  if not handler then
    cmdDisabledOrUnavailable(args)
    return false
  end


  args[#args + 1] = cmdName
  handler(args)
end
