function matchLifecycle.reduceCourt()
  mapLoad.begin()
  timers.remove('deadTimer')
  gameState.match.round.canTransform = false
  if not roomConfig.settings.minimalist then playerRuntime.delayRoundTransforms(3500) end
  gameBalls.deactivateAll()
  roomConfig.settings.minimalistToggleMap = true

  local largeCourt = gameState.match.court.typeMap == 'large3v3'
  if not largeCourt and gameState.match.court.typeMap ~= 'small' then return end
  ui.removeTextArea(8998991)
  if not largeCourt then ui.removeTextArea(899899) end
  gameMaps.loadReduced(largeCourt)
  clubhouse.showScores()

  gameMaps.prepareCourt(function()
    -- Preserve placement/spawn ordering for each reduced court.
    if largeCourt then
      gameTeams.placeRemaining(true)
      gameBalls.spawnInitial()
      clubhouse.showScores()
    else
      gameBalls.spawnInitial()
      gameTeams.placeRemaining(false)
    end
  end)
  gameCrowns.showAll()
end
