local function canBecomeRoomCreator(name)
  local data = tfm.get.room.playerList[name]
  return data ~= nil and not name:find("*", 1, true) and not playerState.ban[name] and not playerState.left[name]
    and (roomConfig.statisticsCutoff == 0 or (data.registrationDate or 0) <= roomConfig.statisticsCutoff)
end

function roomConfig.assignCreator(name)
  if roomConfig.creator.name or roomConfig.creator.selectionClosed or not canBecomeRoomCreator(name) then
    return
  end

  -- Remember the first arrival while the initial map loads staff and bans.
  if roomConfig.firstRun then
    roomConfig.creator.pendingName = roomConfig.creator.pendingName or name
    return
  end

  roomConfig.creator.name = name
  roomConfig.permissions[name] = math.max(roomConfig.permissions[name] or 1, 2)
  tfm.exec.chatMessage("<vp>" .. name .. " is the Room Creator.<n>", nil)
  if gameState.phase == "startGame" then
    ui.addWindow(31, "<p align='center'><font size='13px'><a href='event:settings'>Room settings", name,
      180, 370, 150, 30, 1, false, false)
  end
end

function roomConfig.initializeCreator()
  local candidate
  for name in pairs(tfm.get.room.playerList) do
    if canBecomeRoomCreator(name) then
      if candidate then
        -- A script loaded into an occupied room has no arrival history.
        -- Do not choose an arbitrary owner from an unordered player list.
        roomConfig.creator.selectionClosed = true
        return
      end
      candidate = name
    end
  end
  if candidate then
    roomConfig.assignCreator(candidate)
  end
end
