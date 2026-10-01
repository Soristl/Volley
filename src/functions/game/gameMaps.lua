-- Map selection and gameplay preparation share one owner.
gameMaps = {}

-- Black Hole's jump ceiling blocks mice only; balls and transformed objects pass.
function gameMaps.applyPlayerCeiling()
  local code=tonumber((tostring(gameState.map.sourceTarget or tfm.get.room.currentMap):gsub('^@','')))
  local hosted=({[7984662]=true,[7984663]=true,[7984665]=true,[7984666]=true,[7984667]=true})[code]
  local xl=customMaps[57] and customMaps[57].extraLarge
  if not hosted and not (xl and (gameState.map.sourceTarget or gameState.map.target)==xl) then return end
  local xml=tfm.get.room.xmlMapInfo and tfm.get.room.xmlMapInfo.xml or ''
  local params=xml:match('<P%s+[^>]+>') or ''
  local width=tonumber(mapXml.attribute(params,'L')) or 800
  -- Revised Black Hole XML already includes this mouse-only ceiling.
  for tag in xml:gmatch('<S%s+[^>]*>') do
    if tonumber(mapXml.attribute(tag, 'Y')) == 225
      and tonumber(mapXml.attribute(tag, 'L')) == width
      and tonumber(mapXml.attribute(tag, 'H')) == 10
      and mapXml.attribute(tag, 'c') == '3'
      and mapXml.attribute(tag, 'm') ~= nil then return end
  end
  -- Its lower edge is 20 pixels above the divider top (250).
  tfm.exec.addPhysicObject(99998,width/2,225,{
    type=14,width=width,height=10,dynamic=false,friction=0,restitution=0,
    miceCollision=true,groundCollision=false
  })
end

