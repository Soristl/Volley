-- Session team history and reconnect counters stay private to this module.
-- Each reset preserves its original replacement boundary; no table escapes.
do
local teamHistory = {}
local matchCount = 0
local lastMatchCount = {}

function sessionRanking.hasTeamHistory(team, name)
  local playerTeams = teamHistory[name].teams
  local notFindSameTeam = true

  for i = 1, #playerTeams do
    if playerTeams[i] == team then
      notFindSameTeam = false
    end
  end

  if notFindSameTeam then
    return true
  end

  return false
end

function sessionRanking.resetHistory()
  teamHistory = {}
end

function sessionRanking.resetPlayerHistory(name)
  teamHistory[name] = { teams = {} }
end

function sessionRanking.seedTeamHistory(name, key)
  teamHistory[name]={teams={key}}
end

function sessionRanking.prepareReconnect(name)
  if teamHistory[name] == nil then
    teamHistory[name] = { teams = {} }
  end

  if lastMatchCount[name] == nil then
    lastMatchCount[name] = matchCount
  else
    if lastMatchCount[name] ~= matchCount then
      teamHistory[name] = { teams = {} }
    end
  end
end

function sessionRanking.recordDeparture(name)
  lastMatchCount[name] = matchCount
end

function sessionRanking.advanceMatch()
  matchCount = matchCount + 1
end

function sessionRanking.recordTeamHistory(name, key)
  teamHistory[name] = teamHistory[name] or {teams={}}
  if sessionRanking.hasTeamHistory(key, name) then
    local history = teamHistory[name].teams
    history[#history+1] = key
  end
end
end
