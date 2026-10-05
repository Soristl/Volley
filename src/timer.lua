-- Timers are iterated through a snapshot: callbacks may cancel or create timers.
-- IDs are never reused, so an old UI/player handle cannot cancel a newer timer.
do -- Keep private timer locals out of the assembled chunk's 200-local limit.
local timerState = { active = {}, labels = {}, nextId = 0, round = 0, disconnected = {} }

-- All removals share this path so label lookups and snapshots agree.
local function deleteTimer(id)
  local timer = timerState.active[id]
  if not timer then return false end
  timerState.active[id] = nil
  timerState.snapshot = nil
  if type(timer.label) == 'string' then
    local ids = timerState.labels[timer.label]
    for index = #ids, 1, -1 do
      if ids[index] == id then table.remove(ids, index); break end
    end
    if #ids == 0 then timerState.labels[timer.label] = nil end
  end
  return true
end

local function timerSnapshot()
  if not timerState.snapshot then
    local ids = {}
    for id in pairs(timerState.active) do ids[#ids + 1] = id end
    table.sort(ids)
    timerState.snapshot = ids
  end
  return timerState.snapshot
end

local function sampleTimerTime(timer, now)
  local elapsed = math.max(0, now - timer.lastTime)
  timer.lastTime = now
  if not timer.isPaused and not (timer.round ~= nil and timerState.gameplayPaused)
    and (not timer.map or timer.loading or gameState.map.ready) then
    timer.currentTime = timer.currentTime + elapsed
  end
end

local function sampleAllTimerTimes()
  local now = os.time() -- Transformice's clock is in milliseconds.
  for _, timer in pairs(timerState.active) do sampleTimerTime(timer, now) end
end

-- LuaJ may reject next(table, key) after that key has been removed.
-- Collect matches without mutation, then delete after iteration has finished.
function removeTimersMatching(field, value)
  if field == 'label' and type(value) == 'string' then
    local ids = timerState.labels[value]
    if not ids then return false end
    -- Remove from the end: duplicate labels retain increasing ID order.
    for index = #ids, 1, -1 do deleteTimer(ids[index]) end
    return true
  end
  local pending = {}
  for id, timer in pairs(timerState.active) do
    if (value == nil and timer[field] ~= nil) or (value ~= nil and timer[field] == value) then
      pending[#pending + 1] = id
    end
  end
  for _, id in ipairs(pending) do deleteTimer(id) end
  return #pending > 0
end

function beginGameplayMapLoad()
  clearMapPlayerGameplay()
  removeTimersMatching('map', true)
  gameState.map.ready = false
  gameState.map.target = nil
  gameState.map.sourceTarget = nil
end

function isGameplayMapReady()
  return gameState.map.ready
end

function setGameplayTimersPaused(paused)
  sampleAllTimerTimes()
  timerState.gameplayPaused = paused
end

function loadGameplayMap(target, sourceTarget)
  if lobbyTransition and lobbyTransition.blocksInput() then lobbyTransition.cancel() end
  gameState.map.target = target
  -- Reloaded XML still belongs to the published map that supplied its helpers.
  gameState.map.sourceTarget = sourceTarget or target
  tfm.exec.newGame(target)
end

function gameplayMapMatches()
  if gameState.map.ready then return true end
  if gameState.map.target == nil then return false end
  local target = tostring(gameState.map.target)
  local info = tfm.get.room.xmlMapInfo
  if not info or type(info.xml) ~= 'string' or info.xml == '' then return false end
  if target:sub(1,1) == '<' then
    -- Raw XML requests have no published map code; compare their content.
    return target:gsub('%s+', '') == info.xml:gsub('%s+', '')
  end
  local expected = tonumber((target:gsub('^@', '')))
  local actual = tonumber((tostring(tfm.get.room.currentMap):gsub('^@', '')))
  return expected ~= nil and expected == actual
end

function finishGameplayMapLoad()
  sampleAllTimerTimes()
  gameMaps.applyPlayerCeiling()
  gameMaps.restorePlatformsWalls()
  gameState.map.ready = true
end

function addMapTimer(callback, ms, loops, label, ...)
  local id = addRoundTimer(callback, ms, loops, label, ...)
  timerState.active[id].map = true
  return id
end

function addMapLoadTimer(callback, ms, loops, label, ...)
  local id = addMapTimer(callback, ms, loops, label, ...)
  timerState.active[id].loading = true
  return id
end

function addTimer(callback, ms, loops, label, ...)
  timerState.nextId = timerState.nextId + 1
  local id = timerState.nextId
  timerState.active[id] = {
    callback = callback, time = ms, loops = loops or 1, label = label,
    arguments = { n = select('#', ...), ... }, currentTime = 0,
    currentLoop = 0, isPaused = false, lastTime = os.time()
  }
  if type(label) == 'string' then
    local ids = timerState.labels[label] or {}
    timerState.labels[label] = ids
    ids[#ids + 1] = id
  end
  timerState.snapshot = nil
  return id
end

function addRoundTimer(callback, ms, loops, label, ...)
  local id = addTimer(callback, ms, loops, label, ...)
  timerState.active[id].round = timerState.round
  return id
end

function addPlayerRoundTimer(name, callback, ms, loops, label, ...)
  if timerState.disconnected[name] or not tfm.get.room.playerList[name] then return nil end
  local id = addMapTimer(callback, ms, loops, label, ...)
  timerState.active[id].player = name
  return id
end

-- nil preserves connection state (voluntary team leave); true/false marks a
-- disconnect/arrival. Reject timers queued by cleanup after a disconnect.
function clearPlayerTimers(name, disconnected)
  if disconnected ~= nil then timerState.disconnected[name] = disconnected or nil end
  removeTimersMatching('player', name)
end

function getTimerId(label)
  if type(label) == 'string' then
    local ids = timerState.labels[label]
    return ids and ids[1]
  end
  local first
  for id, timer in pairs(timerState.active) do
    if timer.label == label and (not first or id < first) then first = id end
  end
  return first
end

function pauseTimer(id)
  if type(id) == 'string' then id = getTimerId(id) end
  local timer = timerState.active[id]
  if not timer then return false end
  sampleTimerTime(timer, os.time())
  timer.isPaused = true
  return true
end

function resumeTimer(id)
  if type(id) == 'string' then id = getTimerId(id) end
  local timer = timerState.active[id]
  if not timer or not timer.isPaused then return false end
  sampleTimerTime(timer, os.time())
  timer.isPaused = false
  return true
end

function removeTimer(id)
  if type(id) == 'string' then
    return removeTimersMatching('label', id)
  end
  if id == nil then return false end
  return deleteTimer(id)
end

function clearRoundTimers()
  timerState.gameplayPaused = false
  gameState.resetMap()
  timerState.round = timerState.round + 1
  removeTimersMatching('round')
end

function clearTimers()
  timerState.gameplayPaused = false
  gameState.resetMap()
  timerState.round = timerState.round + 1
  timerState.active = {}
  timerState.labels = {}
  timerState.snapshot = nil
end

function timersLoop()
  local now = os.time()
  -- Each invocation keeps its own immutable list. Callbacks only invalidate
  -- the cache, so additions still wait for the next invocation (even nested).
  local pending = timerSnapshot()
  for _, id in ipairs(pending) do
    local timer = timerState.active[id]
    if timer then sampleTimerTime(timer, now) end
    if timer and not timer.isPaused and not (timer.round ~= nil and timerState.gameplayPaused)
      and (not timer.map or timer.loading or gameState.map.ready) then
      if timer.currentTime >= timer.time then
        -- Run at most once per host tick: never burst stale physics callbacks
        -- after a lag spike. Repeating timers restart from the actual callback.
        timer.currentTime = 0
        timer.currentLoop = timer.currentLoop + 1
        local complete = timer.loops > 0 and timer.currentLoop >= timer.loops
        if complete then deleteTimer(id) end
        if timer.callback then
          timer.callback(timer.currentLoop, (table.unpack or unpack)(timer.arguments, 1, timer.arguments.n))
        end
        if complete and eventTimerComplete then eventTimerComplete(id, timer.label) end
      end
    end
  end
end
end
