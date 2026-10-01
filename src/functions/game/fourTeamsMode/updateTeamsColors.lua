-- Remove a court slot without maintaining parallel display arrays.
function updateTeamsColors(index)
  if not gameLives.setAt(index, 0) then return false end
  table.remove(teamsPlayersOnGame, index)
  return true
end
