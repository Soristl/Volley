function initUsersPermissions()
  local mapXML = tfm.get.room.xmlMapInfo.xml
  print(#mapXML)

  local pTag = string.match(mapXML, '<C><P%s+([^>]+)/')
  local users = string.match(pTag, 'USER_PERMISSIONS="([^"]+)"')

  -- USER_PERMISSIONS = {}
  for entry in users:gmatch("[^,]+") do
    local user, level = entry:match("%s*(.-)%s*=%s*(%d+)")
    level = tonumber(level)

    if user and level then
        USER_PERMISSIONS[user] = level
    end
  end
end