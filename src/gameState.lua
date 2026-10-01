-- Shared match state. Selected rules remain in gameStats/globalSettings;
-- team, score and ball operations use gameTeams/gameScores/gameBalls.
-- Loaded before timers: map readiness has one owner, shared by the scheduler.
gameState = {
  phase = "startGame",
  map = { ready = true },
  balls = { { active = false }, { active = false }, { active = false } },
  teams = { red = {}, blue = {}, yellow = {}, green = {} },
  scores = { red = 0, blue = 0 },
  revision = 0
}

function gameState.setPhase(phase)
  if phase ~= "startGame" and phase ~= "showRules"
    and phase ~= "gameStart" and phase ~= "endGame" then
    return false
  end
  -- Repeated events must not extend rules/end deadlines.
  if gameState.phase == phase then return false end
  gameState.phase = phase
  gameState.revision = gameState.revision + 1
  gameState.rulesDeadline = phase == "showRules" and os.time() + 10000 or nil
  gameState.endDeadline = phase == "endGame" and os.time() + 5000 or nil
  return true
end

function gameState.resetLobby()
  gameState.setPhase("startGame")
  gameState.rulesDeadline = nil
  gameState.endDeadline = nil
  gameState.lobbyDeadline = os.time() + 25000
end

-- Loading and pause are separate from phase: a reduced court is still part
-- of the same match. Preserve the map table identity across round resets.
function gameState.resetMap()
  gameState.map.ready = true
  gameState.map.target = nil
  gameState.map.sourceTarget = nil
end
