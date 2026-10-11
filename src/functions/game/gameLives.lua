-- Lives are stored once under the original team identity.
gameLives = {}

function gameLives.forTeam(key)
  local slot = gameTeams.lifeSlot(key)
  return slot and gameState.lives[slot][key]
end

function gameLives.setTeam(key, value)
  local slot = gameTeams.lifeSlot(key)
  if not slot or type(value) ~= 'number' or value < 0 or value % 1 ~= 0 then return false end
  gameState.lives[slot][key] = value
  return true
end

function gameLives.at(index) return gameLives.forTeam(gameTeams.keyAt(index)) end
function gameLives.setAt(index, value) return gameLives.setTeam(gameTeams.keyAt(index), value) end
function gameLives.loseAt(index)
  local value = gameLives.at(index)
  if not value or value <= 0 then return false end
  return gameLives.setAt(index, value - 1)
end
