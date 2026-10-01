-- Only court order is cached. Display metadata is derived from team identity.
function refreshRemainingTeams()
  teamsPlayersOnGame = {}
  for _, key in ipairs(gameTeams.keys()) do
    local roster = gameState.teams[key]
    if gameTeams.count(roster) == 0 then gameLives.setTeam(key, 0) end
    if gameLives.forTeam(key) > 0 then
      teamsPlayersOnGame[#teamsPlayersOnGame+1] = roster
    end
  end
  return #teamsPlayersOnGame
end
