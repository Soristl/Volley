-- Remove a court slot without maintaining parallel display arrays.
function matchLifecycle.removeCourtTeam(index)
  if not gameLives.setAt(index, 0) then return false end
  table.remove(gameState.teamLayout.remaining, index)
  return true
end
