function roomConfig.applyPermissions(config)
  config = config or roomConfig.readLobby()
  if not config then return false end
  for user, level in pairs(config.permissions) do
    if user and level then
      if user == roomConfig.creator.name then
        if roomConfig.creator.adminRevoked then
          level = level > 2 and level or 1
        else
          level = math.max(level, 2)
        end
      end
      roomConfig.permissions[user] = level
    end
  end
  return true
end
