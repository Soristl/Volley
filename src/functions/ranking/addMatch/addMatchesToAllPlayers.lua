function sessionRanking.addMatchesForRound()
  local handlers = {
    ["Normal mode"] = sessionRanking.addNormalMatch,
    ["2 teams mode"] = sessionRanking.addTwoTeamMatch,
    ["3 teams mode"] = sessionRanking.addThreeTeamMatch,
    ["4 teams mode"] = sessionRanking.addFourTeamMatch,
    ["Real mode"] = sessionRanking.addRealMatch,
  }
  local addMatch = handlers[gameTeams.modeLabel()]
  if not addMatch then return end
  -- Joining assigns a roster slot before gameplay can begin. Departed names
  -- remain in playerInGame as false, so scan the bounded rosters instead of
  -- the room's entire session history. Keep pending departures in the roster
  -- eligible until their gameplay flag is cleared, as before.
  local seen = {}
  for _, roster in pairs(gameState.teams) do
    for _, slot in ipairs(roster) do
      local name = slot.name
      if playerState.inGame[name] and not seen[name] then
        seen[name] = true
        addMatch(name)
      end
    end
  end
end
