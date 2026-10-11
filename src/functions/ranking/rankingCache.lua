-- UI reads share sorted session statistics until a participation, victory or
-- roster insertion changes them. Game-triggered updaters still rebuild eagerly.
sessionRanking.cache = {}

do
  local sources = { sessionRanking.stats.normal, sessionRanking.stats.two, sessionRanking.stats.three, sessionRanking.stats.four, sessionRanking.stats.real }
  local updaters = {
    function() sessionRanking.update.normal() end,
    function() sessionRanking.update.two() end,
    function() sessionRanking.update.three() end,
    function() sessionRanking.update.four() end,
    function() sessionRanking.update.real() end
  }
  local entries = {}

  local extraFields = {
    three = {'winsGreen'},
    four = {'winsYellow', 'winsGreen'}
  }
  local function compare(a, b)
    if a.wins == b.wins then return a.matches < b.matches end
    return a.wins > b.wins
  end

  -- One snapshot builder for every mode. Keep the original source iteration
  -- and comparator: adding a tie-breaker would change existing crown/rank order.
  function sessionRanking.cache.rebuild(stats, mode)
    local rank = {}
    local fields = extraFields[mode]
    for name, player in pairs(stats) do
      if player.matches > 0 then
        local row = {
          name=name, matches=player.matches, wins=player.wins,
          winRatio=player.winRatio, winsRed=player.winsRed, winsBlue=player.winsBlue
        }
        if fields then
          for _, field in ipairs(fields) do row[field] = player[field] end
        end
        rank[#rank + 1] = row
      end
    end
    table.sort(rank, compare)
    sessionRanking.cache.publish(stats, rank)
    return rank
  end

  function sessionRanking.cache.invalidate(stats)
    local entry = entries[stats]
    if entry then entry.dirty = true end
  end

  function sessionRanking.cache.invalidateAll()
    for _, entry in pairs(entries) do entry.dirty = true end
  end

  function sessionRanking.cache.publish(stats, rank)
    local positions = {}
    for position, player in ipairs(rank) do positions[player.name] = position end
    -- Never mutate an older rank list: sessionRanking.crown may retain it for this match.
    entries[stats] = { rank = rank, positions = positions, dirty = false }
  end

  function sessionRanking.cache.ensure(index)
    local stats = sources[index]
    local entry = entries[stats]
    if not entry or entry.dirty then
      updaters[index]()
      entry = entries[stats]
    end
    return entry.rank
  end

  -- Call after ensure so the rank and its position index share one snapshot.
  function sessionRanking.cache.position(index, name)
    return entries[sources[index]].positions[name]
  end
end
