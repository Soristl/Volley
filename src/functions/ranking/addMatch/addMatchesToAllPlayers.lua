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
  for name, playing in pairs(playerInGame) do
    if playing then addMatch(name) end
  end
end
