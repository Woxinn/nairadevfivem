local ActiveJobs = {}

local function vec3From(v) return vector3(v.x + 0.0, v.y + 0.0, v.z + 0.0) end

local function nearPoint(src, coords, maxDist)
  local ped = GetPlayerPed(src)
  if ped <= 0 then return false end
  local p = GetEntityCoords(ped)
  return #(p - coords) <= maxDist
end

lib.callback.register('advanced_trucking:server:getInitData', function(src)
  local identifier = Framework.GetIdentifier(src)
  local profile = DB.FetchProfile(identifier, Framework.GetName(src))
  return {
    profile=profile,
    contracts=Contracts.GetVisible(src, profile),
    activeJob=ActiveJobs[identifier],
    missions=Missions.GetForPlayer(identifier),
    leaderboard=Leaderboard.GetTop()
  }
end)

RegisterNetEvent('advanced_trucking:server:startContract', function(contractId, mode)
  local src = source
  if Security.RateLimit(src,'start') then return end

  local identifier = Framework.GetIdentifier(src)
  if ActiveJobs[identifier] then return Framework.Notify(src, Utils.Locale('already_has_job'), 'error') end

  local contract = Contracts.GetById(src, contractId)
  if not contract then return Security.Log(src, 'invalid contract id') end

  if not nearPoint(src, vec3From(contract.pickupCoords), Config.Security.MaxStartDistance + 30.0) then
    return Security.Log(src, 'start too far from depot/pickup')
  end

  local profile = DB.FetchProfile(identifier, Framework.GetName(src))
  if profile.level < contract.requiredLevel then return Framework.Notify(src, Utils.Locale('not_enough_level'), 'error') end
  if Config.Licenses.Enabled and not Licenses.Has(identifier, contract.requiredLicense) then return Framework.Notify(src, Utils.Locale('missing_license'), 'error') end

  local token = ('%s:%s:%s'):format(identifier, contract.id, os.time())
  ActiveJobs[identifier] = {
    token=token,
    contractId=contract.id,
    startedAt=os.time(),
    pickupDone=false,
    completed=false,
    mode=mode or 'company',
    pickupCoords=contract.pickupCoords,
    deliveryCoords=contract.deliveryCoords,
    truckNet=0,
    trailerNet=0
  }

  contract.mode = mode or 'company'
  TriggerClientEvent('advanced_trucking:client:onContractStarted', src, contract, token)
  Logs.Discord('Job Started', ('%s started %s (%s)'):format(Framework.GetName(src), contract.id, mode or 'company'))
end)

RegisterNetEvent('advanced_trucking:server:pickupCargo', function(token, truckNet, trailerNet)
  local src = source
  local identifier = Framework.GetIdentifier(src)
  local job = ActiveJobs[identifier]
  if not job or job.token ~= token then return Security.Log(src, 'pickup invalid token') end
  if job.pickupDone then return end

  if not nearPoint(src, vec3From(job.pickupCoords), Config.Security.MaxPickupDistance) then
    return Security.Log(src, 'pickup too far')
  end

  job.truckNet = tonumber(truckNet) or 0
  job.trailerNet = tonumber(trailerNet) or 0
  job.pickupDone = true
end)

