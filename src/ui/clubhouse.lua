-- Presentation state is owned per player and panel; gameplay callbacks remain in their original handlers.
clubhouse.interiors = {
  profile = "06-profile-interieur-v3-660x330.png",
  ranking = "02-leaderboard-interieur-740x350.png"
}
clubhouse.images[clubhouse.interiors.profile] = "img@1a0802469b1"
clubhouse.images[clubhouse.interiors.ranking] = "1a077f1595d.png"
clubhouse.images["01-changement-page-compact-267x87.png"] = "1a077f12583.png"
-- Module Team image references are passed verbatim, including their img@ prefix.
clubhouse.images["01-help-v3-650x300.png"] = "img@1a08021daa1"
clubhouse.screens.help.file = "01-help-v3-650x300.png"
clubhouse.images["02-credits-real-mode-v3-650x300.png"] = "img@1a08022017f"
clubhouse.screens.credits.file = "02-credits-real-mode-v3-650x300.png"
clubhouse.screens.real_rules.file = "02-credits-real-mode-v3-650x300.png"
clubhouse.images["03-profile-v3-660x330.png"] = "img@1a080223096"
clubhouse.screens.profile.file = "03-profile-v3-660x330.png"
clubhouse.images["04-ranking-v3-740x350.png"] = "img@1a08023b49f"
clubhouse.screens.ranking.file = "04-ranking-v3-740x350.png"
clubhouse.images["05-sync-v3-400x250.png"] = "img@1a08023e460"
clubhouse.screens.sync.file = "05-sync-v3-400x250.png"
clubhouse.inputAt = {}
clubhouse.selectionTimers = {}
clubhouse.strings["lobby.selector"]={en="Maps / Balls",fr="Cartes / Ballons",br="Mapas / Bolas",pl="Mapy / Piłki",ar="الخرائط / الكرات"}
clubhouse.ballCategoryState = {}
clubhouse.ballCategoryKeys = {"collection", "classic", "worldcup"}
clubhouse.strings["ball.category.label"]={en="Category",fr="Catégorie",br="Categoria",pl="Kategoria",ar="الفئة"}
clubhouse.strings["ball.category.classic"]={en="Classics",fr="Classiques",br="Clássicos",pl="Klasyczne",ar="كلاسيكية"}
clubhouse.strings["ball.category.collection"]={en="Collection",fr="Collection",br="Coleção",pl="Kolekcja",ar="المجموعة"}
clubhouse.strings["ball.category.worldcup"]={en="World Cup",fr="Coupe du monde",br="Copa do Mundo",pl="Puchar Świata",ar="كأس العالم"}
clubhouse.strings["ball.category.empty"]={en="No balls yet",fr="Aucun ballon",br="Nenhuma bola",pl="Brak piłek",ar="لا توجد كرات"}
clubhouse.pageRequests = {}
clubhouse.nextPageRequest = 1000000
clubhouse.strings["navigation.prompt"]={en="Enter a page number (1–{pages}).",fr="Saisis un numéro de page (1–{pages}).",br="Digite o número da página (1–{pages}).",pl="Wpisz numer strony (1–{pages}).",ar="أدخل رقم الصفحة (1–{pages})."}
clubhouse.strings["navigation.invalid"]={en="Invalid page. Enter a whole number from 1 to {pages}.",fr="Page invalide. Saisis un nombre entier entre 1 et {pages}.",br="Página inválida. Digite um número inteiro entre 1 e {pages}.",pl="Nieprawidłowa strona. Wpisz liczbę całkowitą od 1 do {pages}.",ar="صفحة غير صالحة. أدخل عدداً صحيحاً من 1 إلى {pages}."}
clubhouse.strings["navigation.cancel"]={en="Cancel",fr="Annuler",br="Cancelar",pl="Anuluj",ar="إلغاء"}
clubhouse.strings["navigation.confirm"]={en="Go",fr="Valider",br="Ir",pl="Przejdź",ar="انتقل"}
clubhouse.strings["navigation.invalidCompact"]={en="Invalid page (1–{pages}).",fr="Page invalide (1–{pages}).",br="Página inválida (1–{pages}).",pl="Nieprawidłowa strona (1–{pages}).",ar="صفحة غير صالحة (1–{pages})."}
clubhouse.strings["navigation.erase"]={en="Erase",fr="Effacer",br="Apagar",pl="Usuń",ar="حذف"}
clubhouse.inputBudget = {tokens=4, at=0}

function clubhouse.allowInput(name, closing)
  if not tfm.get.room.playerList[name] then return false end
  local now=os.time()
  if closing then
    if not clubhouse.hasPanel(name) then return false end
    clubhouse.inputAt[name]=now+750
    return true
  end
  if now < (clubhouse.inputAt[name] or 0) then return false end
  local budget=clubhouse.inputBudget
  budget.tokens=math.min(4,budget.tokens+math.max(0,now-budget.at)/250)
  budget.at=now
  if budget.tokens<1 then return false end
  budget.tokens=budget.tokens-1
  clubhouse.inputAt[name]=now+750
  return true
end

function clubhouse.language(name)
  local translation = playerLanguage[name] and playerLanguage[name].tr or trad
  for _, code in ipairs({"fr", "en", "br", "pl", "ar"}) do
    if lang[code] == translation then return code end
  end
  return "en"
end

function clubhouse.text(name, key, values)
  local strings = clubhouse.strings[key]
  local result = strings and (strings[clubhouse.language(name)] or strings.en) or key
  return (result:gsub("{(%w+)}", function(token) return tostring(values and values[token] or "—") end))
end

function clubhouse.escape(text)
  return tostring(text):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;"):gsub("'", "&#39;")
end

