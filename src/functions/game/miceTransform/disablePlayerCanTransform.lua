function disablePlayerCanTransform(name)
  playerCanTransform[name] = false
  playersCanTransform = addTimer(function(i)
    if i == 1 then
      playerCanTransform[name] = true
    end
  end, 2000, 1, "playersCanTransform")
end
