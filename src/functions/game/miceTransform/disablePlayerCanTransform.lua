function playerRuntime.delayPlayerTransform(name)
  playerState.canTransform[name] = false
  timers.handles.playerTransform = timers.addPlayerRound(name, function(i)
    if i == 1 then
      playerState.canTransform[name] = true
    end
  end, 2000, 1, "playersCanTransform")
end
