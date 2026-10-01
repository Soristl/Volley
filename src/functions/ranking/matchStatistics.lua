-- Session statistics: team changes and reconnects remain the same match.
do
local matchStatistics = { participants = {}, finished = false }

function resetMatchStatistics()
  matchStatistics = { participants = {}, finished = false }
end

function recordMatchParticipation(stats, name)
  if matchStatistics.finished or matchStatistics.participants[name] or not stats[name] then return end
  matchStatistics.participants[name] = true
  local player = stats[name]
  player.matches = player.matches + 1
  player.winRatio = winRatioPercentage(player.wins, player.matches)
end

function recordMatchVictory(stats, team, roster)
  if matchStatistics.finished or not roster then return end
  local field = ({ red='winsRed', blue='winsBlue', yellow='winsYellow', green='winsGreen' })[team]
  if not field then return end
  local awarded = {}
  for _, entry in ipairs(roster) do
    local name = entry.name
    local player = stats[name]
    if name ~= '' and name ~= 'a' and player and player[field] ~= nil and not awarded[name] then
      recordMatchParticipation(stats, name)
      awarded[name] = true
      player.wins = player.wins + 1
      player[field] = player[field] + 1
      player.winRatio = winRatioPercentage(player.wins, player.matches)
    end
  end
  matchStatistics.finished = true
end
end
