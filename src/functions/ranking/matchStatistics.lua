-- Session statistics: team changes and reconnects remain the same match.
do
local matchStatistics = { participants = {}, finished = false }

-- True means session statistics were inserted, so arrival can initialize ranking pages.
function sessionRanking.ensurePlayer(name)
  if sessionRanking.stats.normal[name] == nil then
    --[[
      This could all be inside one single table:
      --Vit0rg
    ]]
    sessionRanking.stats.normal[name] = newPlayerStats(name)
    sessionRanking.stats.four[name] = newPlayerStats(name, 4)
    sessionRanking.stats.three[name] = newPlayerStats(name, 3)
    sessionRanking.stats.two[name] = newPlayerStats(name)
    sessionRanking.stats.real[name] = newPlayerStats(name)
    -- Even an unranked insertion can change pairs ordering for exact ties.
    sessionRanking.cache.invalidateAll()
    return true
  end
end

function sessionRanking.resetMatch()
  matchStatistics = { participants = {}, finished = false }
end

function sessionRanking.recordParticipation(stats, name)
  if matchStatistics.finished or matchStatistics.participants[name] or not stats[name] then return end
  matchStatistics.participants[name] = true
  local player = stats[name]
  player.matches = player.matches + 1
  player.winRatio = winRatioPercentage(player.wins, player.matches)
  sessionRanking.cache.invalidate(stats)
end

function sessionRanking.recordVictory(stats, team, roster)
  if matchStatistics.finished or not roster then return end
  local field = ({ red='winsRed', blue='winsBlue', yellow='winsYellow', green='winsGreen' })[team]
  if not field then return end
  local awarded = {}
  for _, entry in ipairs(roster) do
    local name = entry.name
    local player = stats[name]
    if name ~= '' and name ~= 'a' and player and player[field] ~= nil and not awarded[name] then
      sessionRanking.recordParticipation(stats, name)
      awarded[name] = true
      player.wins = player.wins + 1
      player[field] = player[field] + 1
      player.winRatio = winRatioPercentage(player.wins, player.matches)
      sessionRanking.cache.invalidate(stats)
    end
  end
  matchStatistics.finished = true
end
end
