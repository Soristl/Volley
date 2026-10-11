function clubhouse.closeLegacyWindow(id, name)
  local number = tonumber(id)
  if number == 23 or number == 30 or number == 31 then clubhouse.clear(name, "launcher" .. number) end
  if number == 24 then
    for _, key in ipairs({"settings","selector","selector_balls","help","credits","sync","dropdown_modes","dropdown_map_sizes"}) do clubhouse.clear(name,key) end
  elseif number == 266 then clubhouse.clear(name,"real_rules") end
  local id = tostring(id)
  local str = "0"
  ui.removeTextArea(id, name)
  for i = 1, 9 do
    ui.removeTextArea(id .. "" .. str .. "", name)
    str = "" .. str .. "0"
  end
end