do
  local extraLargeXML = '<C><P L="1800" F="0" G="0,4" MEDATA="13,1;;;;-0;0:::1-" /><Z><S><S T="7" X="900" Y="400" L="1800" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N="" m="" /><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0" m="" /><S T="1" X="901" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0" /><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" m="" /><S T="12" X="-10" Y="200" L="20" H="2000" P="0,0,0.2,0,0,0,0,0" o="FF0000" m="" /><S T="12" X="1810" Y="200" L="20" H="2000" P="0,0,0.2,0,0,0,0,0" o="FF0000" m="" /><S T="13" X="300" Y="359" L="10" P="0,0,0,0,0,0,0,0" o="324650" c="4" m="" /><S T="13" X="1500" Y="359" L="10" P="0,0,0,0,0,0,0,0" o="324650" c="4" m="" /><S T="12" X="250" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4" m="" /><S T="1" X="900" Y="-5" L="1800" H="10" P="0,0,0,0.2,0,0,0,0" c="3" /><S T="12" X="900" Y="95" L="1800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFF200" c="3" m="" /><S T="12" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" o="FFF200" c="3" m="" /><S T="12" X="1495" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" o="FFF200" c="3" m="" /><S T="12" X="900" Y="225" L="1800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFF200" c="3" m="" /><S T="12" X="900" Y="240" L="10" H="40" P="0,0,0,0,0,0,0,0" o="FFF200" c="3" m="" /><S T="12" X="900" Y="791" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" o="FF0000" m="" /><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3" m="" /><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3" m="" /><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3" m="" /><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3" m="" /><S T="12" X="900" Y="460" L="2600" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N="" m="" /><S T="12" X="1550" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4" m="" /><S T="12" X="900" Y="-800" L="1840" H="20" P="0,0,0,0.2,0,0,0,0" o="FF0000" m="" /><S T="12" X="900" Y="1190" L="1840" H="20" P="0,0,0,0.2,0,0,0,0" o="FF0000" m="" /></S><D><DS X="365" Y="-141" /></D><O /><L /></Z></C>'
  local realXML = '<C><P L="2600" F="0" G="0,4" MEDATA=";0,1;;;-0;0:::1-" /><Z><S><S T="7" X="1300" Y="400" L="2600" H="100" P="0,0,0.1,0.2,0,0,0,0" c="3" N="" m="" /><S T="9" X="600" Y="430" L="1200" H="10" P="0,0,0,0,0,0,0,0" m="" /><S T="1" X="1300" Y="350" L="10" H="200" P="0,0,0,0.2,0,0,0,0" /><S T="12" X="400" Y="455" L="800" H="10" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" m="" /><S T="12" X="-10" Y="200" L="20" H="2000" P="0,0,0.2,0,0,0,0,0" o="FF0000" m="" /><S T="12" X="2610" Y="200" L="20" H="2000" P="0,0,0.2,0,0,0,0,0" o="FF0000" m="" /><S T="13" X="700" Y="359" L="10" P="0,0,0,0,0,0,0,0" o="324650" c="4" m="" /><S T="13" X="1900" Y="359" L="10" P="0,0,0,0,0,0,0,0" o="324650" c="4" m="" /><S T="1" X="1300" Y="-5" L="2600" H="10" P="0,0,0,0.2,0,0,0,0" c="3" /><S T="12" X="1300" Y="95" L="2600" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFF200" c="3" m="" /><S T="12" X="305" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" o="FFF200" c="3" m="" /><S T="12" X="2295" Y="48" L="10" H="100" P="0,0,0.3,0.2,0,0,0,0" o="FFF200" c="3" m="" /><S T="12" X="1200" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4" m="" /><S T="12" X="1300" Y="225" L="2600" H="10" P="0,0,0.3,0.2,0,0,0,0" o="FFF200" c="3" m="" /><S T="12" X="1300" Y="240" L="10" H="40" P="0,0,0,0,0,0,0,0" o="FFF200" c="3" m="" /><S T="12" X="1300" Y="790" L="800" H="10" P="0,0,0.3,0.2,90,0,0,0" o="FF0000" N="" m="" /><S T="12" X="600" Y="770" L="10" H="840" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" N="" /><S T="12" X="2000" Y="770" L="10" H="840" P="0,0,0.3,0.2,0,0,0,0" o="FFFFFF" N="" /><S T="12" X="316" Y="-129" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3" m="" /><S T="12" X="407" Y="-133" L="20" H="200" P="0,0,0.2,0.2,0,0,0,0" o="6a7495" c="3" m="" /><S T="12" X="363" Y="-92" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3" m="" /><S T="12" X="360" Y="-206" L="20" H="100" P="0,0,0.2,0.2,90,0,0,0" o="6a7495" c="3" m="" /><S T="12" X="1300" Y="460" L="3400" H="120" P="0,0,0.3,0.2,0,0,0,0" o="6a7495" c="4" N="" m="" /><S T="12" X="1400" Y="45" L="100" H="105" P="0,0,0.3,0.2,0,0,0,0" o="324650" c="4" m="" /><S T="12" X="1300" Y="-800" L="2640" H="20" P="0,0,0,0.2,0,0,0,0" o="FF0000" m="" /><S T="12" X="1300" Y="1190" L="2640" H="20" P="0,0,0,0.2,0,0,0,0" o="FF0000" m="" /><S T="12" X="600" Y="355" L="10" H="10" P="0,0,20,0.2,45,0,0,0" o="FFFFFF" c="2" /><S T="12" X="2000" Y="355" L="10" H="10" P="0,0,20,0.2,45,0,0,0" o="FFFFFF" c="2" /></S><D><DS X="365" Y="-141" /></D><O /><L /></Z></C>'

  -- Expose the built-in XL court to selection, votes and size filtering.
  customMaps[6].extraLarge = extraLargeXML

  local function selectedMap(entry, column)
    if not entry then return nil end
    if gameStats.twoTeamsMode and column == 1 and entry.twoTeams then
      return entry.twoTeams
    end
    return entry[column]
  end

  local function choose(catalog, column, fallback, overrideIndex, announce)
    if mapsToTest[overrideIndex] ~= '' then
      return mapsToTest[overrideIndex], true, 'test'
    end
    if gameStats.isCustomMap then
      local map = selectedMap(catalog[gameStats.customMapIndex], column)
      if map then return map, true, 'custom' end
      return fallback, false, 'default'
    end
    if announce and gameStats.totalVotes == 1 then
      tfm.exec.chatMessage('<bv>It is necessary that at least 2 players have used the !votemap command for a map to be selected<n>', nil)
    end
    if gameStats.totalVotes >= 2 then
      local entry = catalog[gameStats.mapIndexSelected]
      local map = selectedMap(entry, column)
      if map then return map, true, 'vote', entry end
      return fallback, false, 'default'
    end
    if not globalSettings.randomMap and not gameStats.randomMap and globalSettings.defaultMap then
      for _, entry in ipairs(catalog) do
        if entry[3] == globalSettings.defaultMap then
          local map = selectedMap(entry, column)
          if type(map)=='string' and map~='' then return map, true, 'configuredDefault' end
          break
        end
      end
    end
    return fallback, false, 'default'
  end

  local function load(map, parseMarkers, large, printMap)
    loadGameplayMap(map)
    if printMap then print(map) end
    if parseMarkers then
      -- Capture the requested map: later selection changes must not alter
      -- metadata for the court whose delivery this timer is waiting for.
      addMapTimer(function(i)
        if i == 1 then
          foundBallSpawnsOnMap(map, large)
          foundMiceSpawnsOnMap(map, large)
        end
      end, 1000)
    end
  end

  local function announceVote(entry, printVote)
    local message = '<bv>The ' .. entry[3] .. ' map (created by ' .. entry[4]
      .. ') was selected (' .. tostring(mapsVotes[gameStats.mapIndexSelected]) .. ' votes)<n>'
    tfm.exec.chatMessage(message, nil)
    if printVote then print(message) end
  end

  local function normalLayout()
    local size = gameStats.setMapName
    if size == '' then return gameStats.gameMode == '3v3' and 1 or 2 end
    if size == 'small' then
      gameStats.gameMode, gameStats.redX, gameStats.blueX = '3v3', 399, 401
      return 1
    end
    if size == 'large' then
      gameStats.gameMode, gameStats.redX, gameStats.blueX = '4v4', 599, 601
      return 2
    end
    if size == 'extra-large' then
      gameStats.gameMode, gameStats.redX, gameStats.blueX = '6v6', 899, 901
      return 3
    end
  end

  function gameMaps.loadInitial()
    if gameStats.realMode then loadGameplayMap(realXML); return end

    local catalog, column, fallback, large, printVote
    if gameStats.threeTeamsMode then
      catalog, column, fallback = customMapsThreeTeamsMode, 1, customMapsThreeTeamsMode[1][1]
      large, printVote = false, true
    elseif gameStats.teamsMode or gameStats.twoTeamsMode then
      catalog, column, fallback = customMapsFourTeamsMode, 1, customMapsFourTeamsMode[34][1]
      large, printVote = false, true
    else
      column = normalLayout()
      if not column then return end
      catalog, large = customMaps, column == 2
      if column == 3 then
        column, fallback = 'extraLarge', extraLargeXML
      else
        fallback = customMaps[6][column]
      end
      printVote = gameStats.setMapName == '' and column == 1
    end
    local map, parseMarkers, reason, entry = choose(catalog, column, fallback, 1, true)
    load(map, parseMarkers, large)
    if reason == 'vote' then announceVote(entry, printVote) end
  end

  function gameMaps.loadReduced(largeCourt)
    local catalog, column, fallback, overrideIndex
    if largeCourt then
      overrideIndex, column = 2, 2
      if gameStats.teamsMode then
        catalog, fallback = customMapsFourTeamsMode, customMapsFourTeamsMode[34][2]
      elseif gameStats.threeTeamsMode then
        catalog, fallback = customMapsThreeTeamsMode, customMaps[6][2]
      else return end
    else
      catalog, column, fallback, overrideIndex = customMapsFourTeamsMode, 5, customMaps[6][1], 3
    end
    local map, parseMarkers, reason = choose(catalog, column, fallback, overrideIndex, false)
    load(map, parseMarkers, false, largeCourt and gameStats.teamsMode and reason == 'test')
  end
