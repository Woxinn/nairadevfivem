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
