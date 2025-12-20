function updateSettingsUI(playerName)
  if playerName ~= nil then
    local name = playerName

    if settings[name] then
      ui.addWindow(24, ""..playerLanguage[name].tr.titleSettings.."", name, 125, 60, 650, 300, 1, false, true, playerLanguage[name].tr.closeUIText)
      if pagePlayerSettings[name] == 1 then
        settingsPageOne(name)
      elseif pagePlayerSettings[name] == 2 then
        settingsPageTwo(name)
      end

      if pagePlayerSettings[name] == 1 then
        buttonNextOrPrev(26, name, 125, 300, 200, 30, 1, "<n2>"..playerLanguage[name].tr.previousMessage.."</n>")
      else
        buttonNextOrPrev(26, name, 125, 300, 200, 30, 1, "<a href='event:prevSettings"..tostring(pagePlayerSettings[name] - 1).."'>"..playerLanguage[name].tr.previousMessage.."</a>")
      end
      
      if pagePlayerSettings[name] == maxPageSettings then
        buttonNextOrPrev(27, name, 575, 300, 200, 30, 1, "<n2>"..playerLanguage[name].tr.nextMessage.."</n>")
      else
        buttonNextOrPrev(27, name, 575, 300, 200, 30, 1, "<a href='event:nextSettings"..tostring(pagePlayerSettings[name] + 1).."'>"..playerLanguage[name].tr.nextMessage.."</a>")
      end
    end

    return
  end

  for name, data in pairs(tfm.get.room.playerList) do
    if settings[name] then
      ui.addWindow(24, ""..playerLanguage[name].tr.titleSettings.."", name, 125, 60, 650, 300, 1, false, true, playerLanguage[name].tr.closeUIText)
      ui.addTextArea(99992, ""..playerLanguage[name].tr.textSettings.."", name, 150, 110, 500, 200, 0x161616, 0x161616, 0, true)
      if pagePlayerSettings[name] == 1 then
        settingsPageOne(name)
      elseif pagePlayerSettings[name] == 2 then
        settingsPageTwo(name)
      end

      if pagePlayerSettings[name] == 1 then
        buttonNextOrPrev(26, name, 125, 300, 200, 30, 1, "<n2>"..playerLanguage[name].tr.previousMessage.."</n>")
      else
        buttonNextOrPrev(26, name, 125, 300, 200, 30, 1, "<a href='event:prevSettings"..tostring(pagePlayerSettings[name] - 1).."'>"..playerLanguage[name].tr.previousMessage.."</a>")
      end
      
      if pagePlayerSettings[name] == maxPageSettings then
        buttonNextOrPrev(27, name, 575, 300, 200, 30, 1, "<n2>"..playerLanguage[name].tr.nextMessage.."</n>")
      else
        buttonNextOrPrev(27, name, 575, 300, 200, 30, 1, "<a href='event:nextSettings"..tostring(pagePlayerSettings[name] + 1).."'>"..playerLanguage[name].tr.nextMessage.."</a>")
      end
    end
  end
end
