do
-- The guard owns validation; the shared seat renderer owns layout and colors.
local function applyTeamCallback(name, request)
  if roomConfig.sendBanMessage(name) then return end
  local joining = request.action == "join"
  playerState.inGame[name] = joining
  request.slot.name = joining and name or ""
  clubhouse.teamSeat(request.team, request.index, request.slot.name)
end

local function handlePanelRequest(name, c)
  if c=="chooseDefaultMap" or c=="clearDefaultMap" or c=="returnDefaultSettings" or c:match("^setDefaultMap:") then clubhouse.defaultMapCallback(name,c);return true end
  if c=='toggleMapBackground' or c=='toggleCourtIndicator' then
    clubhouse.personalDisplayCallback(name, c)
    return true
  end
  if c=="ballCategoriesOpen" or c=="ballCategoriesClose" or c:match("^ballCategory:") then clubhouse.ballCategoryCallback(name,c);return true end
  if c:sub(1,11)=="choosePage:" then clubhouse.choosePage(name,c:sub(12));return true end
  if c:sub(1, 7) == "ranking" and c ~= "ranking" then
    clubhouse.rankingCallback(name, c)
    return true
  end
  if c == "profileClose" then
    clubhouse.closeActiveProfile(name)
    return true
  elseif c:sub(1, 11) == "profileMode" then
    clubhouse.updateProfileMode(name, tonumber(c:sub(12)))
    return true
  elseif c == "profileEquipTrophy" then
    clubhouse.equipProfileTrophy(name)
    return true
  end
  return false
end

local function applyPanelAction(name, c)
  if c == "menuOpen" then
    clubhouse.closeActiveProfile(name)
    clubhouse.closeRanking(name)
    clubhouse.menu(name)
  elseif c == "menuClose" then
    clubhouse.clear(name,"menu")
    clubhouse.launcher(name,23)
    clubhouse.restoreLobbyControls(name)
  elseif clubhouse.documentCallback(name, c) then
    return
  elseif c == "closeWindow" then
    clubhouse.closeWindows(name)
  elseif c == "roomadmin" then
    tfm.exec.chatMessage("<rose>/room *#volley0" .. name .. "<n>", name)
  elseif string.sub(c, 1, 4) == "sync" and roomConfig.permissions[name] and roomConfig.permissions[name] > 2 then
    local playerSync = string.sub(c, 5)

    if not tfm.get.room.playerList[playerSync] or playerSync:find("*",1,true) then
      tfm.exec.chatMessage("<bv>" .. clubhouse.escape(clubhouse.text(name,"sync.missing")) .. "<n>", name)
      clubhouse.syncWindow({ name })
    else
      if not roomSync.requestPlayer(playerSync, name) then return end
      clubhouse.closeWindows(name)
      tfm.exec.chatMessage("<bv>Set new player sync: " .. playerSync .. " selected by admin "..name.."<n>", nil)
    end
  elseif clubhouse.settingsCallback(name, c) then
    return
  elseif c == "ranking" then
    clubhouse.openRanking(name)
  elseif string.sub(c, 1, 7) == "trophie" then
    local index = tonumber(string.sub(c, 8))
    clubhouse.showProfileTrophy(name, index)
  elseif clubhouse.selectorCallback(name, c) then
    return
  elseif string.sub(c, 1, 10) == "setkeybind" then
    local key = string.sub(c, 12, 13)
    local bind = string.sub(c, 14)
    -- bind new key, unbind previous
    system.bindKeyboard(name, key, true, true)

    system.bindKeyboard(name, key, true, true)
    return 1
  end
end

function eventTextAreaCallback(id, name, c)
  if type(name) ~= "string" or not tfm.get.room.playerList[name] or playerState.ban[name] or playerState.left[name] then return end
  local blocked, teamRequest = clubhouse.guardCallback(name,c)
  if blocked then return end
  if c:sub(1,10)=="pageInput:" then clubhouse.pageInputCallback(name,c);return end
  local closing=c=="closeWindow" or c=="menuClose" or c=="profileClose" or c=="rankingClose" or c=="ballCategoriesClose"
  if not panelInput.acceptPanelInput(name, closing, c) then return end
  if teamRequest then applyTeamCallback(name,teamRequest);return end
  if handlePanelRequest(name, c) then return end
  return applyPanelAction(name, c)
end
end
