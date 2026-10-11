function clubhouse.removeLobbyTextAreas()
  clubhouse.removeLobby()
  for i = 1, 13 do
    ui.removeTextArea(i)
  end
end
