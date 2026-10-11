function rankMode(mode)
  if mode == "Normal mode" then
    return sessionRanking.ranks.normal
  elseif mode == "4 teams mode" then
    return sessionRanking.ranks.four
  elseif mode == "3 teams mode" then
    return sessionRanking.ranks.three
  elseif mode == "2 teams mode" then
    return sessionRanking.ranks.two
  elseif mode == "Real mode" then
    return sessionRanking.ranks.real
  end
end
