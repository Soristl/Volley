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

  local function drawSettingsRows(name, page)
    local rows=page==1 and settingsRows[1] or settingsRows[2]
    for i=1,4 do
      local row=rows[i]
      local event=row.event
      clubhouse.label(name,"settings","label_"..i,clubhouse.text(name,"settings."..row.label))
      local value=clubhouse.text(name,roomConfig.settings[row.option] and "state.enabled" or "state.disabled")
      if i==1 then
        local values=page==1 and roomConfig.modeNames() or roomConfig.mapTypeNames()
        for j,v in ipairs(values) do
          if tostring(roomConfig.settings[row.option]):lower()==v:lower() then value=clubhouse.text(name,(page==1 and modeKeys or sizeKeys)[j]) end
        end
        if uiState.settingsMode[name] then event=page==1 and "closeMode" or "closeMapType" end
      end
      local available = not ((i==3 and page==1 and gameState.match.mode.realMode) or (i==1 and page==2 and (gameState.match.mode.teamsMode or gameState.match.mode.twoTeamsMode or gameState.match.mode.realMode)))
      clubhouse.label(name,"settings","action_"..i,value,available and event or nil,available and "#E3ECE7" or "#718B83")
    end
  end

  local function drawSettingsDropdown(name, page)
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

  function clubhouse.settings(name)
    if not uiState.settings[name] then return end
    local admin=(roomConfig.permissions[name] or 1)>=2
    clubhouse.panel(name,"settings")
    clubhouse.closeLabel(name,"settings")
    local page=admin and (tonumber(uiState.pagePlayerSettings[name]) or 1) or 3
    if page<1 or page>4 then page=1 end
    uiState.pagePlayerSettings[name]=page
    if not uiState.settingsMode[name] or page~=1 then clubhouse.clear(name,"dropdown_modes") end
    if not uiState.settingsMode[name] or page~=2 then clubhouse.clear(name,"dropdown_map_sizes") end
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
    drawSettingsRows(name, page)
    clubhouse.navigation(name,"settings",page==1 and 1 or 3,4,"prevSettings4",page==1 and "nextSettings4" or "nextSettings3")
    if uiState.settingsMode[name] then
      drawSettingsDropdown(name, page)
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

-- Personal display changes belong to the settings panel after the shared input guard.
function clubhouse.personalDisplayCallback(name, c)
  if not uiState.settings[name] or uiState.pagePlayerSettings[name]~=3 or not (clubhouse.views[name] and clubhouse.views[name].settings) then return end
  if c=='toggleMapBackground' then mapBackgrounds.toggleHidden(name)
  else mapBackgrounds.toggleBorders(name) end
  clubhouse.personalDisplayOptions(name)
end

function clubhouse.defaultMapSettings(name)
  local current=roomConfig.settings.defaultMap or clubhouse.text(name,"defaultMap.standard")
  local available=not gameState.match.mode.realMode and gameState.phase=="startGame"
  clubhouse.label(name,"settings","label_1",clubhouse.text(name,"defaultMap.title"))
  clubhouse.label(name,"settings","action_1",clubhouse.shorten(current,24),available and "chooseDefaultMap" or nil,available and "#E3ECE7" or "#718B83")
  clubhouse.label(name,"settings","label_2",clubhouse.text(name,"defaultMap.reset"))
  clubhouse.label(name,"settings","action_2",clubhouse.text(name,"defaultMap.standard"),roomConfig.settings.defaultMap and "clearDefaultMap" or nil)
  clubhouse.label(name,"settings","label_3",clubhouse.text(name,"defaultMap.condition"),nil,"#A9BCB4")
  clubhouse.label(name,"settings","label_4",clubhouse.text(name,gameState.match.mode.realMode and "defaultMap.real" or "defaultMap.fallback"),nil,"#A9BCB4")
  for i=3,4 do clubhouse.label(name,"settings","action_"..i,"") end
end

