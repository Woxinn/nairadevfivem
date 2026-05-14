Licenses = {}

function Licenses.Has(identifier, license)
  if not license then return true end
  local row = MySQL.single.await('SELECT id FROM advanced_trucking_licenses WHERE identifier=? AND license=?', {identifier, license})
  return row ~= nil
end

function Licenses.GetAll(identifier)
  return MySQL.query.await('SELECT license FROM advanced_trucking_licenses WHERE identifier=?', {identifier}) or {}
end

function Licenses.Give(identifier, license, grantedBy)
  MySQL.insert.await('INSERT IGNORE INTO advanced_trucking_licenses (identifier, license, granted_by) VALUES (?, ?, ?)', {identifier, license, grantedBy or 'system'})
  return true
end

function Licenses.Remove(identifier, license)
  MySQL.update.await('DELETE FROM advanced_trucking_licenses WHERE identifier=? AND license=?', {identifier, license})
end

function Licenses.TryPurchase(src, licenseKey)
  local config = Config.Licenses.Licenses[licenseKey]
  if not config then return false, 'Invalid license' end

  local identifier = Framework.GetIdentifier(src)
  if Licenses.Has(identifier, licenseKey) then return false, 'Already owned' end

  local profile = DB.FetchProfile(identifier, Framework.GetName(src))
  if (profile.level or 1) < (config.requiredLevel or 1) then return false, 'Level too low' end

  -- price charging bridge can be expanded with Framework.RemoveMoney
  Licenses.Give(identifier, licenseKey, 'self_purchase')
  return true
end
