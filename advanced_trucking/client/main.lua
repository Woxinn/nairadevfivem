CurrentContract = nil
CurrentToken = nil
CurrentDepot = nil

CreateThread(function()
  RegisterCommand(Config.UI.TabletCommand, function()
    TriggerEvent('advanced_trucking:client:openTablet')
  end)
end)

RegisterCommand('trucking_pickup', function()
  if not CurrentToken then return end
  local truck = Vehicles.truck or GetVehiclePedIsIn(PlayerPedId(), false)
  local trailer = Vehicles.trailer
  TriggerServerEvent('advanced_trucking:server:pickupCargo', CurrentToken, truck and NetworkGetNetworkIdFromEntity(truck) or 0, trailer and NetworkGetNetworkIdFromEntity(trailer) or 0)
  if CurrentContract and CurrentContract.deliveryCoords then
    Routes.SetDelivery(CurrentContract.deliveryCoords)
  end
end)

RegisterCommand('trucking_deliver', function()
  if not CurrentToken then return end
  local truck = Vehicles.truck or GetVehiclePedIsIn(PlayerPedId(), false)
  local trailer = Vehicles.trailer
  TriggerServerEvent('advanced_trucking:server:deliver', CurrentToken, truck and NetworkGetNetworkIdFromEntity(truck) or 0, trailer and NetworkGetNetworkIdFromEntity(trailer) or 0)
end)

RegisterNetEvent('advanced_trucking:client:notify', function(msg)
  if lib then
    lib.notify({description=msg})
  else
    SetNotificationTextEntry('STRING')
    AddTextComponentString(msg)
    DrawNotification(false,false)
  end
end)

RegisterNetEvent('advanced_trucking:client:onContractStarted', function(contract, token)
  CurrentContract = contract
  CurrentToken = token
  if contract.mode == 'company' then
    local ok, err = Vehicles.SpawnCompanySet(contract)
    if not ok then
      TriggerEvent('advanced_trucking:client:notify', err or 'Failed to spawn company vehicle.')
      return
    end
  end
  if contract.pickupCoords then Routes.SetPickup(contract.pickupCoords) end
  TriggerEvent('advanced_trucking:client:notify', Utils.Locale('job_started'))
end)

RegisterNetEvent('advanced_trucking:client:showDeliveryReport', function(report)
  SendNUIMessage({action='deliveryReport',payload=report})
  Routes.Clear()
  Vehicles.Cleanup()
  CurrentContract = nil
  CurrentToken = nil
end)
