-- Validate all access rules before applying any of them. Empty lists are valid;
-- missing attributes are not evidence that the room has no staff or bans.
function readLobbyConfig()
  local info = tfm.get.room.xmlMapInfo
  local xml = info and info.xml
  if type(xml) ~= "string" then return nil, "XML unavailable" end
  local properties = xml:match("<P%s+([^>]*)>")
  if not properties then return nil, "missing P attributes" end
  local function attribute(key)
    local padded = " " .. properties
    return padded:match('%s' .. key .. '%s*=%s*"([^"]*)"')
      or padded:match("%s" .. key .. "%s*=%s*'([^']*)'")
  end
  local permissions, bans, cutoff = attribute("USER_PERMISSIONS"), attribute("BAN"), attribute("TIMESTAMP")
  if permissions == nil or bans == nil or cutoff == nil then
    return nil, "missing USER_PERMISSIONS, BAN or TIMESTAMP"
  end
  cutoff = cutoff:match("^%s*(.-)%s*$")
  if not cutoff:match("^%d+$") or not tonumber(cutoff) or tonumber(cutoff) > 9007199254740991 then
    return nil, "invalid TIMESTAMP"
  end
  local config = { permissions = {}, bans = {}, timestamp = tonumber(cutoff) }
  if permissions:match("%S") then
    for entry in (permissions .. ","):gmatch("(.-),") do
      local user, level = entry:match("^%s*([^%s=,]+)%s*=%s*(%d+)%s*$")
      level = tonumber(level)
      if not user or not level or level < 1 or level > 5 or config.permissions[user] then
        return nil, "invalid USER_PERMISSIONS entry"
      end
      config.permissions[user] = level
    end
  end
  if bans:match("%S") then
    for entry in (bans .. ","):gmatch("(.-),") do
      local user = entry:match("^%s*([^%s,]+)%s*$")
      if not user then return nil, "invalid BAN entry" end
      config.bans[user] = true
    end
  end
  return config
end
