-- Remember the skin chosen when each ball was spawned, including late arrivals.
clubhouse.ballSkins = (function()
  local skins, images = {}, {}
  local api = {}

  local function removeBall(id)
    skins[id] = nil
    for _, owned in pairs(images) do
      if owned[id] then tfm.exec.removeImage(owned[id]); owned[id] = nil end
    end
  end

  local function draw(name, id, skin)
    images[name] = images[name] or {}
    if images[name][id] then return end
    images[name][id] = tfm.exec.addImage(skin.image, "#" .. id,
      skin.offset, skin.offset, name, skin.scale, skin.scale, 0, 10)
  end

  function api.spawn(id, ball)
    if not id then return end
    local stale = {}
    for previous in pairs(skins) do
      if previous == id or not tfm.get.room.objectList[previous] then stale[#stale+1] = previous end
    end
    for _, previous in ipairs(stale) do removeBall(previous) end
    if not ball or not ball.image or ball.image == "" then return end
    local scale = ball.skinScale or 1
    local skin = {image=ball.image, scale=scale, offset=-(ball.size or 40)*scale/2}
    skins[id] = skin
    for name in pairs(tfm.get.room.playerList) do draw(name, id, skin) end
  end

  function api.show(name)
    if mode ~= "gameStart" or not tfm.get.room.playerList[name] then return end
    local stale = {}
    for id, skin in pairs(skins) do
      if tfm.get.room.objectList[id] then draw(name, id, skin)
      else stale[#stale+1] = id end
    end
    for _, id in ipairs(stale) do removeBall(id) end
  end

  function api.clearPlayer(name)
    local owned = images[name]
    images[name] = nil
    for _, image in pairs(owned or {}) do tfm.exec.removeImage(image) end
  end

  function api.reset()
    local previous = images
    skins, images = {}, {}
    for _, owned in pairs(previous) do
      for _, image in pairs(owned) do tfm.exec.removeImage(image) end
    end
  end
  return api
end)()
