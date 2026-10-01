function clubhouse.ballCategory(name)
  local state=clubhouse.ballCategoryState[name]
  if not state then
    state={selected="collection",pages={classic=1,collection=1,worldcup=1,special=1}}
    clubhouse.ballCategoryState[name]=state
  end
  return state
end

function clubhouse.ballItems(name,category)
  category=category or clubhouse.ballCategory(name).selected
  local items,indices={},{}
  for index,ball in ipairs(balls) do
    if (ball.category or "classic")==category then
      indices[#indices+1]=index
    end
  end
  table.sort(indices,function(a,b)
    local first,second=balls[a].categoryOrder or a,balls[b].categoryOrder or b
    return first==second and a<b or first<second
  end)
  for _,index in ipairs(indices) do items[#items+1]=balls[index] end
  return items,indices
end

function clubhouse.ballCategoryLabel(name)
  local view=clubhouse.views[name] and clubhouse.views[name].selector_balls
  if not view then return end
  local text=clubhouse.text(name,"tab.balls").." · "..clubhouse.text(name,"ball.category.label").." / "..clubhouse.text(name,"ball.category."..clubhouse.ballCategory(name).selected)
  clubhouse.label(name,"selector_balls","tab_right",text,
    view.categoryMenu and "ballCategoriesClose" or "ballCategoriesOpen","#DEC18A")
  local screen=clubhouse.screens.selector_balls
  local r=screen.regions.tab_right
  local available=#clubhouse.ballCategoryKeys
  for i,direction in ipairs({"previous","next"}) do
    local arrow=i==1 and "←" or "→"
    if available>1 then arrow="<a href='event:ballCategory:"..direction.."'>"..arrow.."</a>" end
    clubhouse.area(name,"selector_balls",97610+i,
      "<p align='center'><font face='Verdana' size='15' color='"..(available>1 and "#DEC18A" or "#718B83").."'>"..arrow.."</font></p>",
      screen.x+r.x+(i==1 and -2 or r.width-24),screen.y+r.y-1,26,25)
  end
end

function clubhouse.closeBallCategories(name)
  local view=clubhouse.views[name] and clubhouse.views[name].selector_balls
  if not view or not view.categoryMenu then return end
  view.categoryMenu=nil
  for id=97600,97600+#clubhouse.ballCategoryKeys do clubhouse.removeArea(name,"selector_balls",id) end
  if view.images.categoryMenu then tfm.exec.removeImage(view.images.categoryMenu);view.images.categoryMenu=nil end
  clubhouse.ballCategoryLabel(name)
end

function clubhouse.ballCategoryCallback(name,callback)
  if not selectBallOpen[name] or not (clubhouse.views[name] and clubhouse.views[name].selector_balls) then return end
  if callback=="ballCategoriesClose" then clubhouse.closeBallCategories(name);return end
  if callback=="ballCategoriesOpen" then
    clubhouse.closePageInput(name)
    local view=clubhouse.views[name].selector_balls
    if view.categoryMenu then return end
    view.categoryMenu=true
    local screen=clubhouse.screens.selector_balls
    local x,y=screen.x+435,screen.y+89
    clubhouse.area(name,"selector_balls",97600,"",x,y,190,98)
    clubhouse.image(name,"selector_balls","30-dropdown-map-sizes-190x98.png",x,y,"categoryMenu","~97600")
    local rowHeight=math.min(26,80/#clubhouse.ballCategoryKeys)
    for i,key in ipairs(clubhouse.ballCategoryKeys) do
      local items=clubhouse.ballItems(name,key)
      local selected=clubhouse.ballCategory(name).selected==key
      local text=clubhouse.escape(clubhouse.text(name,"ball.category."..key)).." ("..#items..")"
      local color=selected and "#DEC18A" or "#E3ECE7"
      text="<font color='"..color.."'>"..text.."</font>"
      text="<a href='event:ballCategory:"..key.."'>"..text.."</a>"
      if selected then text="<b>"..text.."</b>" end
      clubhouse.area(name,"selector_balls",97600+i,
        "<p align='center'><font face='"..(clubhouse.language(name)=="ar" and "Arial" or "Verdana").."' size='11' color='"..
        color.."'>"..text.."</font></p>",x+10,y+9+(i-1)*rowHeight,170,math.min(23,rowHeight))
    end
    clubhouse.ballCategoryLabel(name)
    return
  end
  local category=callback:match("^ballCategory:(%a+)$")
  local state=clubhouse.ballCategory(name)
  if category=="previous" or category=="next" then
    local step=category=="previous" and -1 or 1
    local keys=clubhouse.ballCategoryKeys
    local current=1
    for i,key in ipairs(keys) do if key==state.selected then current=i;break end end
    category=keys[(current-1+step)%#keys+1]
  end
  local known=false
  for _,key in ipairs(clubhouse.ballCategoryKeys) do
    if key==category then known=true;break end
  end
  if not known then return end
  if state.selected==category then clubhouse.closeBallCategories(name);return end
  state.pages[state.selected]=selectBallPage[name] or 1
  state.selected=category
  selectBallPage[name]=state.pages[category] or 1
  selectBallUI(name)
end

-- Update just the five actions when the shared map/ball cooldown expires.
function clubhouse.selectorActions(name,isBall,items,indices)
  local key=isBall and "selector_balls" or "selector"
  if not (clubhouse.views[name] and clubhouse.views[name][key]) then return end
  if not items then
    if isBall then items,indices=clubhouse.ballItems(name) else items,indices=availableMaps() end
  end
  local page=(isBall and selectBallPage or selectMapPage)[name] or 1
  local picking=not isBall and clubhouse.views[name][key].defaultMapPicker
  local enabled=(USER_PERMISSIONS[name] or 1)>1 and (picking or customMapCommand[name]) and gameState.phase=="startGame" and not gameStats.realMode
  for i=1,5 do
    local index=(page-1)*5+i
    if items[index] then
      local selectedIndex=indices[index]
      local selected=isBall and gameStats.customBall and gameStats.customBallId==selectedIndex or not isBall and gameStats.isCustomMap and gameStats.customMapIndex==selectedIndex
      if picking then selected=items[index][3]==globalSettings.defaultMap end
      clubhouse.label(name,key,"select_"..i,clubhouse.text(name,selected and (isBall and "ball.selected" or "map.selected") or "action.select"),
        not selected and enabled and ((picking and "setDefaultMap:" or isBall and "setball" or "setmap")..selectedIndex) or nil,selected and "#DEC18A" or enabled and "#E3ECE7" or "#718B83")
    end
  end
end

function clubhouse.selectionCooldown(name)
  customMapCommand[name]=false
  if clubhouse.selectionTimers[name] then removeTimer(clubhouse.selectionTimers[name]) end
  clubhouse.selectionTimers[name]=addTimer(function()
    clubhouse.selectionTimers[name]=nil
    if not tfm.get.room.playerList[name] then return end
    customMapCommand[name]=true
    clubhouse.selectorActions(name,false)
    clubhouse.selectorActions(name,true)
  end,2000,1,"clubhouseSelection:"..name)
end

function clubhouse.selector(name, isBall)
  local key=isBall and "selector_balls" or "selector"
  if not (clubhouse.views[name] and clubhouse.views[name][key]) then removeSelectUI(name) end
  clubhouse.closePageInput(name)
  if isBall then clubhouse.closeBallCategories(name) end
  clubhouse.clear(name,isBall and "selector" or "selector_balls")
  local s=clubhouse.panel(name,key)
  local picking=not isBall and clubhouse.state(name,key).defaultMapPicker
  clubhouse.closeLabel(name,key,picking and "returnDefaultSettings" or nil)
  local items,indices
  if isBall then items,indices=clubhouse.ballItems(name) else items,indices=availableMaps() end
  local pages=math.max(1,math.ceil(#items/5))
  local state=isBall and selectBallPage or selectMapPage
  local page=math.max(1,math.min(pages,math.floor(tonumber(state[name]) or 1)));state[name]=page
  if isBall then local category=clubhouse.ballCategory(name);category.pages[category.selected]=page end
  clubhouse.label(name,key,"tab_left",nil,isBall and "selectMap" or nil,not isBall and "#DEC18A" or "#A9BCB4")
  if isBall then clubhouse.ballCategoryLabel(name)
  else clubhouse.label(name,key,"tab_right",nil,"selectBall","#A9BCB4") end
  if picking then
    clubhouse.label(name,key,"tab_left",clubhouse.text(name,"defaultMap.title"),nil,"#DEC18A")
    clubhouse.label(name,key,"tab_right",clubhouse.text(name,"defaultMap.back"),"returnDefaultSettings")
  end
  for i=1,5 do
    local index=(page-1)*5+i;local item=items[index]
    if item then
      local title=isBall and item.name or item[3]
      clubhouse.label(name,key,"name_"..i,clubhouse.shorten(title,isBall and 38 or 18),not isBall and ("map"..item[3]) or nil)
      if not isBall then
        local vote=not picking and canVote[name] and gameState.phase=="startGame" and not gameStats.realMode
        clubhouse.label(name,key,"vote_"..i,picking and "" or clubhouse.text(name,"action.vote",{count=showMapVotes(items,indices[index])}),vote and "votemap"..indices[index] or nil,vote and "#E3ECE7" or "#718B83")
      end
      local r=s.regions["preview_"..i];local image=isBall and (item.previewImage or item.image) or item[6]
      if image and image~="" then
        local w=isBall and (item.previewSize or item.size or 40) or 100;local h=isBall and w or 43
        local view=clubhouse.state(name,key)
        -- Keep previews above the opaque frame and owned by this panel across map changes.
        clubhouse.imageId(name,key,image,s.x+r.x+math.floor((r.width-w)/2),s.y+r.y+math.floor((r.height-h)/2),"preview_"..i,"~"..view.ids["name_"..i])
      end
    end
  end
  if isBall and #items==0 then clubhouse.label(name,key,"name_3",clubhouse.text(name,"ball.category.empty")) end
  clubhouse.selectorActions(name,isBall,items,indices)
  clubhouse.navigation(name,key,page,pages,(isBall and "prevSelectBall" or "prevSelectMap")..(page-1),(isBall and "nextSelectBall" or "nextSelectMap")..(page+1))
  clubhouse.endUpdate(name,key)
end
