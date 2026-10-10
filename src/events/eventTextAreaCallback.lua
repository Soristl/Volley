do
-- The guard owns validation; the shared seat renderer owns layout and colors.
local function applyTeamCallback(name, request)
  if messagePlayerIsBanned(name) then return end
  local joining = request.action == "join"
  playerInGame[name] = joining
  request.slot.name = joining and name or ""
  clubhouse.teamSeat(request.team, request.index, request.slot.name)
end

-- 2s anti-spam cooldown per panel-opening button (closing stays instant)
local panelOpening = {menuOpen=true,howToPlay=true,credits=true,realmode=true,
  selectMap=true,selectBall=true,settings=true}
local function panelOpenBlocked(name, panel)
  local times = panelOpenTime[name]
  local lastOpen = times and times[panel]
  return lastOpen and os.time() - lastOpen < 2000
end

function eventTextAreaCallback(id, name, c)
  if type(name) ~= "string" or not tfm.get.room.playerList[name] or playerBan[name] or playerLeft[name] then return end
  local blocked, teamRequest = clubhouse.guardCallback(name,c)
  if blocked then return end
  if c:sub(1,10)=="pageInput:" then clubhouse.pageInputCallback(name,c);return end
  local closing=c=="closeWindow" or c=="menuClose" or c=="profileClose" or c=="rankingClose" or c=="ballCategoriesClose"
  -- Check both personal delays before recording an accepted opening.
  -- A rejected retry must not postpone this player's next permitted click.
  if panelOpening[c] and panelOpenBlocked(name,c) then return end
  if not clubhouse.allowInput(name,closing,c) then return end
  if panelOpening[c] then
    panelOpenTime[name] = panelOpenTime[name] or {}
    panelOpenTime[name][c] = os.time()
  end
  if teamRequest then applyTeamCallback(name,teamRequest);return end
  if c=="chooseDefaultMap" or c=="clearDefaultMap" or c=="returnDefaultSettings" or c:match("^setDefaultMap:") then clubhouse.defaultMapCallback(name,c);return end
  if c=='toggleMapBackground' or c=='toggleCourtIndicator' then
    if not settings[name] or pagePlayerSettings[name]~=3 or not (clubhouse.views[name] and clubhouse.views[name].settings) then return end
    if c=='toggleMapBackground' then mapBackgrounds.toggleHidden(name)
    else mapBackgrounds.toggleBorders(name) end
    clubhouse.personalDisplayOptions(name)
    return
  end
  if c=="ballCategoriesOpen" or c=="ballCategoriesClose" or c:match("^ballCategory:") then clubhouse.ballCategoryCallback(name,c);return end
  if c:sub(1,11)=="choosePage:" then clubhouse.choosePage(name,c:sub(12));return end
  if c:sub(1, 7) == "ranking" and c ~= "ranking" then
    rankingCallback(name, c)
    return
  end
  if c == "profileClose" then
    if profileState[name] then removeUITrophies(name) end
    return
  elseif c:sub(1, 11) == "profileMode" then
    updateProfileMode(name, tonumber(c:sub(12)))
    return
  elseif c == "profileEquipTrophy" then
    equipProfileTrophy(name)
    return
  end
  if c == "menuOpen" then
    if profileState[name] then removeUITrophies(name) end
    closeRankingUI(name)
    clubhouse.menu(name)
  elseif c == "menuClose" then
    clubhouse.clear(name,"menu")
    clubhouse.launcher(name,23)
    clubhouse.restoreLobbyControls(name)
  elseif c == "howToPlay" then
    removeUITrophies(name)
    openRank[name] = false
    closeRankingUI(name)
    pagesList[name].helpPage = 1
    windowForHelp(name, pagesList[name].helpPage, playerLanguage[name].tr.nextMessage,
      playerLanguage[name].tr.previousMessage)
  elseif string.sub(c, 1, 8) == "nextHelp" or string.sub(c, 1, 8) == "prevHelp" then
    pagesList[name].helpPage = tonumber(string.sub(c, 9))
    windowForHelp(name, pagesList[name].helpPage, playerLanguage[name].tr.nextMessage,
      playerLanguage[name].tr.previousMessage)
  elseif c == "credits" then
    removeUITrophies(name)
    openRank[name] = false
    closeRankingUI(name)
    clubhouse.document(name,"credits")
  elseif c == "realmode" then
    removeUITrophies(name)
    openRank[name] = false
    closeRankingUI(name)
    ui.addWindow(266, "" .. playerLanguage[name].tr.realModeRules .. "", name, 125, 60, 650, 300, 1, false, true,
      playerLanguage[name].tr.closeUIText)
  elseif c == "closeWindow" then
    closeAllWindows(name)
  elseif c == "roomadmin" then
    tfm.exec.chatMessage("<rose>/room *#volley0" .. name .. "<n>", name)
  elseif string.sub(c, 1, 4) == "sync" and USER_PERMISSIONS[name] and USER_PERMISSIONS[name] > 2 then
    local playerSync = string.sub(c, 5)

    if not tfm.get.room.playerList[playerSync] or playerSync:find("*",1,true) then
      tfm.exec.chatMessage("<bv>" .. clubhouse.escape(clubhouse.text(name,"sync.missing")) .. "<n>", name)
      windowUISync({ name })
    else
      if not requestPlayerSync(playerSync, name) then return end
      closeAllWindows(name)
      tfm.exec.chatMessage("<bv>Set new player sync: " .. playerSync .. " selected by admin "..name.."<n>", nil)
    end
  elseif clubhouse.settingsCallback(name, c) then
    return
  elseif c == "ranking" then
    openRankingUI(name)
  elseif string.sub(c, 1, 7) == "trophie" then
    local index = tonumber(string.sub(c, 8))
    showProfileTrophy(name, index)
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
end
