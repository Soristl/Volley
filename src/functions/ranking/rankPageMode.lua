function rankPageMode(mode, name)
  if mode == "Normal mode" then
    return pageNormalMode[name]
  elseif mode == "4 teams mode" then
    return pageFourTeamsMode[name]
  elseif mode == "3 teams mode" then
    return pageThreeTeamsMode[name]
  elseif mode == "2 teams mode" then
    return pageTwoTeamsMode[name]
  elseif mode == "Real mode" then
    return pageRealMode[name]
  end
end