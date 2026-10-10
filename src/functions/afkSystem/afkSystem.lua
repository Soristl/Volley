function afkSystem()
  local now = os.time()
  local inactive, connected = {}, 0
  for name in pairs(tfm.get.room.playerList) do
    connected = connected + 1
    local last = playersAfk[name]
    -- A player may appear in the host list before their arrival is initialized.
    -- Start their inactivity clock instead of subtracting an absent timestamp.
    if type(last) ~= 'number' or last ~= last or math.abs(last) == math.huge then
      last = now
      playersAfk[name] = now
    end
    local elapsed = now - last
    if elapsed >= 10 * 60 * 1000 then
      inactive[#inactive + 1] = { name=name, timestamp=elapsed }
    end
  end

  local capacity = tfm.get.room.maxPlayers
  local reserve = capacity >= 17 and capacity <= 20 and 4 or 3
  local needed = reserve - (capacity - connected)
  -- Preserve the existing admission policy, including over-capacity rooms.
  if connected > capacity or needed <= 0 or #inactive == 0 then return end
  table.sort(inactive, function(a, b) return a.timestamp > b.timestamp end)
  local message = '<bv>You have been kicked out of the room for being inactive for too long.<n>'
  for index = 1, math.min(needed, #inactive) do
    print(message)
    tfm.exec.chatMessage(message, inactive[index].name)
    tfm.exec.kickPlayer(inactive[index].name)
  end
end
