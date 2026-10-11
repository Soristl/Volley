function playerRuntime.delayRoundTransforms(time)
  timers.handles.playerTransform = timers.addMap(function(i)
    if i == 1 then
      gameState.match.round.canTransform = true
    end
  end, time, 1, "playersCanTransform")
end
