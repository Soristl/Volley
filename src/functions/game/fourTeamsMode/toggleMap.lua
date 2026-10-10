function toggleMap()
  beginGameplayMapLoad()
  removeTimer('deadTimer')
  gameStats.canTransform = false
  if not globalSettings.minimalist then disablePlayersCanTransform(3500) end
  gameBalls.deactivateAll()
  globalSettings.minimalistToggleMap = true

  local largeCourt = gameStats.typeMap == 'large3v3'
  if not largeCourt and gameStats.typeMap ~= 'small' then return end
  ui.removeTextArea(8998991)
  if not largeCourt then ui.removeTextArea(899899) end
  gameMaps.loadReduced(largeCourt)
  showTheScore()

  gameMaps.prepareCourt(function()
    -- Preserve placement/spawn ordering for each reduced court.
    if largeCourt then
      teleportPlayersWithTypeMap(true)
      spawnInitialBall()
      showTheScore()
    else
      spawnInitialBall()
      teleportPlayersWithTypeMap(false)
    end
  end)
  showCrownToAllPlayers()
end
