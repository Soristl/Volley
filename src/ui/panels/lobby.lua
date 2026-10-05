function clubhouse.launcher(name, id)
  clubhouse.each(name, function(player)
    local index = id == 23 and 1 or id == 30 and 2 or 3
    local b = clubhouse.launchers[index]
    local key = "launcher" .. id
    if (id ~= 23 and clubhouse.hasPanel(player)) or gameState.phase ~= "startGame" then
      clubhouse.clear(player, key);return
    end
    if lobbyTransition and not lobbyTransition.allowsDraw(player) then return end
    -- Center the label across the complete frame, independently of its icon.
    local buttonY = id == 23 and 22 or b.y
    local area = 95500 + id
    if not clubhouse.state(player,key).areas[area] then clubhouse.area(player,key,area,"",b.x,buttonY,b.width,b.height) end
    clubhouse.image(player, key, b.file,b.x,buttonY,"background","~" .. area)
    clubhouse.area(player, key, area, "<p align='center'><font face='Verdana' size='11' color='#E3ECE7'><a href='event:" ..
      b.event .. "'>" .. clubhouse.escape(clubhouse.text(player,b.text_key)) .. "</a></font></p>",
      b.x+5,buttonY+6,b.width-10,20)
  end)
end

function clubhouse.menu(name)
  if gameState.phase ~= "startGame" then return end
  if not (clubhouse.views[name] and clubhouse.views[name].menu) then closeAllWindows(name) end
  clubhouse.clear(name, "launcher23")
  clubhouse.panel(name, "menu")
  clubhouse.closeLabel(name, "menu", "menuClose")
  for i,event in ipairs({"howToPlay","realmode","ranking","credits"}) do clubhouse.label(name,"menu","item_" .. i,nil,event) end
  clubhouse.endUpdate(name, "menu")
end

function clubhouse.clearPanels(name, skipRestore)
  clubhouse.each(name,function(player)
    for key in pairs(clubhouse.screens) do
      if key ~= "lobby" and key ~= "score" and key ~= "victory" and key ~= "podium" then clubhouse.clear(player,key) end
    end
    clubhouse.launcher(player,23)
    if not skipRestore then clubhouse.restoreLobbyControls(player) end
  end)
end

function clubhouse.clearLobbyArtwork(name)
  local personal=clubhouse.lobbyArtworkPlayers or {}
  if name then
    for _,id in pairs(personal[name] or {}) do tfm.exec.removeImage(id) end
    personal[name]=nil
    if clubhouse.lobbyArtworkViewers then clubhouse.lobbyArtworkViewers[name]=nil end
    return
  end
  for _,images in pairs(personal) do
    for _,id in pairs(images) do tfm.exec.removeImage(id) end
  end
  for _,id in pairs(clubhouse.lobbyArtwork or {}) do tfm.exec.removeImage(id) end
  clubhouse.lobbyArtwork=nil
  clubhouse.lobbyArtworkPlayers=nil
  clubhouse.lobbyArtworkViewers=nil
end

function clubhouse.lobby(name)
  if gameState.phase ~= "startGame" then return end
  if lobbyTransition and not lobbyTransition.allowsDraw(name) then return end
  if name and not tfm.get.room.playerList[name] then return end
  local viewers=clubhouse.lobbyArtworkViewers or {}
  clubhouse.lobbyArtworkViewers=viewers
  local artwork=clubhouse.lobbyArtwork
  local target
  if artwork then
    if not name or viewers[name] then return end
    -- Global images are not replayed to late arrivals. Send only their copy.
    clubhouse.lobbyArtworkPlayers=clubhouse.lobbyArtworkPlayers or {}
    artwork=clubhouse.lobbyArtworkPlayers[name] or {}
    clubhouse.lobbyArtworkPlayers[name]=artwork
    target=name
  else
    -- Keep the initial broadcast at three calls regardless of room size.
    artwork={}
    clubhouse.lobbyArtwork=artwork
  end
  if not artwork.background then
    artwork.background=tfm.exec.addImage(clubhouse.images['01-lobby-details-v2-3200x1800.png'],
      '_1000',400,165,target,0.75,0.75,0,1,0.5,0.5)
  end
  if not artwork.logo then
    artwork.logo=tfm.exec.addImage(clubhouse.images['18-logo-volley.png'],'_1001',165,20,target)
  end
  if not artwork.clubhouse then
    artwork.clubhouse=tfm.exec.addImage(clubhouse.images['19-logo-clubhouse.png'],'_1002',455,24,target)
  end
  if artwork.background and artwork.logo and artwork.clubhouse then
    if target then viewers[target]=true else
      for player in pairs(tfm.get.room.playerList) do viewers[player]=true end
    end
  end
