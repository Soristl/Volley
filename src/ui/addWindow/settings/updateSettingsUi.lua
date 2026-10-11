function clubhouse.refreshSettings(name)
  clubhouse.each(name, function(player) clubhouse.settings(player) end)
end
