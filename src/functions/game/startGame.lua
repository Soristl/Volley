function gameRound.start()
  gameState.setPhase("gameStart")
  timers.clearRound()
  mapLoad.begin()
  gameState.match.round.canTransform = false
  if not roomConfig.settings.minimalist then
    playerRuntime.delayRoundTransforms(3500)
  end
  
  sessionRanking.addMatchesForRound()
  gameMaps.selectInitial()

  gameRound.startClock()

  clubhouse.removeLobbyTextAreas()
  clubhouse.showScores()

  roomConfig.settings.minimalistToggleMap = true
  gameMaps.prepareCourt(function()
    gameTeams.placeAll()
    gameBalls.spawnInitial()
    gamePoints.startChecking()
    gameCrowns.showAll()
  end)

  tfm.exec.chatMessage("<ch>If you don't want to see the ranking crowns, type the command !crown false<n>", nil)
end
