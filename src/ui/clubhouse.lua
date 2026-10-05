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
clubhouse.strings["lobby.selector"]={en="Maps / Balls",fr="Cartes / Ballons",br="Mapas / Bolas",pl="Mapy / Piłki",ar="الخرائط / الكرات"}
clubhouse.ballCategoryState = {}
clubhouse.ballCategoryKeys = {"collection", "classic", "worldcup", "special"}
clubhouse.strings["ball.category.label"]={en="Category",fr="Catégorie",br="Categoria",pl="Kategoria",ar="الفئة"}
clubhouse.strings["ball.category.classic"]={en="Classics",fr="Classiques",br="Clássicos",pl="Klasyczne",ar="كلاسيكية"}
clubhouse.strings["ball.category.collection"]={en="Collection",fr="Collection",br="Coleção",pl="Kolekcja",ar="المجموعة"}
clubhouse.strings["ball.category.worldcup"]={en="World Cup",fr="Coupe du monde",br="Copa do Mundo",pl="Puchar Świata",ar="كأس العالم"}
clubhouse.strings["ball.category.special"]={en="Special",fr="Special",br="Special",pl="Special",ar="Special"}
clubhouse.strings["ball.category.empty"]={en="No balls yet",fr="Aucun ballon",br="Nenhuma bola",pl="Brak piłek",ar="لا توجد كرات"}
clubhouse.pageRequests = {}
clubhouse.nextPageRequest = 1000000
clubhouse.strings["navigation.prompt"]={en="Enter a page number (1–{pages}).",fr="Saisis un numéro de page (1–{pages}).",br="Digite o número da página (1–{pages}).",pl="Wpisz numer strony (1–{pages}).",ar="أدخل رقم الصفحة (1–{pages})."}
clubhouse.strings["navigation.invalid"]={en="Invalid page. Enter a whole number from 1 to {pages}.",fr="Page invalide. Saisis un nombre entier entre 1 et {pages}.",br="Página inválida. Digite um número inteiro entre 1 e {pages}.",pl="Nieprawidłowa strona. Wpisz liczbę całkowitą od 1 do {pages}.",ar="صفحة غير صالحة. أدخل عدداً صحيحاً من 1 إلى {pages}."}
clubhouse.strings["navigation.cancel"]={en="Cancel",fr="Annuler",br="Cancelar",pl="Anuluj",ar="إلغاء"}
clubhouse.strings["navigation.confirm"]={en="Go",fr="Valider",br="Ir",pl="Przejdź",ar="انتقل"}
clubhouse.strings["navigation.invalidCompact"]={en="Invalid page (1–{pages}).",fr="Page invalide (1–{pages}).",br="Página inválida (1–{pages}).",pl="Nieprawidłowa strona (1–{pages}).",ar="صفحة غير صالحة (1–{pages})."}
clubhouse.strings["navigation.erase"]={en="Erase",fr="Effacer",br="Apagar",pl="Usuń",ar="حذف"}

