function teamBlueIndex(index)
  if gameStats.threeTeamsMode then
    return index
  end

  return index - 3
end
