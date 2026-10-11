function gameTeams.placeAll()
  gameTeams.placeSpectators()
  local rosters=gameTeams.rosters()
  for _,key in ipairs(gameTeams.keys()) do
    local positions=gameTeams.positions(key)
    local nextPosition=1
    for index,slot in ipairs(rosters[key]) do
      if slot.name ~= '' then
        sessionRanking.seedTeamHistory(slot.name,key)
        local position=positions[nextPosition]
        gameTeams.place(slot.name,key,position[1],position[2])
        if position[3] then
          local roles=key=='red' and gameState.teamLayout.roles.red or gameState.teamLayout.roles.blue
          roles[index]=position[3]
        end
        nextPosition=nextPosition % #positions + 1
      end
    end
  end
end
