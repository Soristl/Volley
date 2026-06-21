function isPermanentAdmin(name)
  for i = 1, #permanentAdmins do
    local admin = permanentAdmins[i]
    if name == admin then
      return true
    end
  end

  return false
end
