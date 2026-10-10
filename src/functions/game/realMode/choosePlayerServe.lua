function choosePlayerServe(team)
  if team ~= "red" and team ~= "blue" then return nil end
  local roster = team == "red" and gameState.teams.red or gameState.teams.blue
  local ace = team == "red" and "aceRed" or "aceBlue"
  local previous = gameStats[team .. "PlayerServe"]
  local chosen, chosenIndex
  local function available(name)
    return name ~= "" and tfm.get.room.playerList[name] and not playerLeft[name]
  end
  if gameStats[ace] then
    for i, slot in ipairs(roster) do
      if slot.name == previous and available(slot.name) then chosen, chosenIndex = slot.name, i; break end
    end
  end
  if not chosen then
    local last = gameStats[team .. "ServeIndex"] or 0
    for offset = 1, #roster do
      local i = (last + offset - 1) % #roster + 1
      if available(roster[i].name) then chosen, chosenIndex = roster[i].name, i; break end
    end
  end
  gameStats.redServe, gameStats.blueServe = false, false
  gameStats.lastPlayerRed, gameStats.lastPlayerBlue = "", ""
  if not chosen then
    gameStats[team .. "PlayerServe"] = ""
    gameStats[ace] = false
    return nil
  end
  gameStats[team .. "PlayerServe"] = chosen
  gameStats[team .. "ServeIndex"] = chosenIndex
  gameStats[team .. "Serve"] = true
  gameStats.aceRed, gameStats.aceBlue = team == "red", team == "blue"
  tfm.exec.movePlayer(chosen, team == "red" and 700 or 1900, 334)
  tfm.exec.chatMessage("<bv>" .. chosen .. " will serve the ball<n>", nil)
  return chosen
end
