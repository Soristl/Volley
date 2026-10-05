function commandHandlers.resolveAdminTarget(target)
  if not target then return end
  local lowerTarget = string.lower(target)
  for player in pairs(tfm.get.room.playerList) do
    if string.lower(player) == lowerTarget then return player end
  end
  for player in pairs(USER_PERMISSIONS) do
    if string.lower(player) == lowerTarget then return player end
  end
end

function commandHandlers.cmdAdmin(args)
  local name = args[1]
  local target = commandHandlers.resolveAdminTarget(args[2])

  if not target or not tfm.get.room.playerList[target] or target:find("*", 1, true)
    or (USER_PERMISSIONS[target] or 1) > 1 then return end

  USER_PERMISSIONS[target] = 2
  if target == roomCreator.name then
    roomCreator.adminRevoked = false
  end
  tfm.exec.chatMessage("<bv>" .. target .. " made admin by " .. name .. " <n> ", nil)
end

function commandHandlers.cmdUnadmin(args)
  local name = args[1]
  local target = args[2]
  local userLevel = USER_PERMISSIONS[name] or 1

  if not target then return end
  if string.lower(target) == "all" then
    if userLevel < 3 then return end
    for admin, permission in pairs(USER_PERMISSIONS) do
      if permission == 2 then
        USER_PERMISSIONS[admin] = 1
        if admin == roomCreator.name then
          roomCreator.adminRevoked = true
        end
        closeWindow(31, admin)
      end
    end
    tfm.exec.chatMessage("<rose>Admin list reset by " .. name .. " <n> ", nil)
    return
  end

  target = commandHandlers.resolveAdminTarget(target)
  if not target or target:find("*", 1, true) or (USER_PERMISSIONS[target] or 1) ~= 2 then
    return
  end
  if target == roomCreator.name and userLevel < 3 then
    tfm.exec.chatMessage("<rose>Only temporary permanent and permanent admins can remove the Room Creator's admin rights.<n>", name)
    return
  end

  USER_PERMISSIONS[target] = 1
  if target == roomCreator.name then
    roomCreator.adminRevoked = true
  end
  closeWindow(31, target)
  tfm.exec.chatMessage("<vi>" .. target .. " removed from admin by " .. name .. " <n> ", nil)
end

