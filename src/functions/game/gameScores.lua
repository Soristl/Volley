-- Points for Normal, 2T and Real Mode. Multi-team lives remain separate.
gameScores = {}

function gameScores.set(key, value)
  if (key ~= 'red' and key ~= 'blue') or type(value) ~= 'number'
    or value < 0 or value % 1 ~= 0 then return false end
  gameState.scores[key] = value
  return true
end

function gameScores.add(key)
  if key ~= 'red' and key ~= 'blue' then return false end
  return gameScores.set(key, gameState.scores[key] + 1)
end

function gameScores.reset()
  gameState.scores.red, gameState.scores.blue = 0, 0
end
