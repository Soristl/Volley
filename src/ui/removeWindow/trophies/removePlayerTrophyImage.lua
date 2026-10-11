function clubhouse.scheduleTrophyRemoval(name)
  local removeImage = timers.add(function(i)
    if i == 1 then
      if playerState.trophyImage[name] ~= 0 then
        tfm.exec.removeImage(playerState.trophyImage[name])
        playerState.trophyImage[name] = 0
      end
    end
  end, 10000, 1, "trophy" .. name .. "")
end