function commandHandlers.cmdRandomMap(args)
  local name = args[1]
  local isRandom = args[2]

  if isRandom ~= "true" and isRandom ~= "false" then
    tfm.exec.chatMessage('<bv>Must be true or false<n>', name)
    return
  end

  if gameState.phase ~= "startGame" then return end

  if gameStats.realMode then
    commandNotAvailable({ " <bv>Not available in Real Mode<n> ", name })
    return
  end

  gameStats.isCustomMap = isRandom == "true"
  gameStats.randomMap = isRandom == "true"

  if isRandom == "false" then
    gameStats.customMapIndex = 0
    tfm.exec.chatMessage(
      "<bv>Random map deactivated by:" .. name .. " <n> ", nil)
    return
  end

  local list = ((gameStats.twoTeamsMode or gameStats.teamsMode) and customMapsFourTeamsMode) or
      (gameStats.threeTeamsMode and customMapsThreeTeamsMode) or
      customMaps

  local _, indices = availableMaps()
  if #indices == 0 then
    gameStats.isCustomMap, gameStats.randomMap = false, false
    tfm.exec.chatMessage('<j>No maps available at the selected size.<n>', name)
    return
  end
  local index = indices[math.random(1, #indices)]
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

function commandHandlers.cmdRandomBall(args)
  local name = args[1]
  local isRandom = args[2]

  if gameState.phase ~= "startGame" then return end

  if isRandom ~= "true" and isRandom ~= "false" then
    tfm.exec.chatMessage('<bv>Must be true or false<n>', name)
    return
  end

  gameStats.customBall = isRandom == "true"

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

function commandHandlers.cmdCustomMap(args)
  local name = args[1]
  local isCustomMap = args[2]

  if gameState.phase ~= "startGame" then return end

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
    gameStats.randomMap = false
    gameStats.customMapIndex = 1
    return
  end

  local list = (gameStats.twoTeamsMode or gameStats.teamsMode) and customMapsFourTeamsMode or
      gameStats.threeTeamsMode and customMapsThreeTeamsMode or
      customMaps

  local index = tonumber(isCustomMap)
  if index ~= index or index % 1 ~= 0 or index < 1 or index > #list then
    tfm.exec.chatMessage('<j>Index out of range (1-' .. #list .. ')<n>',
      name)
    return
  end

  if not isMapAvailable(index) then
    tfm.exec.chatMessage('<j>This map is unavailable at the selected size.<n>', name)
    return
  end
  gameStats.isCustomMap = true
  gameStats.randomMap = false
  gameStats.customMapIndex = index
  local mapInfo = list[index]
  tfm.exec.chatMessage(' <vp>' .. mapInfo[3] .. '<n2> (by ' .. mapInfo[4] ..
    ') selected by <d>' .. name .. ' <n> ', nil)

  -- Same case of randommap UI update. @Vit0rg
  -- for n, _ in pairs(tfm.get.room.playerList) do
  --  if selectMapOpen[n] then selectMapUI(n) end
  -- end
end

function commandHandlers.cmdCustomBall(args)
  local name = args[1]
  local index = tonumber(args[2])

  if gameState.phase ~= "startGame" then return end

  if not index or index ~= index or index % 1 ~= 0 or index < 1 or index > #balls then
    tfm.exec.chatMessage('<bv>Invalid ball index (1-' .. #balls .. ')<n>',
      name)
    return
  end

  index = math.floor(index)

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

function commandHandlers.cmdTwoBalls(args)
  if gameState.phase ~= "startGame" or gameStats.realMode then return end
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

function commandHandlers.cmdThreeBalls(args)
  if gameState.phase ~= "startGame" or not gameStats.threeTeamsMode then return end
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

function commandHandlers.cmdSetPlayerForce(args)
  if gameState.phase ~= "startGame" then return end

  local name = args[1]
  local force = tonumber(args[2])

  if not force or force ~= force or force < 0 or force > 1.05 then
    tfm.exec.chatMessage('<j>Force must be between 0 and 1.05<n>', name)
    return
  end

  gameStats.physicObjectForce = force
  tfm.exec.chatMessage(
    "<n>Player force set to <bv>" .. force .. "<n2> by " .. name .. " <n> ",
    name)
end

function commandHandlers.cmdConsumables(args)
  if gameState.phase ~= "startGame" then return end
  local name = args[1]

  if gameStats.teamsMode or gameStats.twoTeamsMode or gameStats.threeTeamsMode or gameStats.realMode then
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

function commandHandlers.cmdSetTeamMode(args)
  local name = args[1]
  local toggle = args[2]

  if gameState.phase ~= "startGame" then
    tfm.exec.chatMessage('<bv>You can only change the game mode in the lobby<n>', name)
    return
  end

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
    },
    ['threeTeamsMode'] = {
      alias = '3-team mode',
      lives = {[1] = {yellow = 0 }, [2] = { red = 5 }, [3] = { blue = 5 }, [4] = { green = 5 } }
    },
    ['teamsMode'] = {
      alias = '4-team mode',
      lives = {
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


  local enabling = toggle == 'true'
  if gameStats[_mode] == enabling then
    tfm.exec.chatMessage('<j>Mode already ' .. (enabling and 'enabled: ' or 'disabled: ') .. modes[_mode].alias, name)
    return
  end

  if enabling and commandHandlers.checkModeConflict({ name, _mode }) then return end

  gameStats.canJoin = false
  gameStats.isCustomMap = false
  gameStats.customMapIndex = 0

  gameStats[_mode] = enabling
  if enabling then
    gameStats.consumables = false
    gameStats.setMapName = ''
  end
  if gameStats.realMode then gameStats.twoBalls = false end
  if not gameStats.threeTeamsMode then gameStats.threeBalls = false end

  gameState.lives = (enabling and modes[_mode].lives) or modes['teamsMode'].lives
  resetMapsToTest()
  resetMapsList()
  updateLobbyTextAreas(nil,name)

  tfm.exec.chatMessage(" <n>" .. modes[_mode].alias ..
    (toggle == 'true' and " <vp>enabled<n2>" or
      " <r>disabled<n2>") .. " by " .. name ..
    " <n2> ", nil)
end

function commandHandlers.cmdSettings(args)
  local name = args[1]

  closeAllWindows(name)
  settings[name] = true
  updateSettingsUI(name)
end

-- PERMANENT ADMIN COMMANDS
