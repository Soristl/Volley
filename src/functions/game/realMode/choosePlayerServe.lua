do
local function selectServer(roster, ace, previous, team)
  local chosen, chosenIndex
  local function available(name)
    return name ~= "" and tfm.get.room.playerList[name] and not playerState.left[name]
  end
  if gameState.match.real[ace] then
    for i, slot in ipairs(roster) do
      if slot.name == previous and available(slot.name) then chosen, chosenIndex = slot.name, i; break end
    end
  end
  if not chosen then
    local last = gameState.match.real[team .. "ServeIndex"] or 0
    for offset = 1, #roster do
      local i = (last + offset - 1) % #roster + 1
      if available(roster[i].name) then chosen, chosenIndex = roster[i].name, i; break end
    end
  end
  return chosen, chosenIndex
end

function realServe.choosePlayer(team)
  if team ~= "red" and team ~= "blue" then return nil end
  local roster = team == "red" and gameState.teams.red or gameState.teams.blue
  local ace = team == "red" and "aceRed" or "aceBlue"
  local previous = gameState.match.real[team .. "PlayerServe"]
  local chosen, chosenIndex = selectServer(roster, ace, previous, team)
  gameState.match.real.redServe, gameState.match.real.blueServe = false, false
  gameState.match.real.lastPlayerRed, gameState.match.real.lastPlayerBlue = "", ""
  if not chosen then
    gameState.match.real[team .. "PlayerServe"] = ""
    gameState.match.real[ace] = false
    return nil
  end
  gameState.match.real[team .. "PlayerServe"] = chosen
  gameState.match.real[team .. "ServeIndex"] = chosenIndex
  gameState.match.real[team .. "Serve"] = true
  gameState.match.real.aceRed, gameState.match.real.aceBlue = team == "red", team == "blue"
  tfm.exec.movePlayer(chosen, team == "red" and 700 or 1900, 334)
  tfm.exec.chatMessage("<bv>" .. chosen .. " will serve the ball<n>", nil)
  return chosen
end
end
