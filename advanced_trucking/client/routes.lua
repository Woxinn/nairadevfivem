Routes = {
  pickupBlip = nil,
  deliveryBlip = nil,
  currentDeliveryCoords = nil
}

function Routes.Clear()
  if Routes.pickupBlip then RemoveBlip(Routes.pickupBlip) Routes.pickupBlip = nil end
  if Routes.deliveryBlip then RemoveBlip(Routes.deliveryBlip) Routes.deliveryBlip = nil end
  Routes.currentDeliveryCoords = nil
  ClearGpsMultiRoute()
end

function Routes.SetPickup(coords)
  if Routes.pickupBlip then RemoveBlip(Routes.pickupBlip) end
  Routes.pickupBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
  SetBlipSprite(Routes.pickupBlip, 1)
  SetBlipColour(Routes.pickupBlip, 5)
  SetBlipRoute(Routes.pickupBlip, true)
  BeginTextCommandSetBlipName('STRING')
  AddTextComponentString('Cargo Pickup')
  EndTextCommandSetBlipName(Routes.pickupBlip)
end

function Routes.SetDelivery(coords)
  if Routes.deliveryBlip then RemoveBlip(Routes.deliveryBlip) end
  Routes.currentDeliveryCoords = coords
  Routes.deliveryBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
  SetBlipSprite(Routes.deliveryBlip, 1)
  SetBlipColour(Routes.deliveryBlip, 2)
  SetBlipRoute(Routes.deliveryBlip, true)
  BeginTextCommandSetBlipName('STRING')
  AddTextComponentString('Cargo Delivery')
  EndTextCommandSetBlipName(Routes.deliveryBlip)
end
