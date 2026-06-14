function playerHistoryOnMatch(team, name)
  local playerTeams = playersOnGameHistoric[name].teams
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
