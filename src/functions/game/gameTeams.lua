-- Shared team operations. All readers use the stable gameState.teams rosters.
gameTeams = {}
do
  local details = {
    yellow={slot=1, color=0xF59E0B, tag='<j>', title='Yellow'},
    red={slot=2, color=0xEF4444, tag='<r>', title='Red'},
    blue={slot=3, color=0x3B82F6, tag='<bv>', title='Blue'},
    green={slot=4, color=0x109267, tag='<vp>', title='Green'}
  }
  function gameTeams.color(key) return details[key] and details[key].color end
  function gameTeams.lifeSlot(key) return details[key] and details[key].slot end
  function gameTeams.label(key)
    local team = details[key]
    return team and team.tag .. 'Team ' .. team.title .. '<n>'
  end
  function gameTeams.message(key, suffix)
    local team = details[key]
    return team and team.tag .. team.title .. ' team ' .. suffix .. '<n>'
  end
end

function gameTeams.keyAt(index)
  return gameTeams.keyForRoster(teamsPlayersOnGame[index])
end

function gameTeams.mode()
  if gameStats.teamsMode then return 'four' end
  if gameStats.threeTeamsMode then return 'three' end
  if gameStats.twoTeamsMode then return 'two' end
  if gameStats.realMode then return 'real' end
  return 'normal'
end

function gameTeams.rosters()
  return gameState.teams
end

function gameTeams.eliminate(roster)
  local removed, seen = 0, {}
  for _, slot in ipairs(roster or {}) do
    local name = slot.name
    slot.name = ''
    if name and name ~= '' and not seen[name] then
      seen[name] = true
      removed = removed + 1
      playerInGame[name] = false
      gameCrowns.clearSubject(name)
      clearPlayerTimers(name)
      clearPlayerGameplay(name)
      removePlayerOnSpawnConfig(name)
      -- Empty roster slots and disconnected players are not API targets.
      local player = tfm.get.room.playerList[name]
      if player and not playerLeft[name] and not playerBan[name] then
        tfm.exec.setNameColor(name, 0xD1D5DB)
        if killSpecPermanent then
          tfm.exec.killPlayer(name)
        else
          if player.isDead then tfm.exec.respawnPlayer(name) end
          teleportPlayersToSpecWithSpecificSpawn(name)
        end
      end
    end
  end
  return removed
end

function gameTeams.resetRoster(key, capacity)
  local roster = gameState.teams[key]
  if not roster or type(capacity) ~= 'number' or capacity < 0
    or capacity > 6 or capacity % 1 ~= 0 then return false end
  -- Keep roster identity: reduced courts, services and UI may hold a reference.
  for index=#roster,1,-1 do roster[index] = nil end
  for index=1,capacity do roster[index] = { name = '' } end
  return true
end

function gameTeams.keys()
  local mode = gameTeams.mode()
  if mode == 'four' then return {'yellow','red','blue','green'} end
  if mode == 'three' then return {'red','blue','green'} end
  return {'red','blue'}
end

function gameTeams.keyForRoster(roster)
  for key, current in pairs(gameTeams.rosters()) do if current == roster then return key end end
end


function gameTeams.count(roster, availableOnly)
  local count = 0
  for _, slot in ipairs(roster or {}) do
    if slot.name ~= '' and (not availableOnly or
      (tfm.get.room.playerList[slot.name] and not playerLeft[slot.name])) then count = count + 1 end
  end
  return count
end

function gameTeams.find(name)
  if not name or name == '' then return nil end
  local rosters = gameTeams.rosters()
  for _, key in ipairs(gameTeams.keys()) do
    for index, slot in ipairs(rosters[key]) do
      if slot.name == name then return key, index end
    end
  end
end

function gameTeams.place(name, key, area, fallbackX)
  local markers = ({playersSpawn400,playersSpawn800,playersSpawn1200,playersSpawn1600})[area]
  if markers and #markers > 0 then teleportPlayerWithSpecificSpawn(markers, name)
  else
    removePlayerOnSpawnConfig(name)
    tfm.exec.movePlayer(name, fallbackX, 334)
  end
  tfm.exec.setNameColor(name, gameTeams.color(key))
end

-- Positions are expressed in the map's native coordinates, not its artwork.
function gameTeams.positions(key)
  local mode = gameTeams.mode()
  if mode == 'two' then
    if key == 'red' then return {{2,600,'middle'},{4,1400,'back'}} end
    return {{3,1000,'middle'},{1,200,'back'}}
  end
  if mode == 'real' then return {{0,key == 'red' and 900 or 1700}} end
  if mode == 'four' or mode == 'three' then
    for index, current in ipairs(gameTeams.keys()) do
      if current == key then return {{index,mode == 'four' and (index*400-200) or (index*600-300)}} end
    end
  end
  if gameStats.gameMode == '3v3' then return key=='red' and {{1,101}} or {{2,700}} end
  if gameStats.gameMode == '4v4' then return key=='red' and {{2,301}} or {{4,900}} end
  return {{0,key=='red' and 401 or 1500}}
