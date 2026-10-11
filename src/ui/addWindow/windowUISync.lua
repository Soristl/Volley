function clubhouse.syncWindow(args)
  if (roomConfig.permissions[args[1]] or 1) > 2 then clubhouse.sync(args[1]) end
end
