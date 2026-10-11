-- Only court order is cached. Display metadata is derived from team identity.
function gameTeams.refreshRemaining()
  gameState.teamLayout.remaining = {}
  for _, key in ipairs(gameTeams.keys()) do
    local roster = gameState.teams[key]
    if gameTeams.count(roster) == 0 then gameLives.setTeam(key, 0) end
    if gameLives.forTeam(key) > 0 then
      gameState.teamLayout.remaining[#gameState.teamLayout.remaining+1] = roster
    end
  end
  return #gameState.teamLayout.remaining
end
