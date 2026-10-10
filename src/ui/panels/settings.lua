do
  local settingsRows = {
    {
      { label = "mode", option = "mode", event = "openMode" },
      { label = "randomball", option = "randomBall", event = "randomball" },
      { label = "randommap", option = "randomMap", event = "randommap" },
      { label = "two_balls", option = "twoBalls", event = "twoballs" },
    },
    {
      { label = "map_size", option = "mapType", event = "openMapType" },
      { label = "consumables", option = "consumables", event = "consumables" },
      { label = "three_balls", option = "threeBalls", event = "threeballs" },
      { label = "minimalist", option = "minimalist", event = "minimalist" },
    },
  }
  local modeKeys = { "mode.normal", "mode.four", "mode.three", "mode.two", "mode.real" }
  local sizeKeys = { "size.small", "size.large", "size.extra_large" }

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
    local rows=page==1 and settingsRows[1] or settingsRows[2]
    for i=1,4 do
      local row=rows[i]
      local event=row.event
      clubhouse.label(name,"settings","label_"..i,clubhouse.text(name,"settings."..row.label))
      local value=clubhouse.text(name,globalSettings[row.option] and "state.enabled" or "state.disabled")
      if i==1 then
        local values=page==1 and getModesText() or getMapTypesText()
        for j,v in ipairs(values) do
          if tostring(globalSettings[row.option]):lower()==v:lower() then value=clubhouse.text(name,(page==1 and modeKeys or sizeKeys)[j]) end
        end
        if settingsMode[name] then event=page==1 and "closeMode" or "closeMapType" end
      end
      local available = not ((i==3 and page==1 and gameStats.realMode) or (i==1 and page==2 and (gameStats.teamsMode or gameStats.twoTeamsMode or gameStats.realMode)))
      clubhouse.label(name,"settings","action_"..i,value,available and event or nil,available and "#E3ECE7" or "#718B83")
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

