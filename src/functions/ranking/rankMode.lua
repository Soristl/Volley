function rankMode(mode)
  if mode == "Normal mode" then
    return rankNormalMode
  elseif mode == "4 teams mode" then
    return rankFourTeamsMode
  elseif mode == "3 teams mode" then
    return rankThreeTeamsMode
  elseif mode == "2 teams mode" then
    return rankTwoTeamsMode
  elseif mode == "Real mode" then
    return rankRealMode
  end
end