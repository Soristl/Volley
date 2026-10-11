function clubhouse.clearSelectors(name)
  clubhouse.clear(name, "selector")
  clubhouse.clear(name, "selector_balls")
  uiState.selectMapImages[name] = uiState.selectMapImages[name] or {}

  for i = 1, #uiState.selectMapImages[name] do
    tfm.exec.removeImage(uiState.selectMapImages[name][i])
  end
  uiState.selectMapImages[name] = {}
end
