function initUsersPermissions(config)
  config = config or readLobbyConfig()
  if not config then return false end
  for user, level in pairs(config.permissions) do
    if user and level then
      if user == roomCreator.name then
        if roomCreator.adminRevoked then
          level = level > 2 and level or 1
        else
          level = math.max(level, 2)
        end
      end
      USER_PERMISSIONS[user] = level
    end
  end
  return true
end
