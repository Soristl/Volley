-- UI reads share sorted session statistics until a participation, victory or
-- roster insertion changes them. Game-triggered updaters still rebuild eagerly.
rankingCache = {}

do
  local sources = { playersNormalMode, playersTwoTeamsMode, playersThreeTeamsMode, playersFourTeamsMode, playersRealMode }
  local updaters = {
    function() updateRankingNormalMode() end,
    function() updateRankingTwoTeamsMode() end,
    function() updateRankingThreeTeamsMode() end,
    function() updateRankingFourTeamsMode() end,
    function() updateRankingRealMode() end
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
  function rankingCache.rebuild(stats, mode)
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
    rankingCache.publish(stats, rank)
    return rank
  end

  function rankingCache.invalidate(stats)
    local entry = entries[stats]
    if entry then entry.dirty = true end
  end

  function rankingCache.invalidateAll()
    for _, entry in pairs(entries) do entry.dirty = true end
  end

  function rankingCache.publish(stats, rank)
    local positions = {}
    for position, player in ipairs(rank) do positions[player.name] = position end
    -- Never mutate an older rank list: rankCrown may retain it for this match.
    entries[stats] = { rank = rank, positions = positions, dirty = false }
  end

  function rankingCache.ensure(index)
    local stats = sources[index]
    local entry = entries[stats]
    if not entry or entry.dirty then
      updaters[index]()
      entry = entries[stats]
    end
    return entry.rank
  end

  -- Call after ensure so the rank and its position index share one snapshot.
  function rankingCache.position(index, name)
    return entries[sources[index]].positions[name]
  end
end
