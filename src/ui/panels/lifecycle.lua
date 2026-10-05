function clubhouse.sync(name)
  if not (clubhouse.views[name] and clubhouse.views[name].sync) then closeAllWindows(name) end
  clubhouse.panel(name,"sync");clubhouse.closeLabel(name,"sync")
  clubhouse.label(name,"sync","instruction")
  local candidates={}
  for player,data in pairs(tfm.get.room.playerList) do
    if not player:find("*",1,true) and not playerBan[player] and not playerLeft[player] then
      candidates[#candidates+1]={name=player,latency=getSyncLatency(data.averageLatency) or math.huge}
    end
  end
  table.sort(candidates,function(a,b) return a.latency==b.latency and a.name<b.name or a.latency<b.latency end)
  if #candidates==0 then clubhouse.label(name,"sync","empty");clubhouse.endUpdate(name,"sync");return end
  for i=1,math.min(5,#candidates) do
    clubhouse.label(name,"sync","name_"..i,clubhouse.shorten(candidates[i].name,30),"sync"..candidates[i].name)
    local latency=candidates[i].latency < math.huge and candidates[i].latency or '?'
    clubhouse.label(name,"sync","ping_"..i,clubhouse.text(name,"sync.latency",{latency=latency}))
  end
  clubhouse.endUpdate(name,"sync")
end

function clubhouse.refresh(name)
  if lobbyTransition and lobbyTransition.blocksInput() then
    lobbyTransition.enqueue(name)
    return
  end
  closeAllWindows(name)
  clubhouse.launcher(name,23);clubhouse.launcher(name,30);clubhouse.launcher(name,31)
  if gameState.phase=="startGame" then
    clubhouse.lobby(name)
    for id,r in pairs(clubhouse.joinAreas) do clubhouse.joinArea(id,r.text,name,r.x,r.y,r.width,r.height,r.background,r.border,r.alpha,r.fixed) end
  end
end

function clubhouse.configureCopy()
  for _,code in ipairs({"fr","en","br","pl","ar"}) do
    local language=lang[code]
    local function t(key) return clubhouse.strings[key][code] end
    local profile=language.profile
    for field,key in pairs({title="title.profile",close="action.close",rank="profile.rank",unranked="state.unranked",matches="profile.matches",wins="profile.wins",rate="profile.rate",trophies="profile.trophies",session="profile.session",show="action.show_trophy",locked="state.locked_trophy"}) do profile[field]=t(key) end
    profile.quantity=t("profile.trophy_count"):gsub("{count}","%%d")
    profile.notFound=t("profile.player_not_found");profile.ambiguous=t("profile.ambiguous")
    profile.modes={t("mode.normal"),t("mode.two"),t("mode.three"),t("mode.four"),t("mode.real")}
    profile.roles={t("role.player"),t("role.admin"),t("role.temporary"),t("role.inactive"),t("role.permanent")}
    local ranking=language.ranking
    for field,key in pairs({title="title.ranking",player="ranking.player",matches="ranking.matches",rate="ranking.rate",findMe="action.find_me"}) do ranking[field]=t(key) end
    ranking.players=t("ranking.total"):gsub("{count}","%%d")
    ranking.you=t("ranking.your_rank"):gsub("{rank}","")
    ranking.empty=t("state.empty")
    ranking.teams={t("team.short_red"),t("team.short_blue"),t("team.short_yellow"),t("team.short_green")}
    language.previousMessage=t("action.previous");language.nextMessage=t("action.next")
  end
end

do
local settingsActions = {openMode=true,closeMode=true,openMapType=true,closeMapType=true,twoballs=true,threeballs=true,
  randomball=true,randommap=true,consumables=true,minimalist=true}
local teamKeys = {Red="red",Blue="blue",Green="green",Yellow="yellow"}
local navigationDirections = {"next", "prev"}

local function invalidNavigation(name, callback, prefix, key, opened)
  local page = tonumber(callback:match("^" .. prefix .. "(%d+)$"))
  local view = clubhouse.views[name] and clubhouse.views[name][key]
  local navigation = view and view.navigation
  return not opened or not page or not navigation or page < 1 or page > navigation.pages
end

function clubhouse.guardCallback(name, callback)
  if type(callback) ~= "string" or #callback>256 then return true end
  if lobbyTransition and lobbyTransition.blocksInput() then return true end
  local settingsAction = settingsActions[callback] or callback:match("^setMode") or
    callback:match("^setMapType")
  if (callback:match("^nextSettings") or callback:match("^prevSettings")) and not settings[name] then return true end
  if settingsAction and ((USER_PERMISSIONS[name] or 1)<2 or not settings[name]) then return true end
  if callback:match("^randommap") and callback~="randommap" then return true end
  if callback:match("^joinTeam") or callback:match("^leaveTeam") then
    local action,team,index=callback:match("^(%a+)Team(%a+)(%d+)$")
    if (action~="join" and action~="leave") or firstRun or gameState.phase~="startGame" then return true end
    if clubhouse.hasPanel(name) or not gameStats.canJoin or gameStats.initTimer<=2 then return true end
    index=tonumber(index)
    if not index then return true end
    if team=="Yellow" and not gameStats.teamsMode then return true end
    if team=="Green" and not (gameStats.teamsMode or gameStats.threeTeamsMode) then return true end
    local roster=gameState.teams[teamKeys[team]]
    if team=="Blue" then index=teamBlueIndex(index) end
    if not roster or not roster[index] then return true end
    if action=="join" then
      if playerInGame[name]~=false or roster[index].name~="" then return true end
    elseif roster[index].name~=name then return true end
    -- Pass the validated slot to the handler instead of parsing and indexing it again.
    return false,{action=action,team=team,index=index,slot=roster[index]}
  end
  for _, direction in ipairs(navigationDirections) do
    if callback:match("^" .. direction .. "SelectMap") then
      return invalidNavigation(name,callback,direction.."SelectMap","selector",selectMapOpen[name])
    elseif callback:match("^" .. direction .. "SelectBall") then
      return invalidNavigation(name,callback,direction.."SelectBall","selector_balls",selectBallOpen[name])
    elseif callback:match("^" .. direction .. "Help") then
      return invalidNavigation(name,callback,direction.."Help","help",true)
    end
  end
  return false
end
end

function clubhouse.clearPlayer(name)
  clubhouse.clearLobbyArtwork(name)
  clubhouse.pageRequests[name]=nil
  clubhouse.ballCategoryState[name]=nil
  if clubhouse.selectionTimers[name] then removeTimer(clubhouse.selectionTimers[name]);clubhouse.selectionTimers[name]=nil end
  clubhouse.inputAt[name]=nil
  profileKeyTime[name]=nil
  rankKeyTime[name]=nil
  panelOpenTime[name]=nil
  local views=clubhouse.views[name]
  if views then
    local keys={};for key in pairs(views) do keys[#keys+1]=key end
    for _,key in ipairs(keys) do clubhouse.clear(name,key) end
  end
  clubhouse.views[name]=nil
end

function clearDepartedPlayerUiState(name)
  -- Only after departure cleanup: live panel resets also call clearPlayer.
  -- These values are initialized again on arrival; session data stays intact.
  pagesList[name]=nil
  selectMapImages[name]=nil
  playerAchievementsImages[name]=nil
  pagePlayerSettings[name]=nil
  selectMapOpen[name]=nil
  selectMapPage[name]=nil
  selectBallOpen[name]=nil
  selectBallPage[name]=nil
  settings[name]=nil
  settingsMode[name]=nil
  customMapCommand[name]=nil
end

function clubhouse.reset()
  clubhouse.clearLobbyArtwork()
  local names={};for name in pairs(clubhouse.views) do names[#names+1]=name end
  for _,name in ipairs(names) do clubhouse.clearPlayer(name) end
  clubhouse.joinAreas={};clubhouse.scoreAreas={}
end

function clubhouse.newGame()
  clubhouse.clearLobbyArtwork()
  clubhouse.each(nil,function(name)
    closeAllWindows(name)
    clubhouse.clear(name,"victory")
    clubhouse.clear(name,"score")
  end)
  if gameState.phase=="startGame" then clubhouse.lobby() else clubhouse.removeLobby() end
end
