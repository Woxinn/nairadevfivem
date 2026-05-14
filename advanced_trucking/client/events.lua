RegisterNetEvent('advanced_trucking:client:openTablet', function()
  lib.callback('advanced_trucking:server:getInitData', false, function(data)
    data = data or {}
    data.currentDepot = CurrentDepot and CurrentDepot.id or nil
    UI.Open(data)
  end)
end)

RegisterNetEvent('advanced_trucking:client:jobFailed', function(reason)
  FrameworkNotify = FrameworkNotify or function(msg) TriggerEvent('advanced_trucking:client:notify', msg) end
  FrameworkNotify(reason or 'Job failed')
  Routes.Clear()
  Vehicles.Cleanup()
end)
