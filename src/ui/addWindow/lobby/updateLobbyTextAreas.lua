do
local threeTeamGroups = {'Red','Blue','Green'}
local fourTeamGroups = {'Red','Blue','Yellow','Green'}
local twoTeamGroups = {'Red','Blue','Red','Blue'}

function updateLobbyTextAreas(playersAlreadyReset, preferredPlayer)
  removeTimer('resetTeams')
  removeTimer('toggleTeams')
  removeTimer('canJoin')
  if not playersAlreadyReset then resetPlayerConfigs() end
  gameState.lobbyDeadline = os.time() + 25000
  gameStats.canJoin = false
  local three, four = gameStats.threeTeamsMode, gameStats.teamsMode
  local groups = three and threeTeamGroups or four and fourTeamGroups or twoTeamGroups
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
    local group, slot
    if three then
      group=math.floor((seat-1)/4)+1
      slot=(seat-1)%4+1
    else
      group=math.floor((seat-1)/3)+1
      slot=(seat-1)%3+1
      if group>=3 and not four then slot=slot+3 end
    end
    clubhouse.teamSeat(groups[group],slot,"")
    if seat==12 then gameStats.canJoin=true end
  end
  resetRosters()
  for tick=3,14 do drawSeat(tick) end
end
end