function clubhouse.defaultMapCallback(name,callback)
  if (roomConfig.permissions[name] or 1)<2 or gameState.phase~="startGame" then return end
  local views=clubhouse.views[name] or {}
  local picking=views.selector and views.selector.defaultMapPicker
  if callback=="chooseDefaultMap" or callback=="clearDefaultMap" then
    if not uiState.settings[name] or uiState.pagePlayerSettings[name]~=4 or not views.settings then return end
    if callback=="clearDefaultMap" then roomConfig.settings.defaultMap=nil;clubhouse.refreshSettings();return end
    if gameState.match.mode.realMode then return end
    clubhouse.closeWindows(name)
    uiState.selectMapOpen[name]=true
    clubhouse.state(name,"selector").defaultMapPicker=true
    clubhouse.mapSelector(name)
    return
  end
  if not picking or not uiState.selectMapOpen[name] then return end
  if callback~="returnDefaultSettings" then
    local index=tonumber(callback:match("^setDefaultMap:(%d+)$"))
    if not index or not gameMaps.isAvailable(index) then return end
    roomConfig.settings.defaultMap=gameMaps.selectionCatalog()[index][3]
  end
  clubhouse.closeWindows(name)
  uiState.settings[name]=true;uiState.pagePlayerSettings[name]=4
  clubhouse.refreshSettings()
end

-- The event router validates the player and applies personal click delays first.
-- Keep settings mutations and their UI refreshes with the settings panel.
do
-- Each action keeps its own messages and refresh scope; the router keeps the permission checks.
local function selectRoomMode(name, c)
  local modes = roomConfig.modeNames()
  local index = tonumber(c:sub(8))

  if not index or not modes[index] then return true end
  uiState.settingsMode[name] = false
  roomConfig.settings.mode = modes[index]
  roomConfig.logMessage("<bv>The room has been set to " .. modes[index] .. ", selected by the admin " .. name .. "<n>")
  clubhouse.refreshSettings()
  return true
end

local function toggleTwoBalls(name)
  if roomConfig.settings.twoBalls then
    roomConfig.settings.twoBalls = false
    roomConfig.logMessage("<bv>The two balls command was disabled globally in the room, selected by the admin " .. name .. "<n>")
  else
    roomConfig.settings.twoBalls = true
    roomConfig.logMessage("<bv>The two balls command was enabled globally in the room, selected by the admin " .. name .. "<n>")
    print("<bv>The two balls command was enabled globally in the room, selected by the admin " .. name .. "<n>")
  end
  clubhouse.refreshSettings()
end

local function toggleThreeBalls(name)
  if roomConfig.settings.threeBalls then
    roomConfig.settings.threeBalls = false
    roomConfig.logMessage("<bv>The three balls on 3 teams mode command was disabled globally in the room, selected by the admin " ..
      name .. "<n>")
  else
    roomConfig.settings.threeBalls = true
    roomConfig.logMessage("<bv>The three balls on 3 teams mode command was enabled globally in the room, selected by the admin " ..
      name .. "<n>")
    print("<bv>The three balls on 3 teams mode command was enabled globally in the room, selected by the admin " ..
      name .. "<n>")
  end
  clubhouse.refreshSettings()
end

local function toggleRandomBall(name)
  if roomConfig.settings.randomBall then
    roomConfig.settings.randomBall = false
    roomConfig.logMessage("<bv>The random ball command was disabled globally in the room, selected by the admin " .. name .. "<n>")
  else
    roomConfig.settings.randomBall = true
    print("<bv>The random ball command was enabled globally in the room, selected by the admin " .. name .. "<n>")
    roomConfig.logMessage("<bv>The random ball command was enabled globally in the room, selected by the admin " .. name .. "<n>")
  end
  clubhouse.refreshSettings()
end

local function selectMapSize(name, c)
  local modes = roomConfig.mapTypeNames()
  local index = tonumber(c:sub(11))

  if not index or not modes[index] then return true end
  uiState.settingsMode[name] = false
  roomConfig.settings.mapType = string.lower(modes[index])
  if gameState.phase == 'startGame' and not gameState.match.mode.threeTeamsMode then
    gameState.match.maps.setMapName = roomConfig.settings.mapType
    gameMaps.refreshSizeSelection()
  end
  roomConfig.logMessage("<bv>The map size in normal mode was set by " .. modes[index] .. " by the admin " .. name .. "<n>")
  clubhouse.refreshSettings()
  return true
end

