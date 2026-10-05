function commandHandlers.cmdBackgroundDiagnostic(args)
  mapBackgrounds.diagnose(args[1])
end

function commandHandlers.cmdBackgroundRefresh(args)
  mapBackgrounds.refresh(args[1])
end
