function updateRankingFourTeamsMode()
  local rank_list = {}

  for name, stats in pairs(playersFourTeamsMode) do
    if stats.matches > 0 then
      rank_list[#rank_list + 1] = {
        name = name,
        matches = stats.matches,
        wins = stats.wins,
        winRatio = stats.winRatio,
        winsRed =
            stats.winsRed,
        winsBlue = stats.winsBlue,
        winsYellow = stats.winsYellow,
        winsGreen = stats.winsGreen
      }
    end
  end

  table.sort(rank_list, function(a, b)
    if a.wins == b.wins then
      return a.matches < b.matches
    else
      return a.wins > b.wins
    end
  end)

  rankFourTeamsMode = rank_list
end