end

-- Metadata is read after 1 second; court preparation runs after 2.5 seconds.
-- Both timers wait for the requested map and are canceled when it is replaced.
function gameMaps.prepareCourt(placeAndSpawn)
  delaySpawnBall = addMapTimer(function(i)
    if i ~= 1 then return end
    updateBoundariesFromMap()
    placeAndSpawn()
  end, 2500)
  if globalSettings.minimalist then
    addMapTimer(function() gameStats.canTransform = true end, 4000)
  end
end

-- Platforms 4-alive: explicitly restore the bottom enclosures after map load.
-- Geometry copied from the exported XML; IDs do not overlap transformations,
-- native map grounds, side indicators or the player ceiling.
function gameMaps.restorePlatformsWalls()
  local target = tostring(gameState.map.sourceTarget or tfm.get.room.currentMap)
  if target ~= '@7985278' and target ~= '7985278' then return end
  for index, x in ipairs({255,1345,945,535,125,1475,665,1075}) do
    tfm.exec.addPhysicObject(99970 + index, x, 352.5, {
      type=10, width=10, height=65, angle=0, dynamic=false,
      friction=0.1, restitution=0.2, miceCollision=true,
      groundCollision=false, foreground=true
    })
  end
  -- Complete the two side stair platforms from the same XML.
  for index, ground in ipairs({
    {55.0,300.0,110.0,10.0},
    {1545.0,300.0,110.0,10.0},
    {75.0,240.0,60.0,10.0},
    {1525.0,240.0,60.0,10.0},
    {105.0,270.0,10.0,70.0},
    {1495.0,270.0,10.0,70.0},
  }) do
    tfm.exec.addPhysicObject(99959 + index, ground[1], ground[2], {
      type=10, width=ground[3], height=ground[4], angle=0, dynamic=false,
      friction=0.1, restitution=0.2, miceCollision=true,
      groundCollision=false, foreground=true
    })
  end
end
