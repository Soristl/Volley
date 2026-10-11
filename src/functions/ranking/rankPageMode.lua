function rankPageMode(mode, name)
  if mode == "Normal mode" then
    return uiState.pageNormalMode[name]
  elseif mode == "4 teams mode" then
    return uiState.pageFourTeamsMode[name]
  elseif mode == "3 teams mode" then
    return uiState.pageThreeTeamsMode[name]
  elseif mode == "2 teams mode" then
    return uiState.pageTwoTeamsMode[name]
  elseif mode == "Real mode" then
    return uiState.pageRealMode[name]
  end
end