end

function gameTeams.placeMember(name)
  local key,slot=gameTeams.find(name)
  if not key then return false end
  local mode=gameTeams.mode()
  if (mode=='four' or mode=='three') and gameStats.typeMap~='large4v4' then
    for index,roster in ipairs(teamsPlayersOnGame) do
      if gameTeams.keyForRoster(roster)==key then
        local width=mode=='three' and 600 or 400
        gameTeams.place(name,key,index,index*width-width/2)
        return true
      end
    end
    return false
  end
  local positions=gameTeams.positions(key)
  local position=positions[1]
  if mode=='two' then
    local roles=key=='red' and twoTeamsPlayerRedPosition or twoTeamsPlayerBluePosition
    if roles[slot]=='back' then position=positions[2] end
  end
  gameTeams.place(name,key,position[1],position[2])
  return true
end

-- Join helpers remain private: callers only commit through gameTeams.join.
do
  local function joinCapacity(mode, reduced, roster)
    if reduced then return #roster end
    if mode == 'four' then return 3 end
    if mode == 'three' then return 4 end
    if mode == 'two' or mode == 'real' then return 6 end
    return maxPlayers()
  end

  local function chooseJoinSlot(mode, multi, reduced)
    local chosenKey, chosenRoster, chosenArea, smallest, emptySlot
    local rosters = not reduced and gameTeams.rosters()
    -- Keep court order and the first empty slot; only allocate the final choice.
    for area, candidate in ipairs(reduced and teamsPlayersOnGame or gameTeams.keys()) do
      local key, roster
      if reduced then
        key, roster = gameTeams.keyForRoster(candidate), candidate
      else
        key, roster = candidate, rosters[candidate]
      end
      if key then
        local count = gameTeams.count(roster)
        if (not multi or count > 0) and count < joinCapacity(mode, reduced, roster)
            and (not smallest or count < smallest) then
          for index, slot in ipairs(roster) do
            if slot.name == '' then
              chosenKey, chosenRoster, chosenArea = key, roster, reduced and area or nil
              smallest, emptySlot = count, index
              break
            end
          end
        end
      end
    end
    return chosenKey and {key=chosenKey, roster=chosenRoster, area=chosenArea}, emptySlot
  end

  local function recordJoin(name, key, mode)
    playersOnGameHistoric[name] = playersOnGameHistoric[name] or {teams={}}
    if playerHistoryOnMatch(key, name) then
      local history = playersOnGameHistoric[name].teams
      history[#history+1] = key
    end
    local addMatch = ({normal=addMatchToPlayer, two=addMatchToPlayerTwoTeamsMode,
      three=addMatchToPlayerThreeTeamsMode, four=addMatchToPlayerFourTeamsMode,
      real=addMatchToPlayerRealMode})[mode]
    addMatch(name)
  end

  local function assignJoinPosition(name, chosen, slot, mode, reduced)
    if reduced then
      local width = mode == 'three' and 600 or 400
      gameTeams.place(name, chosen.key, chosen.area, chosen.area * width - width / 2)
      return
    end
    local positions = gameTeams.positions(chosen.key)
    local position = positions[1]
    if mode == 'two' then
      local counts = getQuantityPlayersOnPosition(chosen.key)
      if counts.back < counts.middle then position = positions[2] end
      local roles = chosen.key == 'red' and twoTeamsPlayerRedPosition or twoTeamsPlayerBluePosition
      roles[slot] = position[3]
    end
    gameTeams.place(name, chosen.key, position[1], position[2])
  end

  function gameTeams.join(name)
    if not tfm.get.room.playerList[name] or playerLeft[name] or playerBan[name]
        or gameTeams.find(name) then return false end
    local mode = gameTeams.mode()
    local multi = mode == 'four' or mode == 'three'
    local reduced = multi and gameStats.typeMap ~= 'large4v4'
    local chosen, slot = chooseJoinSlot(mode, multi, reduced)
    if not chosen then
      tfm.exec.chatMessage('<bv>The teams are full<n>', name)
      return false
    end
    chosen.roster[slot].name = name
    playerInGame[name] = true
    recordJoin(name, chosen.key, mode)
    assignJoinPosition(name, chosen, slot, mode, reduced)
    disablePlayerCanTransform(name)
    return true
  end
end
