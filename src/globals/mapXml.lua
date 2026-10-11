local mapXml = {}

function mapXml.source(map)
  if type(map) == "string" and map:find("<", 1, true) then return map end
  local info = tfm.get.room.xmlMapInfo
  return info and type(info.xml) == "string" and info.xml or ""
end

function mapXml.attribute(tag, key)
  return tag:match('%s' .. key .. '%s*=%s*"([^"]*)"')
    or tag:match("%s" .. key .. "%s*=%s*'([^']*)'")
end

function mapXml.number(value)
  if type(value) ~= "string" then return nil end
  value = value:match("^%s*(.-)%s*$")
  if not value:match("^[+-]?%d+%.?%d*$") and not value:match("^[+-]?%.%d+$") then return nil end
  local number = tonumber(value)
  if number and number == number and math.abs(number) < math.huge then return number end
end
