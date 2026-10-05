-- Personal rendering of reviewed, hidden XML floors. No physics or score changes.
floorVisuals = {
  image = "1a0f8bd45b3.png", -- Neutral fallback for unsupported material types.
  materials = {
    [0] = {"1a10bba80c8.png", 110, 110}, -- Wood
    [1] = {"1a10bba9838.png", 108, 108}, -- Ice
    [2] = {"1a10bbaafa9.png", 109, 109}, -- Trampoline
    [3] = {"1a10bbac71a.png", 40, 40}, -- Lava
    [4] = {"1a10bbade8b.png", 110, 110}, -- Chocolate
    [5] = {"1a10bbaf5fb.png", 40, 40}, -- Earth
    [6] = {"1a10bbb0d6e.png", 40, 40}, -- Grass
    [7] = {"1a10bbb24de.png", 60, 60}, -- Sand
    [8] = {"1a10bbb3c50.png", 110, 110}, -- Cloud
    [10] = {"1a10bbb53c2.png", 40, 40}, -- Stone
    [11] = {"1a10bbb6b32.png", 40, 40}, -- Snow
    [17] = {"1a10bbb82a5.png", 40, 40}, -- Yellow grass
    [18] = {"1a10bbb9a17.png", 40, 40}, -- Pink grass
    [20] = {"1a10bbbb189.png", 40, 40}, -- Honey
  }
}
do
  local xml, pieces = nil, nil
  local viewers = {}
  local fields = {'T','X','Y','L','H','P','c'}
  -- Snowy Mountains slopes above the scoring-floor selection's Y cutoff.
  -- Render-only eligibility: do not add them to volleyGroundSignatures,
  -- which is also used by the point-scoring geometry.
  local visualOnlyGrounds = {
    ["11|-5|310|165|70|0,0,0.05,0.1,50,0,0,0|3"] = true,
    ["11|10|335|208|95|0,0,0.05,0.1,50,0,0,0|3"] = true,
    ["11|1190|335|208|95|0,0,0.05,0.1,-50,0,0,0|3"] = true,
    ["11|1205|310|165|70|0,0,0.05,0.1,-50,0,0,0|3"] = true,
    ["11|1600|310|165|70|0,0,0.05,0.1,-50,0,0,0|3"] = true,
    ["11|470|340|208|95|0,0,0.05,0.1,20,0,0,0|3"] = true,
    ["11|5|310|165|70|0,0,0.05,0.1,50,0,0,0|3"] = true,
    ["11|730|340|208|95|0,0,0.05,0.1,-20,0,0,0|3"] = true,
  }

  function floorVisuals.newGame()
    -- The engine has already discarded the previous map's images.
    xml, pieces, viewers = nil, nil, {}
  end

  function floorVisuals.clearPlayer(name)
    for _, id in ipairs(viewers[name] or {}) do tfm.exec.removeImage(id) end
    viewers[name] = nil
  end

  function floorVisuals.setXML(value)
    if xml == value then return end
    -- Do not delete iteration keys while traversing viewers (LuaJ host).
    local names = {}
    for name in pairs(viewers) do names[#names+1] = name end
    for _, name in ipairs(names) do floorVisuals.clearPlayer(name) end
    xml, pieces = value, nil
  end

  local function materialType(kind, p)
    -- Native materials keep their identity. Generic/invisible rectangles have
    -- no native texture: select a visual category from their XML coefficients.
    -- These are display thresholds, never replacements for physical values.
    if kind ~= 12 and kind ~= 14 then return kind end
    if (p[4] or 0.2) >= 1 then return 2 end
    if (p[3] or 0.3) <= 0.05 then return 1 end
    if (p[3] or 0.3) >= 1 then return 4 end
    return 0
  end

  local function geometry()
    if pieces then return pieces end
    pieces = {}
    local grounds = (xml or ''):match('<S>(.-)</S>') or ''
    for tag in grounds:gmatch('<S%s+([^>]+)>') do
      local a, key = {}, {}
      for k, quote, value in tag:gmatch('([%w_]+)%s*=%s*([\'"])(.-)%2') do a[k] = value end
      for i, field in ipairs(fields) do key[i] = a[field] or '' end
      -- Only real floors vetted from the XML exports: never restore markers,
      -- spawn boxes, scoring areas, spectator H-shapes or off-map boundaries.
      local signature = table.concat(key, '|')
      if (volleyGroundSignatures[signature] or visualOnlyGrounds[signature]) and (a.m ~= nil or a.T == '14') then
        local p = {}
        for value in ((a.P or '') .. ','):gmatch('(.-),') do p[#p+1] = tonumber(value) or 0 end
        local x, y, w, h = tonumber(a.X), tonumber(a.Y), tonumber(a.L), tonumber(a.H)
        if x and y and w and h and w > 0 and h > 0 and (p[1] or 0) == 0 then
          pieces[#pieces+1] = {x, y, w, h, (p[5] or 0)*math.pi/180, materialType(tonumber(a.T), p)}
        end
      end
    end
    return pieces
  end

  function floorVisuals.show(name)
    if not name or not tfm.get.room.playerList[name] or viewers[name] or not xml then return end
    local ids = {}
    for _, p in ipairs(geometry()) do
      local asset, w, h = floorVisuals.image, 32, 32
      local material = floorVisuals.materials[p[6]]
      if material and material[1] and material[1] ~= '' then
        asset, w, h = material[1], material[2], material[3]
      end
      if asset and asset ~= '' then
        local id = tfm.exec.addImage(asset, '?1001', p[1], p[2], name,
          p[3]/w, p[4]/h, p[5], 1, 0.5, 0.5)
        if id then ids[#ids+1] = id end
      end
    end
    viewers[name] = ids
  end
end
