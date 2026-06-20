local KEYS = {
  LEFT        = 0,
  UP          = 1,
  RIGHT       = 2,
  DOWN        = 3,
  -- Z        = 90
  -- X        = 88
  -- C        = 67
  -- V        = 86
  -- AFK      = { [0] = true, [1] = true, [2] = true, [3] = true },
  PROFILE     = 80,
  RANK        = 76,
  TRANSFORM   = 32,
  CONSUMABLES = { [55] = true, [56] = true, [57] = true, [48] = true },
  FORCE       = { [49] = true, [50] = true, [51] = true, [52] = true },
  SPAWN_ITEM  = 77
}

function bindKeys(name)
  for k, v in pairs(KEYS) do
    if type(v) == "number" then
      system.bindKeyboard(name, v, true, true)
    end

    if type(v) == "table" then
      for _, v2 in pairs(v) do
        system.bindKeyboard(name, v2, true, true)
      end
    end
  end
end
