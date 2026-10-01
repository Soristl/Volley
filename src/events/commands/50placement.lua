function commandHandlers.cmdListSync(args)
  local target = args[1]

  -- Another useless loop if the global copy of players state is updated
  -- on the right times: @Vit0rg
  local players = {}

  for player, data in pairs(tfm.get.room.playerList) do
    local latency = getSyncLatency(data.averageLatency)
    players[#players + 1] = {
      name = player,
      sync = latency or math.huge,
      status = getSyncGrade(latency)
    }
  end

  table.sort(players, function(a, b)
    return a.sync == b.sync and a.name < b.name or a.sync < b.sync
  end)

  local str =
  "<font size = '+4' color = '#babd2f'>Sync list: <br><br><font color ='#c2c2da' size = '-2'>"

  local buffer = {}
  for i = 1, #players do
    local hexColor = '9ca3af'
    if players[i].sync < math.huge then
      local r = math.floor(math.min(255, players[i].sync))
      hexColor = string.format("%02x%02x00", r, 255-r)
    end

    buffer[#buffer + 1] = string.format(
      "<font color='#c2c2da'>%s - <font color = '#%s'> %s",
      players[i].name, hexColor, players[i].status)
  end

  str = str .. table.concat(buffer, "\n")

  ui.addPopup(0, 0, str, target, 300, 50, 300, true)
end

function commandHandlers.cmdSetSync(args)
  local name = args[1]
  windowUISync({ name })
end

function commandHandlers.cmdSyncTFM(args)
  local name = args[1]
  local ok = pcall(tfm.exec.setPlayerSync, nil)
  if not ok then
    tfm.exec.chatMessage("<r>Unable to request default sync in this room.<n>", name)
    return
  end
  tfm.exec.chatMessage("<vi>Default sync selection requested from TFM.<n>", nil)
end

function commandHandlers.cmdTeleport(args)
  local name = args[1]
  -- The final argument is the command name added by the dispatcher.
  if #args ~= 3 and #args ~= 4 then
    tfm.exec.chatMessage('<j>Usage: !tp [Player#0000] red|blue|yellow|green<n>', name)
    return
  end
  if gameState.phase ~= 'gameStart' then
    tfm.exec.chatMessage('<j>Teleport is available during a match.<n>', name)
    return
  end
  if not isGameplayMapReady() or
      ((gameStats.teamsMode or gameStats.threeTeamsMode) and not gameStats.canTransform) then
    tfm.exec.chatMessage('<j>Please wait until the court is ready before teleporting.<n>', name)
    return
  end
  local target = name
  if #args == 4 then
    target = nil
    for player in pairs(tfm.get.room.playerList) do
      if player:lower() == args[2]:lower() then target = player; break end
    end
  end
  if not target or playerLeft[target] or playerBan[target] or tfm.get.room.playerList[target].isDead then
    tfm.exec.chatMessage('<j>Player not found or dead.<n>', name)
    return
  end
  local aliases = {red='red', rouge='red', blue='blue', bleu='blue', yellow='yellow', jaune='yellow', green='green', vert='green'}
  local color = aliases[args[#args - 1]:lower()]
  local groups = {yellow=gameState.teams.yellow, red=gameState.teams.red, blue=gameState.teams.blue, green=gameState.teams.green}
  local spawns, x
  if gameStats.teamsMode or gameStats.threeTeamsMode then
    local slot
    if gameStats.typeMap == 'large4v4' then
      local slots = gameStats.threeTeamsMode and {red=1,blue=2,green=3} or {yellow=1,red=2,blue=3,green=4}
      slot = slots[color]
    else
      for i, team in ipairs(teamsPlayersOnGame or {}) do
        if groups[color] and team == groups[color] then slot = i; break end
      end
    end
    if slot then
      spawns = ({playersSpawn400,playersSpawn800,playersSpawn1200,playersSpawn1600})[slot]
      local width = gameStats.threeTeamsMode and 600 or 400
      x = width * (slot - 0.5)
    end
  elseif color == 'red' or color == 'blue' then
    local red = color == 'red'
    if gameStats.realMode then
      x = red and 900 or 1700
    elseif gameStats.twoTeamsMode then
      spawns = red and playersSpawn800 or playersSpawn1200
      x = red and 600 or 1000
    elseif gameStats.gameMode == '3v3' then
      spawns = red and playersSpawn400 or playersSpawn800
      x = red and 101 or 700
    elseif gameStats.gameMode == '4v4' then
      spawns = red and playersSpawn800 or playersSpawn1600
      x = red and 301 or 900
    else
      x = red and 401 or 1500
    end
  end
  if not x then
    tfm.exec.chatMessage('<j>Unknown team or team unavailable on this map.<n>', name)
    return
  end
  local y = 334
  -- Read spawn coordinates without registering the player in another team's
  -- spawn occupancy, roster, colours, or match history.
  if spawns and #spawns > 0 then
    local chosen = spawns[1]
    for i = 2, #spawns do
      local candidate = spawns[i]
      local count, best = #(candidate.players or {}), #(chosen.players or {})
      if count < best or (count == best and (candidate.spawnPriority or 0) < (chosen.spawnPriority or 0)) then
        chosen = candidate
      end
    end
    x, y = chosen.x, chosen.y
  end
  tfm.exec.movePlayer(target, x, y, false, 0, 0, false)
  tfm.exec.chatMessage('<vi>' .. target .. ' teleported to ' .. color .. ' spawn by ' .. name .. '.<n>', nil)
end
