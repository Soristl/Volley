function clubhouse.document(name, key, page)
  if not (clubhouse.views[name] and clubhouse.views[name][key]) then closeAllWindows(name)
  else clubhouse.closePageInput(name) end
  clubhouse.panel(name, key)
  clubhouse.closeLabel(name, key)
  if key == "help" then
    local pages = clubhouse.documentPages
    page = math.max(1, math.min(#pages, math.floor(tonumber(page) or 1)))
    pagesList[name].helpPage = page
    clubhouse.helpDocument(name, page)
    clubhouse.navigation(name, key, page, #pages, "prevHelp" .. (page-1), "nextHelp" .. (page+1))
  elseif key == "credits" then
    clubhouse.creditsDocument(name)
  elseif key == "real_rules" then
    clubhouse.realDocument(name)
  end
  clubhouse.endUpdate(name, key)
end