function clubhouse.shorten(text, limit)
  local count, result = 0, {}
  for char in tostring(text):gmatch("[%z\1-\127\194-\244][\128-\191]*") do
    count = count + 1
    if count > limit then return table.concat(result) .. "…" end
    result[#result + 1] = char
  end
  return table.concat(result)
end

function clubhouse.each(name, callback)
  if name then callback(name) else
    for player in pairs(tfm.get.room.playerList) do callback(player) end
  end
end

function clubhouse.state(name, key)
  clubhouse.views[name] = clubhouse.views[name] or {}
  local views = clubhouse.views[name]
  views[key] = views[key] or {images = {}, areas = {}}
  return views[key]
end

function clubhouse.clear(name, key)
  clubhouse.each(name, function(player)
    local views = clubhouse.views[player]
    local state = views and views[key]
    if not state then return end
    -- Remove ownership first: cleanup may be invoked by a legacy textarea removal.
    local request=clubhouse.pageRequests[player]
    if request and request.view==state then clubhouse.closePageInput(player) end
    views[key] = nil
    for _, image in pairs(state.images) do tfm.exec.removeImage(image) end
    for id in pairs(state.areas) do ui.removeTextArea(id, player) end
  end)
end

function clubhouse.beginUpdate(name, key)
  local state = clubhouse.state(name, key)
  state.drawnAreas, state.drawnImages = {}, {}
  return state
end

function clubhouse.hideArea(name, key, id)
  local state = clubhouse.views[name] and clubhouse.views[name][key]
  local area = state and state.areaSpecs and state.areaSpecs[id]
  if area and area.alpha>0 then clubhouse.removeArea(name,key,id);return end
  if area and area.text ~= "" then
    ui.updateTextArea(id, "", name)
    area.text = ""
  end
end

function clubhouse.removeArea(name, key, id)
  local state = clubhouse.views[name] and clubhouse.views[name][key]
  ui.removeTextArea(id, name)
  if state then
    state.areas[id] = nil
    if state.areaSpecs then state.areaSpecs[id] = nil end
  end
end

function clubhouse.endUpdate(name, key)
  local state = clubhouse.views[name] and clubhouse.views[name][key]
  if not state or not state.drawnAreas then return end
  -- LuaJ cannot continue next() after its current key is deleted.
  -- Collect obsolete slots first, then mutate the ownership tables.
  local areas, images = {}, {}
  for id in pairs(state.areas) do
    if not state.drawnAreas[id] then areas[#areas+1] = id end
  end
  for slot in pairs(state.images) do
    if not state.drawnImages[slot] then images[#images+1] = slot end
  end
  for _,id in ipairs(areas) do clubhouse.hideArea(name, key, id) end
  for _,slot in ipairs(images) do
    tfm.exec.removeImage(state.images[slot])
    state.images[slot] = nil
    if state.imageSpecs then state.imageSpecs[slot] = nil end
  end
  state.drawnAreas, state.drawnImages = nil, nil
end

function clubhouse.imageId(name, key, image, x, y, slot, target, scaleX, scaleY)
  local state = clubhouse.state(name, key)
  if state.drawnImages then state.drawnImages[slot] = true end
  if not image or image == "" then
    if state.images[slot] then tfm.exec.removeImage(state.images[slot]) end
    state.images[slot] = nil
    if state.imageSpecs then state.imageSpecs[slot] = nil end
    return nil
  end
  target, scaleX, scaleY = target or "&1", scaleX or 1, scaleY or 1
  local signature = table.concat({image, target, x, y, scaleX, scaleY}, "|")
  state.imageSpecs = state.imageSpecs or {}
  if state.images[slot] and state.imageSpecs[slot] == signature then return state.images[slot] end
  local previous = state.images[slot]
  local id = tfm.exec.addImage(image, target, x, y, name, scaleX, scaleY)
  if previous then tfm.exec.removeImage(previous) end
  state.images[slot] = id
  state.imageSpecs[slot] = id and signature or nil
  return id
end

function clubhouse.image(name, key, file, x, y, slot, target, scaleX, scaleY)
  return clubhouse.imageId(name, key, clubhouse.images[file], x, y, slot or file, target, scaleX, scaleY)
end

function clubhouse.area(name, key, id, text, x, y, width, height, background, fixed, border, alpha)
  local state = clubhouse.state(name, key)
  if state.drawnAreas then state.drawnAreas[id] = true end
  if alpha == nil then alpha = background and 1 or 0 end
  background = background or 0x142B2E
  border = border or background
  fixed = fixed ~= false
  -- Transparent backing colors do not affect the rendered area.
  local signature = table.concat({x,y,width,height,alpha==0 and 0 or background,alpha==0 and 0 or border,alpha,tostring(fixed)}, "|")
  state.areaSpecs = state.areaSpecs or {}
  local previous = state.areaSpecs[id]
  if state.areas[id] and previous and previous.signature == signature then
    if previous.text ~= text then ui.updateTextArea(id, text, name);previous.text = text end
    return
  end
  state.areas[id] = true
  state.areaSpecs[id] = {signature=signature, text=text, alpha=alpha}
  ui.addTextArea(id, text, name, x, y, width, height, background, border, alpha, fixed)
end

function clubhouse.panel(name, key)
  if key ~= "score" and key ~= "lobby" then clubhouse.hideLobbyControls(name) end
  local request=clubhouse.pageRequests[name]
  if request and clubhouse.views[name] and request.view==clubhouse.views[name][key] then clubhouse.closePageInput(name) end
  clubhouse.beginUpdate(name, key)
  local screen = clubhouse.screens[key]
  clubhouse.area(name, key, screen.base, "", screen.x, screen.y, screen.width, screen.height)
  if not clubhouse.image(name, key, screen.file, screen.x, screen.y, "background", "~" .. screen.base) then
    -- A missing hosted frame is explicit and never substituted with the map selector's different layout.
    clubhouse.area(name, key, screen.base, "", screen.x, screen.y, screen.width, screen.height, 0x142B2E)
  end
  local interior = clubhouse.interiors[key]
  if interior then clubhouse.image(name, key, interior, screen.x, screen.y, "interior", "~" .. screen.base) end
  local titles = clubhouse.titles[key]
  local title = titles and (titles[clubhouse.language(name)] or titles.en)
  if title then clubhouse.image(name, key, title.file, title.x, title.y, "title", "~" .. screen.base) end
  return screen
end

-- Match the hosted close rings, independently of translated text and its typeface.
clubhouse.closeIcons = {
  settings = {x=595, y=19, width=32, height=25, font_size=18, align="center"},
  selector = {x=595, y=19, width=32, height=25, font_size=18, align="center"},
  selector_balls = {x=595, y=19, width=32, height=25, font_size=18, align="center"},
  menu = {x=165, y=13, width=20, height=20, font_size=14, align="center"},
  profile = {x=617, y=15, width=24, height=22, font_size=14, align="center"},
  ranking = {x=697, y=15, width=24, height=22, font_size=14, align="center"},
  help = {x=607, y=15, width=24, height=22, font_size=14, align="center"},
  credits = {x=607, y=15, width=24, height=22, font_size=14, align="center"},
  real_rules = {x=607, y=15, width=24, height=22, font_size=14, align="center"},
  sync = {x=357, y=15, width=24, height=22, font_size=14, align="center"}
}

function clubhouse.label(name, key, region, text, event, color)
  local screen = clubhouse.screens[key]
  local r = screen.regions[region]
  if not r then return end
  local closeIcon = region == "close" and (clubhouse.closeIcons[key] or r.display == "close_icon")
  if closeIcon then r = clubhouse.closeIcons[key] or r end
  if key == "selector" or key == "selector_balls" then
    local layout={};for field,value in pairs(r) do layout[field]=value end;r=layout
    -- Allow for the native text field's padding inside the thin hosted buttons.
    if region:match("^select_") or region:match("^vote_") or region == "previous" or region == "next" or region == "page" then
      r.y=r.y-4;r.height=20
    end
    if region == "page" then r.x=r.x+(r.width-80)/2;r.width=80 end
    if region == "tab_left" or region == "tab_right" then r.y=r.y+2 end
    if key == "selector_balls" and region == "tab_right" then
      r.x=r.x+24;r.width=r.width-48;r.font_size=11
    end
    if key == "selector" and region:match("^name_") then r.font_size=10 end
    if region == "previous" or region == "next" then r.y=r.y+2 end
  elseif (key == "help" or key == "settings") and (region == "previous" or region == "next") then
    local layout={};for field,value in pairs(r) do layout[field]=value end;r=layout
    if key == "help" then
      r.x=region=="previous" and 33 or 483;r.width=136;r.align="center";r.font_size=10
      r.y=r.y+3;r.height=20
    else r.y=r.y-3;r.height=20 end
  end
  local state = clubhouse.state(name, key)
  state.ids = state.ids or {}
  if not state.ids[region] then state.next = (state.next or screen.base) + 1; state.ids[region] = state.next end
  local value = clubhouse.escape(text or clubhouse.text(name, r.text_key))
  if event then value = "<a href='event:" .. clubhouse.escape(event) .. "'>" .. value .. "</a>" end
  value = "<p align='" .. (closeIcon and "center" or r.align or (clubhouse.language(name) == "ar" and "right" or "left")) .. "'><font face='" ..
    (not closeIcon and clubhouse.language(name) == "ar" and "Arial" or "Verdana") .. "' size='" .. (r.font_size or 11) .. "' color='" ..
    (color or r.color or "#E3ECE7") .. "'>" .. value .. "</font></p>"
  clubhouse.area(name, key, state.ids[region], value, screen.x + r.x, screen.y + r.y, r.width, r.height)
end

function clubhouse.closeLabel(name, key, event)
  local r = clubhouse.screens[key].regions.close
  if r then clubhouse.label(name, key, "close", "×", event or "closeWindow") end
end

function clubhouse.navigation(name, key, page, pages, previous, following)
  clubhouse.state(name,key).navigation={page=page,pages=pages}
  clubhouse.label(name, key, "page", clubhouse.text(name, "action.page", {page=page, pages=pages}),pages>2 and "choosePage:"..key or nil,pages>2 and "#DEC18A" or nil)
  clubhouse.label(name, key, "previous", clubhouse.text(name, "action.previous"), page > 1 and previous or nil, page > 1 and "#E3ECE7" or "#718B83")
  clubhouse.label(name, key, "next", clubhouse.text(name, "action.next"), page < pages and following or nil, page < pages and "#E3ECE7" or "#718B83")
end

function clubhouse.closePageInput(name)
  clubhouse.pageRequests[name]=nil
  clubhouse.clear(name,"pageInput")
end

function clubhouse.pageInputValue(name,invalid)
  local request=clubhouse.pageRequests[name]
  if not request then return end
  clubhouse.area(name,"pageInput",97003,"<p align='center'><font face='Verdana' size='12' color='#DEC18A'>"..(request.digits~="" and request.digits or "—").."</font></p>",281,181,237,21)
  local message=clubhouse.text(name,invalid and "navigation.invalidCompact" or "navigation.prompt",{pages=request.pages})
  clubhouse.area(name,"pageInput",97002,"<p align='center'><font face='Verdana' size='10' color='"..(invalid and "#EF7777" or "#A9BCB4").."'>"..clubhouse.escape(message).."</font></p>",281,164,237,17)
end

function clubhouse.choosePage(name,key)
  local view=clubhouse.views[name] and clubhouse.views[name][key]
  local navigation=view and view.navigation
  if not navigation or navigation.pages<=2 then return end
  if key=="selector_balls" then clubhouse.closeBallCategories(name) end
  clubhouse.closePageInput(name)
  clubhouse.nextPageRequest=clubhouse.nextPageRequest+1
  local id=clubhouse.nextPageRequest
  clubhouse.pageRequests[name]={id=id,key=key,view=view,pages=navigation.pages,digits="",inputAt=0}
  clubhouse.area(name,"pageInput",97000,"",266,156,267,87)
  clubhouse.image(name,"pageInput","01-changement-page-compact-267x87.png",266,156,"background","~97000")
  local function button(area,label,action,x)
    clubhouse.area(name,"pageInput",area,"<p align='center'><font face='Verdana' size='11' color='#E3ECE7'><a href='event:pageInput:"..id..":"..action.."'>"..clubhouse.escape(label).."</a></font></p>",x,210,112,21)
  end
  button(97031,clubhouse.text(name,"navigation.cancel"),"cancel",283)
  button(97032,clubhouse.text(name,"navigation.confirm"),"go",406)
  -- Bind both number rows. Outside page entry, the existing gameplay handlers
  -- remain in charge; do not unbind digits used by force or consumables.
  for digit=0,9 do
    system.bindKeyboard(name,48+digit,true,true)
    system.bindKeyboard(name,96+digit,true,true)
  end
  for _,key in ipairs({8,13,27}) do system.bindKeyboard(name,key,true,true) end
  clubhouse.pageInputValue(name)
end

function clubhouse.pageInputCallback(name,callback,keyboard)
  local id,action=callback:match("^pageInput:(%d+):(%w+)$")
  local request=clubhouse.pageRequests[name]
  if not request or request.id~=tonumber(id) then return end
  local view=clubhouse.views[name] and clubhouse.views[name][request.key]
  if view~=request.view or not view.navigation or view.navigation.pages<=2 then clubhouse.closePageInput(name);return end
  if action=="cancel" then clubhouse.closePageInput(name);return end
  if action=="go" then
    if not clubhouse.allowInput(name,false) then return end
    local page=tonumber(request.digits)
    if not page or page<1 or page>view.navigation.pages then clubhouse.pageInputValue(name,true);return end
    local key=request.key
    clubhouse.closePageInput(name)
    if page==view.navigation.page then return end
    if key=="help" then clubhouse.document(name,"help",page)
    elseif key=="selector" and selectMapOpen[name] then selectMapPage[name]=page;selectMapUI(name)
    elseif key=="selector_balls" and selectBallOpen[name] then selectBallPage[name]=page;selectBallUI(name)
    elseif key=="ranking" then rankingCallback(name,"rankingPage"..page) end
  elseif action=="back" or action:match("^%d$") then
    -- Editing touches only two text areas; expensive page redraws keep the shared gate.
    local now=os.time()
    -- Page numbers such as 11 can be typed faster than the click throttle.
    -- Growth is bounded by the page count; erase still uses the throttle.
    if now<request.inputAt and not (keyboard and action:match("^%d$")) then return end
    request.inputAt=now+150
    if action=="back" then request.digits=request.digits:sub(1,-2)
    elseif #request.digits<#tostring(request.pages) then request.digits=request.digits..action
    else return end
    clubhouse.pageInputValue(name)
  end
end

-- Consume page-entry keys before gameplay, while preserving P/L panel toggles.
function clubhouse.pageInputKey(name,key,down)
  local request=clubhouse.pageRequests[name]
  if not request or key==KEYS.PROFILE or key==KEYS.RANK then return false end
  if not down then return true end
  local action
  if key>=48 and key<=57 then action=tostring(key-48)
  elseif key>=96 and key<=105 then action=tostring(key-96)
  elseif key==8 then action="back"
  elseif key==13 then action="go"
  elseif key==27 then action="cancel" end
  if action then clubhouse.pageInputCallback(name,"pageInput:"..request.id..":"..action,true) end
  return true
end

function clubhouse.document(name, key, page)
  if not (clubhouse.views[name] and clubhouse.views[name][key]) then closeAllWindows(name)
  else clubhouse.closePageInput(name) end
  clubhouse.panel(name, key)
  clubhouse.closeLabel(name, key)
  if key == "help" then
    local pages = clubhouse.documentPages
    page = math.max(1, math.min(#pages, math.floor(tonumber(page) or 1)))
    pagesList[name].helpPage = page
    clubhouse.helpDocument(name, page)
    clubhouse.navigation(name, key, page, #pages, "prevHelp" .. (page-1), "nextHelp" .. (page+1))
  elseif key == "credits" then
    clubhouse.creditsDocument(name)
  elseif key == "real_rules" then
    clubhouse.realDocument(name)
  end
  clubhouse.endUpdate(name, key)
end

function clubhouse.launcher(name, id)
  clubhouse.each(name, function(player)
    local index = id == 23 and 1 or id == 30 and 2 or 3
    local b = clubhouse.launchers[index]
    local key = "launcher" .. id
    if (id ~= 23 and clubhouse.hasPanel(player)) or (id == 31 and (USER_PERMISSIONS[player] or 1) < 2) or mode ~= "startGame" then
      clubhouse.clear(player, key);return
    end
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
  if mode ~= "startGame" then return end
  if not (clubhouse.views[name] and clubhouse.views[name].menu) then closeAllWindows(name) end
  clubhouse.clear(name, "launcher23")
  clubhouse.panel(name, "menu")
  clubhouse.closeLabel(name, "menu", "menuClose")
  for i,event in ipairs({"howToPlay","realmode","ranking","credits"}) do clubhouse.label(name,"menu","item_" .. i,nil,event) end
  clubhouse.endUpdate(name, "menu")
end

function clubhouse.clearPanels(name)
  clubhouse.each(name,function(player)
    for key in pairs(clubhouse.screens) do
      if key ~= "lobby" and key ~= "score" and key ~= "victory" and key ~= "podium" then clubhouse.clear(player,key) end
    end
    clubhouse.launcher(player,23)
    clubhouse.restoreLobbyControls(player)
  end)
end

function clubhouse.lobby(name)
  if mode ~= "startGame" then return end
  clubhouse.each(name,function(player)
    clubhouse.clear(player,"lobby")
    -- A transparent full-screen textarea still intercepts clicks on the lobby controls.
    -- Ground-layer images need no textarea; remove the old overlay on every refresh.
    ui.removeTextArea(92999,player)
    -- Keep the image origin inside the lobby while retaining the same overscan.
    -- Center (400,165), scale .75 and anchors .5 produce bounds (-800,-510,2400,1350).
    -- Ground depth keeps mice and buttons above the backdrop.
    clubhouse.state(player,"lobby").images.background = tfm.exec.addImage(
      clubhouse.images["01-lobby-details-v2-3200x1800.png"], "_1000", 400, 165, player,
      0.75, 0.75, 0, 1, 0.5, 0.5)
    clubhouse.image(player,"lobby","18-logo-volley.png",165,20,"logo","_1001")
    clubhouse.image(player,"lobby","19-logo-clubhouse.png",455,24,"clubhouse","_1002")
  end)
end

function clubhouse.joinArea(id, text, name, x, y, width, height, background, border, alpha, fixed)
  local event = tostring(text):match("event:([^'\"]+)")
  local action, team
  if event then action, team = event:match("^(%a+)Team(%a+)%d+$") end
  if width ~= 150 or height ~= 40 or not team then
    return ui.addTextArea(id,text,name,x,y,width,height,background,border,alpha,fixed)
  end
  local occupied = action == "leave"
  local filename
  for _, asset in ipairs(clubhouse.joins.assets) do
    if asset.team == team:lower() and asset.state == (occupied and "occupied" or "free") then filename=asset.file; break end
  end
  clubhouse.joinAreas[id] = {text=text,x=x,y=y,width=width,height=height,background=background,border=border,alpha=alpha,fixed=fixed}
  clubhouse.each(name,function(player)
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
    if mode~="startGame" or clubhouse.hasPanel(player) then
      clubhouse.clear(player,"lobbyTimer")
      return
    end
    clubhouse.area(player,"lobbyTimer",7,"<p align='center'><font size='18' color='#E3ECE7'>" .. string.format("%d",gameStats.initTimer) .. "</font></p>",375,65,50,25)
  end)
end

function clubhouse.hideLobbyControls(name)
  clubhouse.clear(name,"lobbyTimer")
  for id in pairs(clubhouse.joinAreas) do clubhouse.clear(name,"join"..id) end
  clubhouse.clear(name,"launcher30");clubhouse.clear(name,"launcher31")
end

function clubhouse.restoreLobbyControls(name)
  if not tfm.get.room.playerList[name] or mode~="startGame" or clubhouse.hasPanel(name) then return end
  clubhouse.lobbyTimer(name)
  for id,r in pairs(clubhouse.joinAreas) do clubhouse.joinArea(id,r.text,name,r.x,r.y,r.width,r.height,r.background,r.border,r.alpha,r.fixed) end
  clubhouse.launcher(name,30);clubhouse.launcher(name,31)
end

function clubhouse.removeLobby()
  clubhouse.each(nil,function(player)
    clubhouse.clear(player,"launcher23")
    clubhouse.clear(player,"menu")
    clubhouse.clear(player,"lobby")
    clubhouse.clear(player,"lobbyTimer")
    for id in pairs(clubhouse.joinAreas) do clubhouse.clear(player,"join" .. id) end
  end)
  clubhouse.joinAreas = {}
end

function clubhouse.settings(name)
  if not settings[name] or (USER_PERMISSIONS[name] or 1) < 2 then return end
  clubhouse.panel(name,"settings")
  clubhouse.closeLabel(name,"settings")
  local page=pagePlayerSettings[name] == 2 and 2 or 1
  if not settingsMode[name] or page~=1 then clubhouse.clear(name,"dropdown_modes") end
  if not settingsMode[name] or page~=2 then clubhouse.clear(name,"dropdown_map_sizes") end
  clubhouse.label(name,"settings","tab_left",nil,"prevSettings1",page==1 and "#DEC18A" or "#A9BCB4")
  clubhouse.label(name,"settings","tab_right",nil,"nextSettings2",page==2 and "#DEC18A" or "#A9BCB4")
  local labels=page==1 and {"mode","randomball","randommap","two_balls"} or {"map_size","consumables","three_balls","minimalist"}
  local options=page==1 and {"mode","randomBall","randomMap","twoBalls"} or {"mapType","consumables","threeBalls","minimalist"}
  local events=page==1 and {"openMode","randomball","randommap","twoballs"} or {"openMapType","consumables","threeballs","minimalist"}
  local modeKeys={"mode.normal","mode.four","mode.three","mode.two","mode.real"}
  local sizeKeys={"size.small","size.large","size.extra_large"}
  for i=1,4 do
    clubhouse.label(name,"settings","label_"..i,clubhouse.text(name,"settings."..labels[i]))
    local value=clubhouse.text(name,globalSettings[options[i]] and "state.enabled" or "state.disabled")
    if i==1 then
      local values=page==1 and getModesText() or getMapTypesText()
      for j,v in ipairs(values) do
        if tostring(globalSettings[options[i]]):lower()==v:lower() then value=clubhouse.text(name,(page==1 and modeKeys or sizeKeys)[j]) end
      end
      if settingsMode[name] then events[i]=page==1 and "closeMode" or "closeMapType" end
    end
    local available = not ((i==3 and page==1 and gameStats.realMode) or (i==1 and page==2 and (gameStats.teamsMode or gameStats.twoTeamsMode or gameStats.realMode)))
    clubhouse.label(name,"settings","action_"..i,value,available and events[i] or nil,available and "#E3ECE7" or "#718B83")
  end
  clubhouse.navigation(name,"settings",page,2,"prevSettings1","nextSettings2")
  if settingsMode[name] then
    local key=page==1 and "dropdown_modes" or "dropdown_map_sizes"
    local popup=clubhouse.screens[key]
    local screen=clubhouse.screens.settings
    local state=clubhouse.state(name,"settings")
    for region,id in pairs(state.ids or {}) do
      local r=screen.regions[region]
      if screen.x+r.x+r.width>popup.x and screen.x+r.x<popup.x+popup.width and screen.y+r.y+r.height>popup.y and screen.y+r.y<popup.y+popup.height then
        clubhouse.removeArea(name,"settings",id)
      end
    end
    clubhouse.panel(name,key)
    for i,k in ipairs(page==1 and modeKeys or sizeKeys) do
      clubhouse.label(name,key,"option_"..i,clubhouse.text(name,k),(page==1 and "setMode" or "setMapType")..i)
    end
    clubhouse.endUpdate(name,key)
  end
  clubhouse.endUpdate(name,"settings")
end

function clubhouse.ballCategory(name)
  local state=clubhouse.ballCategoryState[name]
  if not state then
    state={selected="collection",pages={classic=1,collection=1,worldcup=1}}
    clubhouse.ballCategoryState[name]=state
  end
  return state
end

function clubhouse.ballItems(name,category)
  category=category or clubhouse.ballCategory(name).selected
  local items,indices={},{}
  for index,ball in ipairs(balls) do
    if (ball.category or "classic")==category then
      indices[#indices+1]=index
    end
  end
  table.sort(indices,function(a,b)
    local first,second=balls[a].categoryOrder or a,balls[b].categoryOrder or b
    return first==second and a<b or first<second
  end)
  for _,index in ipairs(indices) do items[#items+1]=balls[index] end
  return items,indices
end

function clubhouse.ballCategoryLabel(name)
  local view=clubhouse.views[name] and clubhouse.views[name].selector_balls
  if not view then return end
  local text=clubhouse.text(name,"tab.balls").." · "..clubhouse.text(name,"ball.category.label").." / "..clubhouse.text(name,"ball.category."..clubhouse.ballCategory(name).selected)
  clubhouse.label(name,"selector_balls","tab_right",text,
    view.categoryMenu and "ballCategoriesClose" or "ballCategoriesOpen","#DEC18A")
  local screen=clubhouse.screens.selector_balls
  local r=screen.regions.tab_right
  local available=0
  for _,key in ipairs(clubhouse.ballCategoryKeys) do
    if #clubhouse.ballItems(name,key)>0 then available=available+1 end
  end
  for i,direction in ipairs({"previous","next"}) do
    local arrow=i==1 and "←" or "→"
    if available>1 then arrow="<a href='event:ballCategory:"..direction.."'>"..arrow.."</a>" end
    clubhouse.area(name,"selector_balls",97610+i,
      "<p align='center'><font face='Verdana' size='15' color='"..(available>1 and "#DEC18A" or "#718B83").."'>"..arrow.."</font></p>",
      screen.x+r.x+(i==1 and -2 or r.width-24),screen.y+r.y-1,26,25)
  end
end

function clubhouse.closeBallCategories(name)
  local view=clubhouse.views[name] and clubhouse.views[name].selector_balls
  if not view or not view.categoryMenu then return end
  view.categoryMenu=nil
  for id=97600,97603 do clubhouse.removeArea(name,"selector_balls",id) end
  if view.images.categoryMenu then tfm.exec.removeImage(view.images.categoryMenu);view.images.categoryMenu=nil end
  clubhouse.ballCategoryLabel(name)
end

function clubhouse.ballCategoryCallback(name,callback)
  if not selectBallOpen[name] or not (clubhouse.views[name] and clubhouse.views[name].selector_balls) then return end
  if callback=="ballCategoriesClose" then clubhouse.closeBallCategories(name);return end
  if callback=="ballCategoriesOpen" then
    clubhouse.closePageInput(name)
    local view=clubhouse.views[name].selector_balls
    if view.categoryMenu then return end
    view.categoryMenu=true
    local screen=clubhouse.screens.selector_balls
    local x,y=screen.x+435,screen.y+89
    clubhouse.area(name,"selector_balls",97600,"",x,y,190,98)
    clubhouse.image(name,"selector_balls","30-dropdown-map-sizes-190x98.png",x,y,"categoryMenu","~97600")
    for i,key in ipairs(clubhouse.ballCategoryKeys) do
      local items=clubhouse.ballItems(name,key)
      local selected=clubhouse.ballCategory(name).selected==key
      local text=clubhouse.escape(clubhouse.text(name,"ball.category."..key)).." ("..#items..")"
      local color=#items==0 and "#718B83" or selected and "#DEC18A" or "#E3ECE7"
      text="<font color='"..color.."'>"..text.."</font>"
      if #items>0 then text="<a href='event:ballCategory:"..key.."'>"..text.."</a>" end
      if selected then text="<b>"..text.."</b>" end
      clubhouse.area(name,"selector_balls",97600+i,
        "<p align='center'><font face='"..(clubhouse.language(name)=="ar" and "Arial" or "Verdana").."' size='11' color='"..
        color.."'>"..text.."</font></p>",x+10,y+9+(i-1)*26,170,23)
    end
    clubhouse.ballCategoryLabel(name)
    return
  end
  local category=callback:match("^ballCategory:(%a+)$")
  local state=clubhouse.ballCategory(name)
  if category=="previous" or category=="next" then
    local step=category=="previous" and -1 or 1
    local keys=clubhouse.ballCategoryKeys
    local current=1
    for i,key in ipairs(keys) do if key==state.selected then current=i;break end end
    category=state.selected
    for offset=1,#keys do
      local candidate=keys[(current-1+step*offset)%#keys+1]
      if #clubhouse.ballItems(name,candidate)>0 then category=candidate;break end
    end
  end
  if category~="classic" and category~="collection" and category~="worldcup" then return end
  if #clubhouse.ballItems(name,category)==0 then return end
  if state.selected==category then clubhouse.closeBallCategories(name);return end
  state.pages[state.selected]=selectBallPage[name] or 1
  state.selected=category
  selectBallPage[name]=state.pages[category] or 1
  selectBallUI(name)
end

-- Update just the five actions when the shared map/ball cooldown expires.
function clubhouse.selectorActions(name,isBall)
  local key=isBall and "selector_balls" or "selector"
  if not (clubhouse.views[name] and clubhouse.views[name][key]) then return end
  local items,indices
  if isBall then items,indices=clubhouse.ballItems(name) else items=configSelectMap() end
  local page=(isBall and selectBallPage or selectMapPage)[name] or 1
  local enabled=(USER_PERMISSIONS[name] or 1)>1 and customMapCommand[name] and mode=="startGame" and not gameStats.realMode
  for i=1,5 do
    local index=(page-1)*5+i
    if items[index] then
      local selectedIndex=isBall and indices[index] or index
      local selected=isBall and gameStats.customBall and gameStats.customBallId==selectedIndex or not isBall and gameStats.isCustomMap and gameStats.customMapIndex==index
      clubhouse.label(name,key,"select_"..i,clubhouse.text(name,selected and (isBall and "ball.selected" or "map.selected") or "action.select"),
        not selected and enabled and ((isBall and "setball" or "setmap")..selectedIndex) or nil,selected and "#DEC18A" or enabled and "#E3ECE7" or "#718B83")
    end
  end
end

function clubhouse.selectionCooldown(name)
  customMapCommand[name]=false
  if clubhouse.selectionTimers[name] then removeTimer(clubhouse.selectionTimers[name]) end
  clubhouse.selectionTimers[name]=addTimer(function()
    clubhouse.selectionTimers[name]=nil
    if not tfm.get.room.playerList[name] then return end
    customMapCommand[name]=true
    clubhouse.selectorActions(name,false)
    clubhouse.selectorActions(name,true)
  end,2000,1,"clubhouseSelection:"..name)
end

function clubhouse.selector(name, isBall)
  local key=isBall and "selector_balls" or "selector"
  if not (clubhouse.views[name] and clubhouse.views[name][key]) then removeSelectUI(name) end
  clubhouse.closePageInput(name)
  if isBall then clubhouse.closeBallCategories(name) end
  clubhouse.clear(name,isBall and "selector" or "selector_balls")
  local s=clubhouse.panel(name,key)
  clubhouse.closeLabel(name,key)
  local items=isBall and clubhouse.ballItems(name) or configSelectMap()
  local pages=math.max(1,math.ceil(#items/5))
  local state=isBall and selectBallPage or selectMapPage
  local page=math.max(1,math.min(pages,math.floor(tonumber(state[name]) or 1)));state[name]=page
  if isBall then local category=clubhouse.ballCategory(name);category.pages[category.selected]=page end
  clubhouse.label(name,key,"tab_left",nil,isBall and "selectMap" or nil,not isBall and "#DEC18A" or "#A9BCB4")
  if isBall then clubhouse.ballCategoryLabel(name)
  else clubhouse.label(name,key,"tab_right",nil,"selectBall","#A9BCB4") end
  for i=1,5 do
    local index=(page-1)*5+i;local item=items[index]
    if item then
      local title=isBall and item.name or item[3]
      clubhouse.label(name,key,"name_"..i,clubhouse.shorten(title,isBall and 38 or 18),not isBall and ("map"..item[3]) or nil)
      if not isBall then
        local vote=canVote[name] and mode=="startGame" and not gameStats.realMode
        clubhouse.label(name,key,"vote_"..i,clubhouse.text(name,"action.vote",{count=showMapVotes(items,index)}),vote and "votemap"..index or nil,vote and "#E3ECE7" or "#718B83")
      end
      local r=s.regions["preview_"..i];local image=isBall and (item.previewImage or item.image) or item[6]
      if image and image~="" then
        local w=isBall and (item.previewSize or item.size or 40) or 100;local h=isBall and w or 43
        local view=clubhouse.state(name,key)
        -- Keep previews above the opaque frame and owned by this panel across map changes.
        clubhouse.imageId(name,key,image,s.x+r.x+math.floor((r.width-w)/2),s.y+r.y+math.floor((r.height-h)/2),"preview_"..i,"~"..view.ids["name_"..i])
      end
    end
  end
  if isBall and #items==0 then clubhouse.label(name,key,"name_3",clubhouse.text(name,"ball.category.empty")) end
  clubhouse.selectorActions(name,isBall)
  clubhouse.navigation(name,key,page,pages,(isBall and "prevSelectBall" or "prevSelectMap")..(page-1),(isBall and "nextSelectBall" or "nextSelectMap")..(page+1))
  clubhouse.endUpdate(name,key)
end

function clubhouse.sync(name)
  if not (clubhouse.views[name] and clubhouse.views[name].sync) then closeAllWindows(name) end
  clubhouse.panel(name,"sync");clubhouse.closeLabel(name,"sync")
  clubhouse.label(name,"sync","instruction")
  local candidates={}
  for player,data in pairs(tfm.get.room.playerList) do
    if not player:find("*",1,true) then candidates[#candidates+1]={name=player,latency=math.max(0,tonumber(data.averageLatency) or 0)} end
  end
  table.sort(candidates,function(a,b) return a.latency==b.latency and a.name<b.name or a.latency<b.latency end)
  if #candidates==0 then clubhouse.label(name,"sync","empty");clubhouse.endUpdate(name,"sync");return end
  for i=1,math.min(5,#candidates) do
    clubhouse.label(name,"sync","name_"..i,clubhouse.shorten(candidates[i].name,30),"sync"..candidates[i].name)
    clubhouse.label(name,"sync","ping_"..i,clubhouse.text(name,"sync.latency",{latency=candidates[i].latency}))
  end
  clubhouse.endUpdate(name,"sync")
end

function clubhouse.refresh(name)
  closeAllWindows(name)
  clubhouse.launcher(name,23);clubhouse.launcher(name,30);clubhouse.launcher(name,31)
  if mode=="startGame" then
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

function clubhouse.guardCallback(name, callback)
  if type(callback) ~= "string" or #callback>256 then return true end
  local settingsAction = ({openMode=true,closeMode=true,openMapType=true,closeMapType=true,twoballs=true,threeballs=true,
    randomball=true,randommap=true,consumables=true,minimalist=true})[callback] or callback:match("^setMode") or
    callback:match("^setMapType") or callback:match("^nextSettings") or callback:match("^prevSettings")
  if settingsAction and ((USER_PERMISSIONS[name] or 1)<2 or not settings[name]) then return true end
  local action,team,index=callback:match("^(%a+)Team(%a+)(%d+)$")
  if action=="join" or action=="leave" then
    if clubhouse.hasPanel(name) then return true end
    index=tonumber(index)
    local roster=({Red=playersRed,Blue=playersBlue,Green=playersGreen,Yellow=playersYellow})[team]
    if team=="Blue" then index=teamBlueIndex(index) end
    if not roster or not index or not roster[index] then return true end
  end
  if callback:match("^nextSelectMap") or callback:match("^prevSelectMap") then return not selectMapOpen[name] end
  if callback:match("^nextSelectBall") or callback:match("^prevSelectBall") then return not selectBallOpen[name] end
  return false
end

function clubhouse.clearPlayer(name)
  clubhouse.pageRequests[name]=nil
  clubhouse.ballCategoryState[name]=nil
  if clubhouse.selectionTimers[name] then removeTimer(clubhouse.selectionTimers[name]);clubhouse.selectionTimers[name]=nil end
  clubhouse.inputAt[name]=nil
  local views=clubhouse.views[name]
  if views then
    local keys={};for key in pairs(views) do keys[#keys+1]=key end
    for _,key in ipairs(keys) do clubhouse.clear(name,key) end
  end
  clubhouse.views[name]=nil
end

function clubhouse.reset()
  local names={};for name in pairs(clubhouse.views) do names[#names+1]=name end
  for _,name in ipairs(names) do clubhouse.clearPlayer(name) end
  clubhouse.joinAreas={};clubhouse.scoreAreas={}
end

function clubhouse.newGame()
  clubhouse.each(nil,function(name)
    closeAllWindows(name)
    clubhouse.clear(name,"victory")
    clubhouse.clear(name,"score")
  end)
  if mode=="startGame" then clubhouse.lobby() else clubhouse.removeLobby() end
end

function clubhouse.drawScores(entries)
  -- Frames and numbers share map coordinates, so neither follows the camera.
  clubhouse.each(nil,function(player)
    clubhouse.beginUpdate(player,"score")
    for slot,entry in ipairs(entries) do
      local x = entry.x
      -- Cover the legacy grounds within their layer, below mice and shaman objects.
      clubhouse.image(player,"score","02-score-couverture-100x106.png",x,-8,"score"..slot,"_1000")
      clubhouse.area(player,"score",96100+slot,
        "<p align='center'><font face='Verdana' size='30' color='"..entry.color.."'>"..tostring(entry.value).."</font></p>",
        x+8,29,84,43,nil,false)
      if entry.detail then
        clubhouse.area(player,"score",96200+slot,
          "<p align='center'><font size='20' color='"..entry.color.."'>"..entry.detail.."</font></p>",entry.detailX,20,100,30)
      end
    end
    clubhouse.endUpdate(player,"score")
  end)
end

function clubhouse.winner()
  clubhouse.each(nil,function(name)
    closeAllWindows(name)
    clubhouse.panel(name,"victory")
    local team
    if gameStats.teamsMode or gameStats.threeTeamsMode then
      local text=messageWinners[1] or ""
      team = text:find("<r>",1,true) and "red" or text:find("<bv>",1,true) and "blue" or text:find("<j>",1,true) and "yellow" or text:find("<vp>",1,true) and "green"
      if not team then
        local detected=getTeamName(text)
        team=detected and detected:lower()
      end
    else team=teamsScores.red>=gameStats.winscore and "red" or "blue" end
    local detail=team and clubhouse.strings["team."..team] and clubhouse.text(name,"victory.winner",{team=clubhouse.text(name,"team."..team)}) or
      tostring(messageWinners[1] or ""):gsub("<[^>]+>","")
    clubhouse.label(name,"victory","detail",detail)
    clubhouse.endUpdate(name,"victory")
  end)
end
