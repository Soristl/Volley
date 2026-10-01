function disablePlayersCanTransform(time)
  playersCanTransform = addMapTimer(function(i)
    if i == 1 then
      gameStats.canTransform = true
    end
  end, time, 1, "playersCanTransform")
end
