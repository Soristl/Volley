function settingsPageTwo(name) 
  ui.addTextArea(99992, ""..playerLanguage[name].tr.textSettings2.."", name, 150, 110, 500, 200, 0x161616, 0x161616, 0, true)
  
  if settingsMode[name] then
    local modes = getMapTypesActions()
    local str = ''

    for i = 1, #modes do
      str = ""..str..""..modes[i].."<br>"
    end

    ui.addWindow(25, "<p align='center'><font size='11px'><a href='event:closeMapType'>Select map</a><br><br>"..str.."", name, 665, 100, 100, 100, 1, false, false)
  else
    ui.addWindow(25, "<p align='center'><font size='11px'><a href='event:openMapType'>Select map</a>", name, 665, 100, 100, 30, 1, false, false)
  end

  ui.addWindow(25, "<p align='center'><font size='11px'><a href='event:openMapType'>Select map</a>", name, 665, 100, 100, 30, 1, false, false)

  if globalSettings.consumables then
    ui.addWindow(21, "<p align='center'><font size='11px'><a href='event:consumables'>Enabled</a>", name, 665, 150, 100, 30, 1, false, false)
  else
    ui.addWindow(21, "<p align='center'><font size='11px'><a href='event:consumables'>Disabled</a>", name, 665, 150, 100, 30, 1, false, false)
  end

  if globalSettings.threeBalls then
    ui.addWindow(44, "<p align='center'><font size='11px'><a href='event:threeballs'>Enabled</a>", name, 665, 200, 100, 30, 1, false, false)
  else
    ui.addWindow(44, "<p align='center'><font size='11px'><a href='event:threeballs'>Disabled</a>", name, 665, 200, 100, 30, 1, false, false)
  end
end