function clubhouse.settings(name)
  if not settings[name] then return end
  local admin=(USER_PERMISSIONS[name] or 1)>=2
  clubhouse.panel(name,"settings")
  clubhouse.closeLabel(name,"settings")
  local page=admin and (tonumber(pagePlayerSettings[name]) or 1) or 3
  if page<1 or page>4 then page=1 end
  pagePlayerSettings[name]=page
  if not settingsMode[name] or page~=1 then clubhouse.clear(name,"dropdown_modes") end
  if not settingsMode[name] or page~=2 then clubhouse.clear(name,"dropdown_map_sizes") end
  clubhouse.label(name,"settings","tab_left",nil,admin and "prevSettings1" or nil,(page==1 or page==4) and "#DEC18A" or "#A9BCB4")
  clubhouse.label(name,"settings","tab_right",nil,admin and "nextSettings2" or "nextSettings3",(page==2 or page==3) and "#DEC18A" or "#A9BCB4")
  if page==4 then
    clubhouse.defaultMapSettings(name)
    clubhouse.navigation(name,"settings",2,4,"prevSettings1","nextSettings2")
    clubhouse.endUpdate(name,"settings")
    return
  end
  if page==3 then
    clubhouse.personalDisplayOptions(name)
    clubhouse.label(name,"settings","label_3",clubhouse.text(name,"display.personal"),nil,"#DEC18A")
    clubhouse.label(name,"settings","label_4",clubhouse.text(name,"display.session"),nil,"#A9BCB4")
    for i=3,4 do clubhouse.label(name,"settings","action_"..i,"") end
    clubhouse.navigation(name,"settings",admin and 4 or 1,admin and 4 or 1,"prevSettings2",nil)
    clubhouse.endUpdate(name,"settings")
    return
  end
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
  clubhouse.navigation(name,"settings",page==1 and 1 or 3,4,"prevSettings4",page==1 and "nextSettings4" or "nextSettings3")
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

-- Reuse the hosted settings image and its two first action frames.
function clubhouse.personalDisplayOptions(name)
  clubhouse.label(name,"settings","label_1",clubhouse.text(name,"display.background"))
  clubhouse.label(name,"settings","label_2",clubhouse.text(name,"display.indicator"))
  clubhouse.label(name,"settings","action_1",clubhouse.text(name,mapBackgrounds.isHidden(name) and "display.hidden" or "display.visible"),"toggleMapBackground")
  clubhouse.label(name,"settings","action_2",clubhouse.text(name,mapBackgrounds.bordersHidden(name) and "display.hidden" or "display.visible"),"toggleCourtIndicator")
end

function clubhouse.defaultMapSettings(name)
  local current=globalSettings.defaultMap or clubhouse.text(name,"defaultMap.standard")
  local available=not gameStats.realMode and gameState.phase=="startGame"
  clubhouse.label(name,"settings","label_1",clubhouse.text(name,"defaultMap.title"))
  clubhouse.label(name,"settings","action_1",clubhouse.shorten(current,24),available and "chooseDefaultMap" or nil,available and "#E3ECE7" or "#718B83")
  clubhouse.label(name,"settings","label_2",clubhouse.text(name,"defaultMap.reset"))
  clubhouse.label(name,"settings","action_2",clubhouse.text(name,"defaultMap.standard"),globalSettings.defaultMap and "clearDefaultMap" or nil)
  clubhouse.label(name,"settings","label_3",clubhouse.text(name,"defaultMap.condition"),nil,"#A9BCB4")
  clubhouse.label(name,"settings","label_4",clubhouse.text(name,gameStats.realMode and "defaultMap.real" or "defaultMap.fallback"),nil,"#A9BCB4")
  for i=3,4 do clubhouse.label(name,"settings","action_"..i,"") end
end

function clubhouse.defaultMapCallback(name,callback)
  if (USER_PERMISSIONS[name] or 1)<2 or gameState.phase~="startGame" then return end
  local views=clubhouse.views[name] or {}
  local picking=views.selector and views.selector.defaultMapPicker
  if callback=="chooseDefaultMap" or callback=="clearDefaultMap" then
    if not settings[name] or pagePlayerSettings[name]~=4 or not views.settings then return end
    if callback=="clearDefaultMap" then globalSettings.defaultMap=nil;updateSettingsUI();return end
    if gameStats.realMode then return end
    closeAllWindows(name)
    selectMapOpen[name]=true
    clubhouse.state(name,"selector").defaultMapPicker=true
    selectMapUI(name)
    return
  end
  if not picking or not selectMapOpen[name] then return end
  if callback~="returnDefaultSettings" then
    local index=tonumber(callback:match("^setDefaultMap:(%d+)$"))
    if not index or not isMapAvailable(index) then return end
    globalSettings.defaultMap=configSelectMap()[index][3]
  end
  closeAllWindows(name)
  settings[name]=true;pagePlayerSettings[name]=4
  updateSettingsUI()
end
