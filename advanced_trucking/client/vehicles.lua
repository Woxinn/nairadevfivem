Vehicles = {
  truck = nil,
  trailer = nil
}

local function loadModel(model)
  local hash = type(model) == 'number' and model or joaat(model)
  RequestModel(hash)
  local timeout = GetGameTimer() + 10000
  while not HasModelLoaded(hash) and GetGameTimer() < timeout do Wait(50) end
  return hash, HasModelLoaded(hash)
end

function Vehicles.SpawnCompanySet(contract)
  local ped = PlayerPedId()
  local depot = CurrentDepot
  if not depot then return false, 'No depot selected' end
  local truckSpawn = depot.spawnPoints[1]
  local trailerSpawn = depot.trailerSpawnPoints[1]

  local truckModel = contract.truckModels and contract.truckModels[1] or Config.Trucks.CompanyModels[1]
  local trailerModel = contract.trailerModel or Config.Trailers[1]

  local truckHash, okTruck = loadModel(truckModel)
  local trailerHash, okTrailer = loadModel(trailerModel)
  if not okTruck or not okTrailer then return false, 'Model load failed' end

  Vehicles.truck = CreateVehicle(truckHash, truckSpawn.x, truckSpawn.y, truckSpawn.z, truckSpawn.w, true, false)
  Vehicles.trailer = CreateVehicle(trailerHash, trailerSpawn.x, trailerSpawn.y, trailerSpawn.z, trailerSpawn.w, true, false)
  SetVehicleOnGroundProperly(Vehicles.truck)
  SetVehicleOnGroundProperly(Vehicles.trailer)
  SetEntityAsMissionEntity(Vehicles.truck, true, true)
  SetEntityAsMissionEntity(Vehicles.trailer, true, true)

  TaskWarpPedIntoVehicle(ped, Vehicles.truck, -1)
  AttachVehicleToTrailer(Vehicles.truck, Vehicles.trailer, 5.0)

  SetModelAsNoLongerNeeded(truckHash)
  SetModelAsNoLongerNeeded(trailerHash)
  return true
end

function Vehicles.Cleanup()
  if Vehicles.truck and DoesEntityExist(Vehicles.truck) then DeleteEntity(Vehicles.truck) end
  if Vehicles.trailer and DoesEntityExist(Vehicles.trailer) then DeleteEntity(Vehicles.trailer) end
  Vehicles.truck = nil
  Vehicles.trailer = nil
end
