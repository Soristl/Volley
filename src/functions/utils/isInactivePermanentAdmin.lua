function isInactivePermanentAdmin(name)
  for i = 1, #inactivePermanentAdmins do
    local admin = inactivePermanentAdmins[i]
    if name == admin then
      return true
    end
  end

  return false
end