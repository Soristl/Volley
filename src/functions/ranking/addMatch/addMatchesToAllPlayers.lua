function addMatchesToAllPlayers()
  local handlers = {
    ["Normal mode"] = addMatchToPlayer,
    ["2 teams mode"] = addMatchToPlayerTwoTeamsMode,
    ["3 teams mode"] = addMatchToPlayerThreeTeamsMode,
    ["4 teams mode"] = addMatchToPlayerFourTeamsMode,
    ["Real mode"] = addMatchToPlayerRealMode,
  }
  local addMatch = handlers[verifyMode()]
  if not addMatch then return end
  -- Joining assigns a roster slot before gameplay can begin. Departed names
  -- remain in playerInGame as false, so scan the bounded rosters instead of
  -- the room's entire session history. Keep pending departures in the roster
  -- eligible until their gameplay flag is cleared, as before.
  local seen = {}
  for _, roster in pairs(gameState.teams) do
    for _, slot in ipairs(roster) do
      local name = slot.name
      if playerInGame[name] and not seen[name] then
        seen[name] = true
        addMatch(name)
      end
    end
  end
end
