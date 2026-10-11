function commandHandlers.resolveAdminTarget(target)
  if not target then return end
  local lowerTarget = string.lower(target)
  for player in pairs(tfm.get.room.playerList) do
    if string.lower(player) == lowerTarget then return player end
  end
  for player in pairs(roomConfig.permissions) do
    if string.lower(player) == lowerTarget then return player end
  end
end

function commandHandlers.cmdAdmin(args)
  local name = args[1]
  local target = commandHandlers.resolveAdminTarget(args[2])

  if not target or not tfm.get.room.playerList[target] or target:find("*", 1, true)
    or (roomConfig.permissions[target] or 1) > 1 then return end

  roomConfig.permissions[target] = 2
  if target == roomConfig.creator.name then
    roomConfig.creator.adminRevoked = false
  end
  tfm.exec.chatMessage("<bv>" .. target .. " made admin by " .. name .. " <n> ", nil)
end

function commandHandlers.cmdUnadmin(args)
  local name = args[1]
  local target = args[2]
  local userLevel = roomConfig.permissions[name] or 1

  if not target then return end
  if string.lower(target) == "all" then
    if userLevel < 3 then return end
    for admin, permission in pairs(roomConfig.permissions) do
      if permission == 2 then
        roomConfig.permissions[admin] = 1
        if admin == roomConfig.creator.name then
          roomConfig.creator.adminRevoked = true
        end
        clubhouse.closeLegacyWindow(31, admin)
      end
    end
    tfm.exec.chatMessage("<rose>Admin list reset by " .. name .. " <n> ", nil)
    return
  end

  target = commandHandlers.resolveAdminTarget(target)
  if not target or target:find("*", 1, true) or (roomConfig.permissions[target] or 1) ~= 2 then
    return
  end
  if target == roomConfig.creator.name and userLevel < 3 then
    tfm.exec.chatMessage("<rose>Only temporary permanent and permanent admins can remove the Room Creator's admin rights.<n>", name)
    return
  end

  roomConfig.permissions[target] = 1
  if target == roomConfig.creator.name then
    roomConfig.creator.adminRevoked = true
  end
  clubhouse.closeLegacyWindow(31, target)
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

  if gameState.match.mode.realMode then
    roomConfig.commandUnavailable({ " <bv>Not available in Real Mode<n> ", name })
    return
  end

  gameState.match.maps.isCustomMap = isRandom == "true"
  gameState.match.maps.randomMap = isRandom == "true"

  if isRandom == "false" then
    gameState.match.maps.customMapIndex = 0
    tfm.exec.chatMessage(
      "<bv>Random map deactivated by:" .. name .. " <n> ", nil)
    return
  end

  local list = ((gameState.match.mode.twoTeamsMode or gameState.match.mode.teamsMode) and customMapsFourTeamsMode) or
      (gameState.match.mode.threeTeamsMode and customMapsThreeTeamsMode) or
      customMaps

  local _, indices = gameMaps.availableEntries()
  if #indices == 0 then
    gameState.match.maps.isCustomMap, gameState.match.maps.randomMap = false, false
    tfm.exec.chatMessage('<j>No maps available at the selected size.<n>', name)
    return
  end
  local index = indices[math.random(1, #indices)]
  gameState.match.maps.customMapIndex = index
  local mapInfo = list[index]
  tfm.exec.chatMessage('<bv>' .. mapInfo[3] .. ' (by ' .. mapInfo[4] ..
    ') selected randomly<n> ', nil)

  -- Seriously, the UI update idea with the iteration is so
  -- bad that removing it seems to be the best optimization.
  -- If not even React could figure out a way to properly
  -- handle UI updates, imagine a dead game with an outdated
  -- API. @Vit0rg

  -- for n, _ in pairs(tfm.get.room.playerList) do
  --  if selectMapOpen[n] then clubhouse.mapSelector(n) end
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

  gameState.match.balls.customBall = isRandom == "true"

  if isRandom == "true" then
    local index = math.random(1, #balls)
    gameState.match.balls.customBallId = index
    tfm.exec.chatMessage("<bv>Random ball: " .. balls[index].name ..
      " enabled by " .. name .. " <n> ", nil)
    return
  end

  gameState.match.balls.customBallId = 11
  tfm.exec.chatMessage("<bv>Random ball deactivated by " .. name .. " <n> ",
    nil)
end

function commandHandlers.cmdCustomMap(args)
  local name = args[1]
  local isCustomMap = args[2]

  if gameState.phase ~= "startGame" then return end

  if gameState.match.mode.realMode then
    roomConfig.commandUnavailable({ "<bv>Not available in Real Mode<n> ", name })
    return
  end

  if isCustomMap ~= "false" and (type(tonumber(isCustomMap)) ~= "number") then
    tfm.exec.chatMessage('<j>Second argument must be a number or false<n>', name)
    return
  end

  if isCustomMap == "false" then
    gameState.match.maps.isCustomMap = false
    gameState.match.maps.randomMap = false
    gameState.match.maps.customMapIndex = 1
    return
  end

  local list = (gameState.match.mode.twoTeamsMode or gameState.match.mode.teamsMode) and customMapsFourTeamsMode or
      gameState.match.mode.threeTeamsMode and customMapsThreeTeamsMode or
      customMaps

  local index = tonumber(isCustomMap)
  if index ~= index or index % 1 ~= 0 or index < 1 or index > #list then
    tfm.exec.chatMessage('<j>Index out of range (1-' .. #list .. ')<n>',
      name)
    return
  end

  if not gameMaps.isAvailable(index) then
    tfm.exec.chatMessage('<j>This map is unavailable at the selected size.<n>', name)
    return
  end
  gameState.match.maps.isCustomMap = true
  gameState.match.maps.randomMap = false
  gameState.match.maps.customMapIndex = index
  local mapInfo = list[index]
  tfm.exec.chatMessage(' <vp>' .. mapInfo[3] .. '<n2> (by ' .. mapInfo[4] ..
    ') selected by <d>' .. name .. ' <n> ', nil)

  -- Same case of randommap UI update. @Vit0rg
  -- for n, _ in pairs(tfm.get.room.playerList) do
  --  if selectMapOpen[n] then clubhouse.mapSelector(n) end
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

  gameState.match.balls.customBall = true
  gameState.match.balls.customBallId = index
  tfm.exec.chatMessage(" <bv>Ball: " .. balls[gameState.match.balls.customBallId].name ..
    " selected by " .. name .. " <n> ", nil)
end

function commandHandlers.cmdTwoBalls(args)
  if gameState.phase ~= "startGame" or gameState.match.mode.realMode then return end
  local name = args[1]
  local toggle = args[2]

  if toggle ~= "true" and toggle ~= "false" then
    tfm.exec.chatMessage('<bv>Must be true or false<n>', name)
    return
  end

  gameState.match.balls.twoBalls = (toggle == "true")
  tfm.exec.chatMessage("<n>Two balls " ..
    (gameState.match.balls.twoBalls and "<vp>enabled<n2>" or
      "<r>disabled<n2>") .. " by " .. name .. " <n> ",
    nil)
end

function commandHandlers.cmdThreeBalls(args)
  if gameState.phase ~= "startGame" or not gameState.match.mode.threeTeamsMode then return end
  local name = args[1]
  local toggle = args[2]

  if toggle ~= "true" and toggle ~= "false" then
    tfm.exec.chatMessage('<bv>Must be true or false<n>', name)
    return
  end

  gameState.match.balls.threeBalls = (toggle == "true")
  tfm.exec.chatMessage("<n>Three balls " ..
    (gameState.match.balls.threeBalls and "<vp>enabled<n2>" or
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

  gameState.match.rules.physicObjectForce = force
  tfm.exec.chatMessage(
    "<n>Player force set to <bv>" .. force .. "<n2> by " .. name .. " <n> ",
    name)
end

function commandHandlers.cmdConsumables(args)
  if gameState.phase ~= "startGame" then return end
  local name = args[1]

  if gameState.match.mode.teamsMode or gameState.match.mode.twoTeamsMode or gameState.match.mode.threeTeamsMode or gameState.match.mode.realMode then
    tfm.exec
        .chatMessage("<j>Consumables only work in normal mode<n> ", name)
    return
  end

  local toggle = tostring(args[2])
  if toggle ~= "true" and toggle ~= "false" then
    tfm.exec.chatMessage('<bv>Must be true or false<n>', name)
    return
  end

  gameState.match.rules.consumables = (toggle == "true")
  tfm.exec.chatMessage(" <n>Consumables " ..
    (gameState.match.rules.consumables and "<vp>enabled<n2>" or
      "<r>disabled<n2>") .. " by " .. name .. " <n> ",
    nil)
end

do
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

local modeLabels = {
  ['twoTeamsMode'] = '2-team mode',
  ['threeTeamsMode'] = '3-team mode',
  ['teamsMode'] = '4-team mode',
  ['realMode'] = 'Real mode'
}

-- Lives are mutable during play, so each successful transition gets fresh tables.
local function newModeLives(mode, enabling)
  if enabling and mode == 'threeTeamsMode' then
    return {[1] = {yellow = 0 }, [2] = { red = 5 }, [3] = { blue = 5 }, [4] = { green = 5 } }
  end
  return {
    [1] = { yellow = 3 },
    [2] = { red = 3 },
    [3] = { blue = 3 },
    [4] = { green = 3 }
  }
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

  local _mode = command_to_mode[args[3]] or ''

  if not modeLabels[_mode] then
    tfm.exec.chatMessage(
      '<vi>Critical error, mode not implemented or wrong argument.')
    return
  end


  local enabling = toggle == 'true'
  if gameState.match.mode[_mode] == enabling then
    tfm.exec.chatMessage('<j>Mode already ' .. (enabling and 'enabled: ' or 'disabled: ') .. modeLabels[_mode], name)
    return
  end

  if enabling and commandHandlers.checkModeConflict({ name, _mode }) then return end

  gameState.match.round.canJoin = false
  gameState.match.maps.isCustomMap = false
  gameState.match.maps.customMapIndex = 0

  gameState.match.mode[_mode] = enabling
  if enabling then
    gameState.match.rules.consumables = false
    gameState.match.maps.setMapName = ''
  end
  if gameState.match.mode.realMode then gameState.match.balls.twoBalls = false end
  if not gameState.match.mode.threeTeamsMode then gameState.match.balls.threeBalls = false end

  gameState.lives = newModeLives(_mode, enabling)
  gameMaps.resetTestMaps()
  mapVoting.resetMapList()
  clubhouse.refreshLobbyPlayers(nil,name)

  tfm.exec.chatMessage(" <n>" .. modeLabels[_mode] ..
    (toggle == 'true' and " <vp>enabled<n2>" or
      " <r>disabled<n2>") .. " by " .. name ..
    " <n2> ", nil)
end
end

function commandHandlers.cmdSettings(args)
  local name = args[1]

  clubhouse.closeWindows(name)
  uiState.settings[name] = true
  clubhouse.refreshSettings(name)
end

-- PERMANENT ADMIN COMMANDS
