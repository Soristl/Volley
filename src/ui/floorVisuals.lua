-- Personal rendering of reviewed, hidden XML floors. No physics or score changes.
floorVisuals = {image = "1a0f8bd45b3.png"} -- Uploaded neutral 32px tile.
do
  local xml, pieces = nil, nil
  local viewers = {}
  local fields = {'T','X','Y','L','H','P','c'}

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
    for name in pairs(viewers) do floorVisuals.clearPlayer(name) end
    xml, pieces = value, nil
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
      if volleyGroundSignatures[table.concat(key, '|')] and (a.m ~= nil or a.T == '14') then
        local p = {}
        for value in ((a.P or '') .. ','):gmatch('(.-),') do p[#p+1] = tonumber(value) or 0 end
        local x, y, w, h = tonumber(a.X), tonumber(a.Y), tonumber(a.L), tonumber(a.H)
        if x and y and w and h and w > 0 and h > 0 and (p[1] or 0) == 0 then
          pieces[#pieces+1] = {x, y, w/32, h/32, (p[5] or 0)*math.pi/180}
        end
      end
    end
    return pieces
  end

  function floorVisuals.show(name)
    if not name or not tfm.get.room.playerList[name] or viewers[name] or not xml or floorVisuals.image == '' then return end
    local ids = {}
    for _, p in ipairs(geometry()) do
      local id = tfm.exec.addImage(floorVisuals.image, '?1001', p[1], p[2], name,
        p[3], p[4], p[5], 1, 0.5, 0.5)
      if id then ids[#ids+1] = id end
    end
    viewers[name] = ids
  end
end
