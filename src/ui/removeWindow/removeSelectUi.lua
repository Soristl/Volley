function removeSelectUI(name)
  clubhouse.clear(name, "selector")
  clubhouse.clear(name, "selector_balls")
  selectMapImages[name] = selectMapImages[name] or {}

  for i = 1, #selectMapImages[name] do
    tfm.exec.removeImage(selectMapImages[name][i])
  end
  selectMapImages[name] = {}
end
