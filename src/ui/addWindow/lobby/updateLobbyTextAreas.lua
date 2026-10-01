function updateLobbyTextAreas(playersAlreadyReset, preferredPlayer)
  removeTimer('resetTeams')
  removeTimer('toggleTeams')
  removeTimer('canJoin')
  if not playersAlreadyReset then resetPlayerConfigs() end
  gameState.lobbyDeadline = os.time() + 25000
  gameStats.canJoin = false
  local three, four = gameStats.threeTeamsMode, gameStats.teamsMode
  local function resetRosters()
    gameTeams.resetRoster('red', three and 4 or four and 3 or 6)
    gameTeams.resetRoster('blue', three and 4 or four and 3 or 6)
    if four then gameTeams.resetRoster('yellow',3) end
    if three or four then gameTeams.resetRoster('green',three and 4 or 3) end
  end

  -- Draw every team seat immediately for all viewers.
  local function drawSeat(tick)
    local seat=tick-2
    if seat<1 or gameState.phase~='startGame' then return end
    local id, team, slot, px, py, color
    if three then
      local group=math.floor((seat-1)/4)+1
      team=({'Red','Blue','Green'})[group]
      slot=(seat-1)%4+1
      id,px,py=threeTeamsMode.id[seat],threeTeamsMode.x[seat],threeTeamsMode.y[seat]
      color=({0xE14747,0x184F81,0x109267})[group]
    else
      local group=math.floor((seat-1)/3)+1
      team=({'Red','Blue',four and 'Yellow' or 'Red',four and 'Green' or 'Blue'})[group]
      slot=(seat-1)%3+1
      if group==2 then slot=slot+3 end
      if group>=3 and not four then slot=slot+(group==3 and 3 or 6) end
      id=seat>6 and seat+1 or seat
      px,py=x[seat],y[seat]
      color=({0xE14747,0x184F81,four and 0xF59E0B or 0xE14747,four and 0x109267 or 0x184F81})[group]
    end
    clubhouse.joinArea(id,"<p align='center'><font size='14px'><a href='event:joinTeam"..team..slot.."'>Join",
      nil,px,py,150,40,color,color,1,false)
    if seat==12 then gameStats.canJoin=true end
  end
  resetRosters()
  for tick=3,14 do drawSeat(tick) end
end
