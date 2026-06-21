function winRatioPercentage(wins, matches)
  if matches == 0 then
    return 0
  end

  return (wins / matches) * 100
end
