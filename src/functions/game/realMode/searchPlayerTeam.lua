function searchPlayerTeam(name)
  local team = ""

  for i = 1, #playersRed do
    if playersRed[i].name == name then
      team = "red"

      return team
    end
  end

  for i = 1, #playersBlue do
    if playersBlue[i].name == name then
      team = "blue"

      return team
    end
  end
end
