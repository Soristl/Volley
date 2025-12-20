function spawnGetAdminButton()
  -- ui.addWindow(20, "<p align='center'><font size='13px'><a href='event:getAdmin'>Get Admin", name, 600, 370, 120, 30, 1, false, false, _)
  local id = 20
  local text = "<p align='center'><font size='13px'><a href='event:getAdmin'>Get Admin"
  local player = name
  
  local x = 670
  local y = 370
  local width = 120
  local height = 30
  local alpha = 1
    
  id = tostring(id)
  ui.addTextArea(id.."0", "", player, x+1, y+1, width-2, height-2, 0x8a583c, 0x8a583c, alpha, true)
  ui.addTextArea(id.."00", "", player, x+3, y+3, width-6, height-6, 0x2b1f19, 0x2b1f19, alpha, true)
  ui.addTextArea(id.."000", "", player, x+4, y+4, width-8, height-8, 0xc191c, 0xc191c, alpha, true)
  ui.addTextArea(id.."0000", "", player, x+5, y+5, width-10, height-10, 0x2d5a61, 0x2d5a61, alpha, true)
  ui.addTextArea(id.."00000", text, player, x+5, y+6, width-10, height-12, 0x142b2e, 0x142b2e, alpha, true)
end

function checkRoomkAdmins()
  for name, data in pairs(tfm.get.room.playerList) do
	if admins[data.playerName] then
      return true
    end
  end
  return false
end
