local LATENCY_GRADES = { "Perfect", "Good", "Fair", "Bad", "Terrible" }

function getSyncGrade(latency)
  -- Inlineable by Lua JIT if used often, but clear here

  -- math.floor(latency / 50) + 1 maps:
  -- 0-49 -> 1 (Perfect)
  -- 50-99 -> 2 (Good)
  -- ...
  -- 200-249 -> 5 (Terrible)
  -- 250+ -> nil (handled by 'or')
  return LATENCY_GRADES[math.floor(latency / 50) + 1] or "Terrible"
end