RegisterNetEvent('advanced_trucking:server:deliver', function(token, truckNet, trailerNet)
  local src = source
  local identifier = Framework.GetIdentifier(src)
  local job = ActiveJobs[identifier]

  if not job or job.token ~= token or job.completed then return Security.Log(src, 'deliver invalid token/state') end
  if not job.pickupDone then return Security.Log(src, 'deliver before pickup') end
  if os.time() - job.startedAt < Config.Security.MinimumDeliveryTimeSeconds then return Security.Log(src, 'delivery too fast') end
  if not nearPoint(src, vec3From(job.deliveryCoords), Config.Security.MaxDeliveryDistance) then return Security.Log(src, 'delivery too far') end

  local contract = Contracts.GetById(src, job.contractId)
  if not contract then return Security.Log(src, 'deliver contract not found') end

  local effectiveTruckNet = tonumber(truckNet) or job.truckNet
  local effectiveTrailerNet = tonumber(trailerNet) or job.trailerNet

  local truckEnt = effectiveTruckNet > 0 and NetworkGetEntityFromNetworkId(effectiveTruckNet) or 0
  local trailerEnt = effectiveTrailerNet > 0 and NetworkGetEntityFromNetworkId(effectiveTrailerNet) or 0
  local truckHealth = (truckEnt > 0 and DoesEntityExist(truckEnt)) and GetVehicleBodyHealth(truckEnt) or 1000.0
  local trailerHealth = (trailerEnt > 0 and DoesEntityExist(trailerEnt)) and GetVehicleBodyHealth(trailerEnt) or 1000.0

  local vehicleDamage = math.floor(math.max(0.0, (1000.0 - truckHealth) / 10.0))
  local trailerDamage = math.floor(math.max(0.0, (1000.0 - trailerHealth) / 10.0))
  local cargoDamage = math.floor((vehicleDamage + trailerDamage) / 2)

  local payment = Payments.Calculate(job, contract, vehicleDamage, trailerDamage, cargoDamage)
  local xp = math.floor((contract.distance or 1) * (Config.RouteDifficulties[contract.difficulty] and (35 * Config.RouteDifficulties[contract.difficulty].xpMultiplier) or 35))

  local profile = DB.FetchProfile(identifier, Framework.GetName(src))
  profile.xp = (profile.xp or 0) + xp
  profile.level = Progression.GetLevelFromXP(profile.xp)
  profile.completed_deliveries = (profile.completed_deliveries or 0) + 1
  profile.total_distance = (profile.total_distance or 0) + (contract.distance or 0)
  profile.total_earnings = (profile.total_earnings or 0) + payment.final
  profile.weekly_earnings = (profile.weekly_earnings or 0) + payment.final

  local repGain = Config.Reputation.Gains.CompletedDelivery
  if cargoDamage <= 5 then repGain = repGain + Config.Reputation.Gains.PerfectDelivery end
  Reputation.Apply(profile, repGain)

  DB.UpdateProfile(identifier, profile)
  DB.InsertHistory({identifier=identifier,contract_id=contract.id,cargo_type=contract.cargoType,pickup_label=contract.pickup,delivery_label=contract.delivery,distance=contract.distance,payment=payment.final,xp=xp,reputation_change=repGain,vehicle_damage=vehicleDamage,trailer_damage=trailerDamage,cargo_damage=cargoDamage,completed=true})
  Missions.ApplyDeliveryProgress(identifier)

  Framework.AddMoney(src, payment.final)
  Framework.Notify(src, Utils.Locale('payment_received', payment.final), 'success')
  TriggerClientEvent('advanced_trucking:client:showDeliveryReport', src, {contract=contract,payment=payment,xp=xp,reputation=repGain,vehicleDamage=vehicleDamage,trailerDamage=trailerDamage,cargoDamage=cargoDamage})

  TriggerEvent('advanced_trucking:server:onDeliveryCompleted', src, identifier, contract, payment.final)
  TriggerEvent('advanced_trucking:server:onPlayerXPChanged', src, identifier, profile.xp, profile.level)
  TriggerEvent('advanced_trucking:server:onReputationChanged', src, identifier, profile.reputation)

  job.completed = true
  ActiveJobs[identifier] = nil
end)

lib.callback.register('advanced_trucking:server:getLicenses', function(src)
  local identifier = Framework.GetIdentifier(src)
  return Licenses.GetAll(identifier)
end)

RegisterNetEvent('advanced_trucking:server:buyLicense', function(licenseKey)
  local src = source
  if Security.RateLimit(src, 'buyLicense') then return end
  local ok, err = Licenses.TryPurchase(src, licenseKey)
  if not ok then
    return Framework.Notify(src, err or 'License purchase failed', 'error')
  end
  Framework.Notify(src, 'License unlocked.', 'success')
end)

RegisterCommand('trucking_refreshcontracts', function(source)
  local src = source
  if src == 0 or IsPlayerAceAllowed(src, Config.Admin.AcePermission) then
    if src == 0 then
      for _, id in ipairs(GetPlayers()) do
        local pid = tonumber(id)
        local profile = DB.FetchProfile(Framework.GetIdentifier(pid), Framework.GetName(pid))
        Contracts.RefreshBoard(pid, profile)
      end
      print('[advanced_trucking] Contract boards refreshed.')
    else
      local profile = DB.FetchProfile(Framework.GetIdentifier(src), Framework.GetName(src))
      Contracts.RefreshBoard(src, profile)
      Framework.Notify(src, 'Contract board refreshed.', 'success')
    end
  end
end, true)


lib.callback.register('advanced_trucking:server:getMissions', function(src)
  local identifier = Framework.GetIdentifier(src)
  return Missions.GetForPlayer(identifier)
end)

RegisterNetEvent('advanced_trucking:server:claimMissionReward', function(missionId, period)
  local src = source
  if Security.RateLimit(src, 'claimMissionReward') then return end
  local identifier = Framework.GetIdentifier(src)
  local ok, err = Missions.Claim(src, identifier, missionId, period)
  if not ok then
    return Framework.Notify(src, err or 'Mission claim failed', 'error')
  end
  Framework.Notify(src, 'Mission reward claimed.', 'success')
end)
