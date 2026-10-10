function disablePlayerCanTransform(name)
  playerCanTransform[name] = false
  playersCanTransform = addPlayerRoundTimer(name, function(i)
    if i == 1 then
      playerCanTransform[name] = true
    end
  end, 2000, 1, "playersCanTransform")
end