-- The event router validates the player and applies personal click delays first.
-- Keep settings mutations and their UI refreshes with the settings panel.
function clubhouse.settingsCallback(name, c)
  if c == "openMode" and USER_PERMISSIONS[name] and USER_PERMISSIONS[name] > 1 then
    settingsMode[name] = true
    clubhouse.settings(name)
  elseif c:sub(1, 7) == "setMode" then
    local modes = getModesText()
    local index = tonumber(c:sub(8))

    if not index or not modes[index] then return true end
    settingsMode[name] = false
    globalSettings.mode = modes[index]
    messageLog("<bv>The room has been set to " .. modes[index] .. ", selected by the admin " .. name .. "<n>")
    updateSettingsUI()
  elseif c == "closeMode" then
    settingsMode[name] = false
    clubhouse.settings(name)
  elseif c == "twoballs" and USER_PERMISSIONS[name] and USER_PERMISSIONS[name] > 1 then
    if globalSettings.twoBalls then
      globalSettings.twoBalls = false
      messageLog("<bv>The two balls command was disabled globally in the room, selected by the admin " .. name .. "<n>")
    else
      globalSettings.twoBalls = true
      messageLog("<bv>The two balls command was enabled globally in the room, selected by the admin " .. name .. "<n>")
      print("<bv>The two balls command was enabled globally in the room, selected by the admin " .. name .. "<n>")
    end
    updateSettingsUI()
  elseif c == "threeballs" and USER_PERMISSIONS[name] and USER_PERMISSIONS[name] > 1 then
    if globalSettings.threeBalls then
      globalSettings.threeBalls = false
      messageLog("<bv>The three balls on 3 teams mode command was disabled globally in the room, selected by the admin " ..
        name .. "<n>")
    else
      globalSettings.threeBalls = true
      messageLog("<bv>The three balls on 3 teams mode command was enabled globally in the room, selected by the admin " ..
        name .. "<n>")
      print("<bv>The three balls on 3 teams mode command was enabled globally in the room, selected by the admin " ..
        name .. "<n>")
    end
    updateSettingsUI()
  elseif c == "randomball" and USER_PERMISSIONS[name] and USER_PERMISSIONS[name] > 1 then
    if globalSettings.randomBall then
      globalSettings.randomBall = false
      messageLog("<bv>The random ball command was disabled globally in the room, selected by the admin " .. name .. "<n>")
    else
      globalSettings.randomBall = true
      print("<bv>The random ball command was enabled globally in the room, selected by the admin " .. name .. "<n>")
      messageLog("<bv>The random ball command was enabled globally in the room, selected by the admin " .. name .. "<n>")
    end
    updateSettingsUI()
  elseif c == "openMapType" and USER_PERMISSIONS[name] and USER_PERMISSIONS[name] > 1 then
    settingsMode[name] = true
    clubhouse.settings(name)
  elseif c:sub(1, 10) == "setMapType" and not gameStats.teamsMode and not gameStats.twoTeamsMode and not gameStats.realMode then
    local modes = getMapTypesText()
    local index = tonumber(c:sub(11))

    if not index or not modes[index] then return true end
    settingsMode[name] = false
    globalSettings.mapType = string.lower(modes[index])
    if gameState.phase == 'startGame' and not gameStats.threeTeamsMode then
      gameStats.setMapName = globalSettings.mapType
      refreshMapSizeSelection()
    end
    messageLog("<bv>The map size in normal mode was set by " .. modes[index] .. " by the admin " .. name .. "<n>")
    updateSettingsUI()
  elseif c == "closeMapType" then
    settingsMode[name] = false
    clubhouse.settings(name)
  elseif string.sub(c, 1, 12) == 'nextSettings' or string.sub(c, 1, 12) == 'prevSettings' then
    local page = tonumber(string.sub(c, 13))
    if page ~= 1 and page ~= 2 and page ~= 3 and page ~= 4 then return true end
    if (USER_PERMISSIONS[name] or 1)<2 and page~=3 then return true end
    settingsMode[name] = false
    pagePlayerSettings[name] = page

    updateSettingsUI(name)
  elseif c == "randommap" and not gameStats.realMode and USER_PERMISSIONS[name] and USER_PERMISSIONS[name] > 1 then
    if globalSettings.randomMap then
      globalSettings.randomMap = false
      print("<bv>The random map command was disabled globally in the room, selected by the admin " .. name .. "<n>")
      messageLog("<bv>The random map command was disabled globally in the room, selected by the admin " .. name .. "<n>")
    else
      globalSettings.randomMap = true
      print("<bv>The random map command was enabled globally in the room, selected by the admin " .. name .. "<n>")
      messageLog("<bv>The random map command was enabled globally in the room, selected by the admin " .. name .. "<n>")
    end

    updateSettingsUI()
  elseif c == "consumables" then
    if globalSettings.consumables then
      globalSettings.consumables = false

      messageLog("<bv>The consumables command has been disabled globally by the admin " .. name .. "<n>")
    else
      globalSettings.consumables = true

      messageLog("<bv>The consumables command has been enabled globally by the admin " .. name .. "<n>")
    end

    updateSettingsUI()
  elseif c == "settings" then
    closeAllWindows(name, true)
    settings[name] = true

    updateSettingsUI(name)
  elseif c == "minimalist" then
    if globalSettings.minimalist then
      globalSettings.minimalist = false

      tfm.exec.chatMessage('<bv>Minimalist mode for maps disabled by admin '..name..'<n>', nil)
      print('<bv>Minimalist mode for maps disabled by admin '..name..'<n>')
    else
      globalSettings.minimalist = true

      tfm.exec.chatMessage('<bv>Minimalist mode for maps enabled by admin '..name..'<n>', nil)
      print('<bv>Minimalist mode for maps enabled by admin '..name..'<n>')
    end

    updateSettingsUI(name)
  else
    return false
  end
  return true
end