-- Each player's last accepted input; one player's clicks never throttle another.
clubhouse.inputAt = {}
clubhouse.selectionTimers = {}
function clubhouse.allowInput(name, closing, callback)
  if not tfm.get.room.playerList[name] then return false end
  if lobbyTransition and lobbyTransition.blocksInput() then return false end
  local now=os.time()
  if closing then
    if not clubhouse.hasPanel(name) then return false end
    clubhouse.inputAt[name]=now
    return true
  end
  local navigation = callback and (
    callback:match("^nextSelectMap%d+$") or callback:match("^prevSelectMap%d+$") or
    callback:match("^nextSelectBall%d+$") or callback:match("^prevSelectBall%d+$") or
    callback:match("^nextHelp%d+$") or callback:match("^prevHelp%d+$") or
    callback:match("^nextSettings%d+$") or callback:match("^prevSettings%d+$") or
    callback:match("^rankingPage%d+$") or
    callback=="ballCategory:next" or callback=="ballCategory:previous")
  local delay=navigation and 1000 or 1500
  -- All controls use the player's own clock. Rejected clicks do not restart it.
  if now-(clubhouse.inputAt[name] or -math.huge)<delay then return false end
  clubhouse.inputAt[name]=now
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
  local state = clubhouse.state(name, key)
  local language = clubhouse.language(name)
  local translation = not text and clubhouse.strings[r.text_key]
  local copy = translation and (translation[language] or translation.en) or r.text_key
  local cached = state.labelCache and state.labelCache[region]
  local id = state.ids and state.ids[region]
  local area = id and state.areaSpecs and state.areaSpecs[id]
  -- Keep one entry per region. Reuse only a still-visible, unchanged owned area;
  -- hidden/removed areas and changed layouts must follow the normal draw path.
  if cached and state.areas[id] and area == cached.area and area.text == cached.value
    and area.signature == cached.signature and cached.text == text and cached.event == event
    and cached.color == color and cached.language == language and cached.copy == copy
    and cached.screen == screen and cached.screenX == screen.x and cached.screenY == screen.y
    and cached.closeIcon == closeIcon and cached.x == r.x and cached.y == r.y
    and cached.width == r.width and cached.height == r.height and cached.align == r.align
    and cached.fontSize == r.font_size and cached.regionColor == r.color then
    if state.drawnAreas then state.drawnAreas[id] = true end
    return
  end
  local sourceRegion = r
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
  state.ids = state.ids or {}
  if not state.ids[region] then state.next = (state.next or screen.base) + 1; state.ids[region] = state.next end
  local value = clubhouse.escape(text or clubhouse.text(name, r.text_key))
  if event then value = "<a href='event:" .. clubhouse.escape(event) .. "'>" .. value .. "</a>" end
  value = "<p align='" .. (closeIcon and "center" or r.align or (language == "ar" and "right" or "left")) .. "'><font face='" ..
    (not closeIcon and language == "ar" and "Arial" or "Verdana") .. "' size='" .. (r.font_size or 11) .. "' color='" ..
    (color or r.color or "#E3ECE7") .. "'>" .. value .. "</font></p>"
  clubhouse.area(name, key, state.ids[region], value, screen.x + r.x, screen.y + r.y, r.width, r.height)
  area = state.areaSpecs[state.ids[region]]
  state.labelCache = state.labelCache or {}
  state.labelCache[region] = {text=text,event=event,color=color,language=language,copy=copy,
    screen=screen,screenX=screen.x,screenY=screen.y,closeIcon=closeIcon,
    x=sourceRegion.x,y=sourceRegion.y,width=sourceRegion.width,height=sourceRegion.height,
    align=sourceRegion.align,fontSize=sourceRegion.font_size,regionColor=sourceRegion.color,
    area=area,signature=area.signature,value=value}
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
  if lobbyTransition and lobbyTransition.blocksInput() then return end
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
    elseif key=="ranking" then rankingCallback(name,"rankingPage"..page)
    elseif key=="settings" and settings[name] and (USER_PERMISSIONS[name] or 1)>=2 then settingsMode[name]=false;pagePlayerSettings[name]=({1,4,2,3})[page];clubhouse.settings(name) end
  elseif action=="back" or action:match("^%d$") then
    -- Editing has its own per-request delay; confirmation uses the player's click delay.
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
  if lobbyTransition and lobbyTransition.blocksInput() then return true end
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


clubhouse.strings["display.background"]={en="Map backgrounds (personal)",fr="Arrière-plans (affichage individuel)",br="Fundos dos mapas (individual)",pl="Tła map (ustawienie osobiste)",ar="خلفيات الخرائط (إعداد شخصي)"}
clubhouse.strings["display.indicator"]={en="Wall indicators (personal)",fr="Indicateurs des murs (affichage individuel)",br="Indicadores das paredes (individual)",pl="Wskaźniki ścian (ustawienie osobiste)",ar="مؤشرات الجدران (إعداد شخصي)"}
clubhouse.strings["display.personal"]={en="Personal display — only affects you",fr="Affichage personnel : uniquement pour toi",br="Exibição pessoal: afeta apenas você",pl="Ustawienia widoku tylko dla ciebie",ar="إعدادات عرض شخصية تؤثر عليك فقط"}
clubhouse.strings["display.session"]={en="Kept until you leave the room",fr="Conservé jusqu’à ton départ du salon",br="Mantido até você sair da sala",pl="Zachowane do opuszczenia pokoju",ar="تُحفظ حتى مغادرة الغرفة"}
clubhouse.strings["display.hidden"]={en="Hidden",fr="Masqués",br="Ocultos",pl="Ukryte",ar="مخفية"}
clubhouse.strings["display.visible"]={en="Visible",fr="Visibles",br="Visíveis",pl="Widoczne",ar="مرئية"}

clubhouse.strings["defaultMap.title"]={en="Default map (room)",fr="Map par défaut (salon)"}
clubhouse.strings["defaultMap.back"]={en="Back to Game settings",fr="Retour aux paramètres de jeu"}
clubhouse.strings["defaultMap.standard"]={en="Standard court",fr="Terrain standard"}
clubhouse.strings["defaultMap.reset"]={en="Reset the default map",fr="Réinitialiser la map par défaut"}
clubhouse.strings["defaultMap.condition"]={en="Used without a selection, with random maps off.",fr="Sans sélection, lorsque l’aléatoire est désactivé."}
clubhouse.strings["defaultMap.fallback"]={en="Missing variant: use the standard court.",fr="Variante indisponible : retour au terrain standard."}
clubhouse.strings["defaultMap.real"]={en="Real mode uses its dedicated court.",fr="Le mode Real utilise son terrain dédié."}
