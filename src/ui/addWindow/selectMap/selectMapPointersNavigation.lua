function selectMapPointersNavigation(name, page, maxPage)
  local str = ""
  for i = 1, maxPage do
    if page == i then
      str = "" .. str .. " <j>•<n>"
    else
      str = "" .. str .. " <a href='event:nextSelectMap" .. i .. "'>•</a>"
    end
  end

  ui.addTextArea(9999999999, "<p align='center'><font size='18px'>" .. str .. "", name, 347, 300, 200, 20, 0x161616,
    0x161616, 0, true)
end