end

function clubhouse.joinArea(id, text, name, x, y, width, height, background, border, alpha, fixed)
  local event = tostring(text):match("event:([^'\"]+)")
  local action, team
  if event then action, team = event:match("^(%a+)Team(%a+)%d+$") end
  if width ~= 150 or height ~= 40 or not team then
    if lobbyTransition and not lobbyTransition.allowsDraw(name) then return end
    return ui.addTextArea(id,text,name,x,y,width,height,background,border,alpha,fixed)
  end
  local occupied = action == "leave"
  local filename
  for _, asset in ipairs(clubhouse.joins.assets) do
    if asset.team == team:lower() and asset.state == (occupied and "occupied" or "free") then filename=asset.file; break end
  end
  clubhouse.joinAreas[id] = {text=text,x=x,y=y,width=width,height=height,background=background,border=border,alpha=alpha,fixed=fixed}
  clubhouse.each(name,function(player)
    if lobbyTransition and not lobbyTransition.allowsDraw(player) then return end
    local key="join" .. id
    if clubhouse.hasPanel(player) then clubhouse.clear(player,key);return end
    local signature=text..clubhouse.language(player)..x..":"..y
    local existing=clubhouse.views[player] and clubhouse.views[player][key]
    if existing and existing.signature==signature then return end
    local label = occupied and (text:match("'>[^<]*$") or ""):sub(3) or clubhouse.text(player,"action.join")
    if occupied and label == "" then label = text:gsub("<[^>]*>","") end
    label = clubhouse.shorten(label,18)
    local rendered = clubhouse.escape(label)
    if not occupied or text:find(">" .. player,1,true) then rendered="<a href='event:" .. event .. "'>" .. rendered .. "</a>" end
    clubhouse.image(player,key,filename,x,y,"background","~" .. id)
    clubhouse.area(player,key,id,"<p align='center'><font size='" .. (occupied and 10 or 12) .. "' color='#E3ECE7'>" .. rendered .. "</font></p>",x+18,y+9,116,20)
    clubhouse.state(player,key).signature=signature
  end)
end

function clubhouse.hasPanel(name)
  local views=clubhouse.views[name] or {}
  for key in pairs(clubhouse.screens) do
    if key~="lobby" and key~="score" and views[key] then return true end
  end
  return false
end

function clubhouse.lobbyTimer(name)
  clubhouse.each(name,function(player)
    if gameState.phase~="startGame" or clubhouse.hasPanel(player) then
      clubhouse.clear(player,"lobbyTimer")
      return
    end
    if lobbyTransition and not lobbyTransition.allowsDraw(player) then return end
    local state=clubhouse.state(player,"lobbyTimer")
    if state.seconds==gameStats.initTimer and state.areas[7] then return end
    clubhouse.area(player,"lobbyTimer",7,"<p align='center'><font size='18' color='#E3ECE7'>" .. string.format("%d",gameStats.initTimer) .. "</font></p>",375,65,50,25)
    state.seconds=gameStats.initTimer
  end)
end

function clubhouse.hideLobbyControls(name)
  clubhouse.clear(name,"lobbyTimer")
  for id in pairs(clubhouse.joinAreas) do clubhouse.clear(name,"join"..id) end
  clubhouse.clear(name,"launcher30");clubhouse.clear(name,"launcher31")
end

function clubhouse.restoreLobbyControls(name)
  if lobbyTransition and not lobbyTransition.allowsDraw(name) then return end
  if not tfm.get.room.playerList[name] or gameState.phase~="startGame" or clubhouse.hasPanel(name) then return end
  clubhouse.lobbyTimer(name)
  for id,r in pairs(clubhouse.joinAreas) do clubhouse.joinArea(id,r.text,name,r.x,r.y,r.width,r.height,r.background,r.border,r.alpha,r.fixed) end
  clubhouse.launcher(name,30);clubhouse.launcher(name,31)
end

function clubhouse.removeLobby()
  clubhouse.clearLobbyArtwork()
  clubhouse.each(nil,function(player)
    clubhouse.clear(player,"launcher23")
    clubhouse.clear(player,"menu")
    clubhouse.clear(player,"lobby")
    clubhouse.clear(player,"lobbyTimer")
    for id in pairs(clubhouse.joinAreas) do clubhouse.clear(player,"join" .. id) end
  end)
  clubhouse.joinAreas = {}
end
