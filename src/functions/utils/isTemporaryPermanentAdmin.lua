function isTemporaryPermanentAdmin(name)
  for i = 1, #temporaryPermanentAdmins do
    local admin = temporaryPermanentAdmins[i]
    if name == admin then
      return true
    end
  end

  return false
end