local function changeSettingsPage(name, c)
  local page = tonumber(string.sub(c, 13))
  if page ~= 1 and page ~= 2 and page ~= 3 and page ~= 4 then return true end
  if (roomConfig.permissions[name] or 1)<2 and page~=3 then return true end
  uiState.settingsMode[name] = false
  uiState.pagePlayerSettings[name] = page

  clubhouse.refreshSettings(name)
  return true
end

local function toggleRandomMap(name)
  if roomConfig.settings.randomMap then
    roomConfig.settings.randomMap = false
    print("<bv>The random map command was disabled globally in the room, selected by the admin " .. name .. "<n>")
    roomConfig.logMessage("<bv>The random map command was disabled globally in the room, selected by the admin " .. name .. "<n>")
  else
    roomConfig.settings.randomMap = true
    print("<bv>The random map command was enabled globally in the room, selected by the admin " .. name .. "<n>")
    roomConfig.logMessage("<bv>The random map command was enabled globally in the room, selected by the admin " .. name .. "<n>")
  end

  clubhouse.refreshSettings()
end

local function toggleConsumables(name)
  if roomConfig.settings.consumables then
    roomConfig.settings.consumables = false

    roomConfig.logMessage("<bv>The consumables command has been disabled globally by the admin " .. name .. "<n>")
  else
    roomConfig.settings.consumables = true

    roomConfig.logMessage("<bv>The consumables command has been enabled globally by the admin " .. name .. "<n>")
  end

  clubhouse.refreshSettings()
end

local function toggleMinimalist(name)
  if roomConfig.settings.minimalist then
    roomConfig.settings.minimalist = false

    tfm.exec.chatMessage('<bv>Minimalist mode for maps disabled by admin '..name..'<n>', nil)
    print('<bv>Minimalist mode for maps disabled by admin '..name..'<n>')
  else
    roomConfig.settings.minimalist = true

    tfm.exec.chatMessage('<bv>Minimalist mode for maps enabled by admin '..name..'<n>', nil)
    print('<bv>Minimalist mode for maps enabled by admin '..name..'<n>')
  end

  clubhouse.refreshSettings(name)
end

function clubhouse.settingsCallback(name, c)
  if c == "openMode" and roomConfig.permissions[name] and roomConfig.permissions[name] > 1 then
    uiState.settingsMode[name] = true
    clubhouse.settings(name)
  elseif c:sub(1, 7) == "setMode" then
    return selectRoomMode(name, c)
  elseif c == "closeMode" then
    uiState.settingsMode[name] = false
    clubhouse.settings(name)
  elseif c == "twoballs" and roomConfig.permissions[name] and roomConfig.permissions[name] > 1 then
    toggleTwoBalls(name)
  elseif c == "threeballs" and roomConfig.permissions[name] and roomConfig.permissions[name] > 1 then
    toggleThreeBalls(name)
  elseif c == "randomball" and roomConfig.permissions[name] and roomConfig.permissions[name] > 1 then
    toggleRandomBall(name)
  elseif c == "openMapType" and roomConfig.permissions[name] and roomConfig.permissions[name] > 1 then
    uiState.settingsMode[name] = true
    clubhouse.settings(name)
  elseif c:sub(1, 10) == "setMapType" and not gameState.match.mode.teamsMode and not gameState.match.mode.twoTeamsMode and not gameState.match.mode.realMode then
    return selectMapSize(name, c)
  elseif c == "closeMapType" then
    uiState.settingsMode[name] = false
    clubhouse.settings(name)
  elseif string.sub(c, 1, 12) == 'nextSettings' or string.sub(c, 1, 12) == 'prevSettings' then
    return changeSettingsPage(name, c)
  elseif c == "randommap" and not gameState.match.mode.realMode and roomConfig.permissions[name] and roomConfig.permissions[name] > 1 then
    toggleRandomMap(name)
  elseif c == "consumables" then
    toggleConsumables(name)
  elseif c == "settings" then
    clubhouse.closeWindows(name, true)
    uiState.settings[name] = true

    clubhouse.refreshSettings(name)
  elseif c == "minimalist" then
    toggleMinimalist(name)
  else
    return false
  end
  return true
end
end
