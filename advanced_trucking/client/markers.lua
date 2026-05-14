
CreateThread(function()
  for _, depot in pairs(Config.Depots) do
    local b = depot.blip
    if b and b.enabled then
      local blip = AddBlipForCoord(depot.coords.x, depot.coords.y, depot.coords.z)
      SetBlipSprite(blip, b.sprite or 477)
      SetBlipDisplay(blip, 4)
      SetBlipScale(blip, b.scale or 0.8)
      SetBlipColour(blip, b.color or 5)
      SetBlipAsShortRange(blip, true)
      BeginTextCommandSetBlipName('STRING')
      AddTextComponentString(b.label or depot.label or 'Trucking Depot')
      EndTextCommandSetBlipName(blip)
    end
  end
end)

Markers = { nearDepot = nil }

local function drawText3D(coords, text)
  SetDrawOrigin(coords.x, coords.y, coords.z, 0)
  BeginTextCommandDisplayText('STRING')
  SetTextScale(0.3, 0.3)
  SetTextCentre(true)
  AddTextComponentSubstringPlayerName(text)
  EndTextCommandDisplayText(0.0, 0.0)
  ClearDrawOrigin()
end

CreateThread(function()
  while true do
    local sleep = 1000
    local pCoords = GetEntityCoords(PlayerPedId())
    for _, depot in pairs(Config.Depots) do
      local d = #(pCoords - depot.tabletCoords)
      if d < 25.0 then
        sleep = 0
        DrawMarker(2, depot.tabletCoords.x, depot.tabletCoords.y, depot.tabletCoords.z + 0.2, 0.0,0.0,0.0, 0.0,0.0,0.0, 0.2,0.2,0.2, 60,120,255,180, false,true,2, nil,nil,false)
        if d < 2.0 then
          Markers.nearDepot = depot
          drawText3D(depot.tabletCoords + vector3(0.0,0.0,0.3), ('[%s] %s'):format(Config.UI.OpenKey, Utils.Locale('open_tablet')))
          if IsControlJustReleased(0, 38) then
            CurrentDepot = depot
            TriggerEvent('advanced_trucking:client:openTablet')
          end
        end
      end
    end
    Wait(sleep)
  end
end)
