do
local touchRules = {
  {team="red", quantity="redQuantitySpawn", limit="redLimitSpawn", server="redPlayerServe", last="lastPlayerRed"},
  {team="blue", quantity="blueQuantitySpawn", limit="blueLimitSpawn", server="bluePlayerServe", last="lastPlayerBlue"},
}

function verifyPlayerTeam(name)
  if playerOutOfCourt[name] then return end

  -- Keep red before blue and read the current rosters after team changes.
  for _, rule in ipairs(touchRules) do
    local roster = gameState.teams[rule.team]
    for i = 1, #roster do
      if roster[i].name == name then
        local quantity, limit = gameStats[rule.quantity], gameStats[rule.limit]
        if quantity == limit then return false end
        if quantity < limit then
          if limit == 1 and name ~= gameStats[rule.server] and gameStats[rule.last] == name then
            return false
          end
          gameStats[rule.quantity] = quantity + 1
          gameStats[rule.last] = name
          showTheScore()
          return true
        end
      end
    end
  end
end
end
