-- Finish harmless panel cleanup during the existing victory screen, then load
-- the lobby once and rebuild complete player views in small batches. The time
-- limit is elapsed wall time, not a measurement of Transformice's CPU quota.
lobbyTransition = {active=false, priming=false, generation=0}
do
  local transition = lobbyTransition
  local TICK_MS, BATCH_LIMIT, ELAPSED_LIMIT_MS = 500, 4, 3
  local connections, pending = {}, {}
  local nextConnection=0
  local cleanup, render, cleanupHead, renderHead = {}, {}, 1, 1
  local nextAt=0
  local function isLobbyMap()
    return tonumber((tostring(tfm.get.room.currentMap):gsub('^@',''))) == 7983549
  end
  local function eligible(name)
    return tfm.get.room.playerList[name] and not playerLeft[name] and not playerBan[name]
  end
  local function job(name)
    return {name=name, connection=connections[name], generation=transition.generation}
  end
  local function valid(item)
    return item.generation==transition.generation and
      item.connection==connections[item.name] and eligible(item.name)
  end

  function transition.blocksInput() return transition.active or transition.priming end
  function transition.allowsDraw(name)
    return not transition.blocksInput() or (name and name==transition.renderingName) or
      (not name and transition.renderingShared==true)
  end
  function transition.enqueue(name)
    if not transition.blocksInput() or not eligible(name) then return false end
    if not connections[name] then nextConnection=nextConnection+1;connections[name]=nextConnection end
    local version=connections[name]
    if pending[name]==version then return true end
    pending[name]=version
    render[#render+1]=job(name)
    return true
  end
  function transition.leave(name)
    connections[name]=nil
    pending[name]=nil
  end
  function transition.cancel()
    transition.generation=transition.generation+1
    transition.active=false;transition.priming=false;transition.stage=nil
    transition.renderingName=nil;transition.renderingShared=nil
    cleanup={};render={};cleanupHead=1;renderHead=1;connections={};pending={}
  end
  local function prepareQueue()
    local names={}
    for name in pairs(tfm.get.room.playerList) do names[#names+1]=name end
    table.sort(names)
    for _,name in ipairs(names) do
      transition.enqueue(name)
      cleanup[#cleanup+1]=job(name)
    end
  end
  function transition.prime()
    if transition.blocksInput() then return false end
    transition.cancel()
    transition.priming=true;transition.stage='warmup'
    prepareQueue()
    nextAt=os.time()+TICK_MS
    return true
  end
  function transition.begin()
    if transition.active then return false end
    local primed=transition.priming
    if not primed then transition.cancel() end
    transition.active=true;transition.priming=false;transition.stage='loading'
    if not primed then
      prepareQueue()
      clearRoundTimers()
    end
    gameStats.canJoin=false
    cleanup={};cleanupHead=1
    clubhouse.clearLobbyArtwork()
    clubhouse.joinAreas={};clubhouse.scoreAreas={}
    -- Registration of seats is immediate; their rendering remains guarded.
    init(false,true)
    return true
  end
  function transition.onMapLoaded()
    if not transition.active then return false end
    if transition.stage=='render' then
      -- A further delivery invalidates partly drawn image handles, even when
      -- the map code is unchanged. Restart without counting another match.
      transition.cancel();transition.begin()
      return false
    end
    if transition.stage~='loading' or not isLobbyMap() then return false end
    groundProfile.reset();mapBackgrounds.newGame();gameBalls.forget()
    clubhouse.ballSkins.reset()
    if autosync then refletzSyncSystem() end
    transition.stage='render'
    gameStats.initTimer=25;gameStats.canJoin=false
    gameState.lobbyDeadline=math.huge
    transition.renderingShared=true;clubhouse.lobby();transition.renderingShared=nil
    nextAt=os.time()+TICK_MS
    return true
  end
  function transition.step()
    if not transition.blocksInput() then return end
    local now=os.time()
    if now<nextAt then return end
    nextAt=now+TICK_MS
    if transition.priming then
      local count=0
      while cleanupHead<=#cleanup and count<BATCH_LIMIT do
        local item=cleanup[cleanupHead]
        cleanupHead=cleanupHead+1;count=count+1
        if valid(item) then
          -- Keep victory, score, podium, crowns and the court visible until
          -- the map changes. clearPlayer would remove those views too early.
          closeAllWindows(item.name,true)
          clubhouse.closePageInput(item.name)
          if clubhouse.selectionTimers[item.name] then
            removeTimer(clubhouse.selectionTimers[item.name])
            clubhouse.selectionTimers[item.name]=nil
          end
        end
        if os.time()-now>=ELAPSED_LIMIT_MS then break end
      end
      return
    end
    if transition.stage~='render' then return end
    if not isLobbyMap() then transition.cancel();transition.begin();return end
    local count=0
    while renderHead<=#render and count<BATCH_LIMIT do
      local item=render[renderHead]
      renderHead=renderHead+1;count=count+1
      if valid(item) and pending[item.name]==item.connection then
        transition.renderingName=item.name
        gameCrowns.clearViewer(item.name)
        local viewers=clubhouse.lobbyArtworkViewers
        local sharedArtwork=viewers and viewers[item.name] and
          not (clubhouse.lobbyArtworkPlayers and clubhouse.lobbyArtworkPlayers[item.name])
        clubhouse.clearPlayer(item.name)
        -- clearPlayer also forgets artwork ownership. A viewer of the current
        -- broadcast still has those three images; only late arrivals need copies.
        if sharedArtwork then viewers[item.name]=true end
        closeAllWindows(item.name)
        clubhouse.lobby(item.name)
        transition.renderingName=nil
        pending[item.name]=nil
      end
      if os.time()-now>=ELAPSED_LIMIT_MS then break end
    end
    if renderHead>#render then
      transition.active=false;transition.stage=nil
      cleanup={};render={};connections={};pending={}
      gameStats.canJoin=true;gameStats.initTimer=25
      gameState.lobbyDeadline=os.time()+25000
    end
  end
end
