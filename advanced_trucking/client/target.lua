Target = {}
CreateThread(function()
  if Config.Target ~= 'ox_target' then return end
  if not exports.ox_target then return end
  for _, depot in pairs(Config.Depots) do
    exports.ox_target:addSphereZone({
      coords = depot.tabletCoords,
      radius = 1.5,
      options = {
        {
          name = 'advanced_trucking_open_' .. depot.id,
          icon = 'fa-solid fa-truck',
          label = Utils.Locale('open_tablet'),
          onSelect = function()
            CurrentDepot = depot
            TriggerEvent('advanced_trucking:client:openTablet')
          end
        }
      }
    })
  end
end)
