Framework = {}

local QB

CreateThread(function()
  if Config.Framework == 'qb' then
    QB = exports['qb-core']:GetCoreObject()
  elseif Config.Framework == 'qbox' then
    -- qbox keeps qb-style player object in qbx_core exports for compatibility
    QB = exports['qbx_core']:GetCoreObject and exports['qbx_core']:GetCoreObject() or nil
  elseif Config.Framework == 'esx' then
    ESX = exports['es_extended']:getSharedObject()
  end
end)

local function getQboxPlayer(src)
  if exports.qbx_core and exports.qbx_core.GetPlayer then
    return exports.qbx_core:GetPlayer(src)
  end
  if QB and QB.Functions and QB.Functions.GetPlayer then
    return QB.Functions.GetPlayer(src)
  end
  return nil
end

function Framework.GetPlayer(src)
  if Config.Framework == 'qb' then
    return QB and QB.Functions.GetPlayer(src)
  elseif Config.Framework == 'qbox' then
    return getQboxPlayer(src)
  elseif Config.Framework == 'esx' then
    return ESX.GetPlayerFromId(src)
  end
  return nil
end

function Framework.GetIdentifier(src)
  local p = Framework.GetPlayer(src)
  if not p then return ('src:%s'):format(src) end

  if Config.Framework == 'qb' then
    return p.PlayerData.citizenid or p.PlayerData.license
  elseif Config.Framework == 'qbox' then
    local pd = p.PlayerData or p
    return pd.citizenid or pd.license or pd.identifier or ('src:%s'):format(src)
  else
    return p.identifier
  end
end

function Framework.GetName(src)
  local p = Framework.GetPlayer(src)
  if not p then return GetPlayerName(src) end

  if Config.Framework == 'qb' then
    return (p.PlayerData.charinfo.firstname .. ' ' .. p.PlayerData.charinfo.lastname)
  elseif Config.Framework == 'qbox' then
    local pd = p.PlayerData or p
    local c = pd.charinfo or {}
    if c.firstname and c.lastname then
      return c.firstname .. ' ' .. c.lastname
    end
    return pd.name or GetPlayerName(src)
  else
    return p.getName()
  end
end

function Framework.AddMoney(src, amount)
  local p = Framework.GetPlayer(src)
  if not p then return false end

  if Config.Framework == 'qb' then
    p.Functions.AddMoney('bank', amount, 'advanced-trucking')
  elseif Config.Framework == 'qbox' then
    if p.Functions and p.Functions.AddMoney then
      p.Functions.AddMoney('bank', amount, 'advanced-trucking')
    elseif exports.qbx_core and exports.qbx_core.AddMoney then
      exports.qbx_core:AddMoney(src, 'bank', amount, 'advanced-trucking')
    else
      return false
    end
  else
    p.addAccountMoney('bank', amount)
  end

  return true
end

function Framework.Notify(src, msg, t)
  TriggerClientEvent('advanced_trucking:client:notify', src, msg, t or 'inform')
end
