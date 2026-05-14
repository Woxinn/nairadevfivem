Config = {}
Config.Debug = false
Config.Locale = 'en'
Config.Framework = 'qbox' -- 'qbox', 'qb', 'esx', 'custom'
Config.Inventory = 'ox'
Config.Target = 'marker'
Config.Menu = 'nui'
Config.UseOxLib = true

Config.UI = { OpenKey = 'E', TabletCommand = 'trucking', EnableTabletAnimation = true }
Config.Database = { Resource = 'oxmysql', SaveHistory = true, SaveActiveJobs = false }
Config.Security = { MaxStartDistance = 5.0, MaxPickupDistance = 8.0, MaxDeliveryDistance = 10.0, MinimumDeliveryTimeSeconds = 60, EnableRateLimit = true, EventCooldownMs = 1000, LogExploitAttempts = true, DropPlayerOnSevereExploit = false }
Config.Contracts = { ShowLockedContracts = true, RefreshMode = 'per_player', RefreshMinutes = 15, MaxVisibleContracts = 8 }
Config.ContractMode = 'mixed'
Config.MaxContractsPerPlayer = 8

Config.Depots = {
  { id='ls_port', label='Los Santos Port Logistics', coords=vector4(1200.0,-3200.0,5.0,90.0), tabletCoords=vector3(1201.0,-3201.0,5.0), spawnPoints={vector4(1210.0,-3210.0,5.0,90.0)}, trailerSpawnPoints={vector4(1220.0,-3215.0,5.0,90.0)}, blip={enabled=true,sprite=477,color=5,scale=0.8,label='Trucking Depot'} }
}
Config.Trucks = { CompanyModels={'phantom','hauler','packer'} }
Config.Trailers = {'trailers','trailers2','tanker','tanker2','tr4','trailers4'}
Config.TruckMode = { AllowCompanyTruck=true, AllowOwnTruck=true, OwnTruckPaymentBonus=1.15, CompanyTruckPaymentMultiplier=0.95, RequireOwnedVehicle=false, AllowedOwnTruckModels={'phantom','hauler','packer'} }
Config.Payment = { Base=500, PerKm=120, PerfectDeliveryBonus=500, ExpressBonusMultiplier=1.25, RiskMultipliers={low=1.0,medium=1.2,high=1.5,extreme=1.8}, DifficultyMultipliers={easy=1.0,normal=1.15,hard=1.35,extreme=1.65}, DamagePenalty={Vehicle=0.5,Trailer=0.8,Cargo=1.0}, LatePenaltyPerMinute=50, MinimumPaymentPercent=0.25 }
Config.Reputation = { Enabled=true, Min=0, Max=100, Starting=50, Gains={CompletedDelivery=2,PerfectDelivery=5,OnTime=2,ConvoySuccess=3}, Losses={CancelJob=2,AbandonJob=5,DestroyVehicle=10,LateDelivery=3,HeavyCargoDamage=6}, PremiumContractRequired=70 }
Config.CargoDamage = { Enabled=true, MaxAllowedDamage=80, FailIfCargoDamageAbove=90, SensitivityMultipliers={low=0.5,medium=1.0,high=1.5,extreme=2.0}, TrailerDetachedPenalty=10, LatePenaltyMultiplier=0.5 }
Config.VehicleRules = { FailIfTruckDestroyed=true, FailIfTrailerDestroyed=true, AllowTrailerReconnect=true, TrailerReconnectTime=180, RequireSameTruck=true, RequireSameTrailer=true }
Config.RouteDifficulties = { easy={label='Easy',paymentMultiplier=1.0,xpMultiplier=1.0}, normal={label='Normal',paymentMultiplier=1.15,xpMultiplier=1.1}, hard={label='Hard',paymentMultiplier=1.35,xpMultiplier=1.3}, extreme={label='Extreme',paymentMultiplier=1.65,xpMultiplier=1.6} }
Config.TimeRules = { Enabled=true, DeliveryTypes={ standard={label='Standard Delivery',timeMultiplier=1.0,paymentMultiplier=1.0}, express={label='Express Delivery',timeMultiplier=0.75,paymentMultiplier=1.25}, urgent={label='Urgent Delivery',timeMultiplier=0.55,paymentMultiplier=1.5} }, LateGracePeriodMinutes=2, AllowLateDelivery=true }
Config.MultiStop = { Enabled=true, MaxStops=5, PayPerStop=true, RequireStopsInOrder=true }
Config.Convoy = { Enabled=true, MinPlayers=2, MaxPlayers=6, SharedReward=true, RequireAllDeliveriesForBonus=true, FailurePenaltyPercent=20 }
Config.RandomEvents = { Enabled=true, ChancePerDelivery=25, MaxEventsPerDelivery=1, Events={ urgent_bonus={enabled=true,chance=10,bonus=750,extraDeadlineMinutes=5}, route_change={enabled=true,chance=5}, trailer_warning={enabled=true,chance=8,cargoDamageRisk=5} } }
Config.Levels = { [1]={xp=0,label='Rookie Driver'}, [2]={xp=500,label='Local Driver'}, [3]={xp=1200,label='Road Driver'}, [5]={xp=3500,label='Heavy Cargo Driver'}, [10]={xp=10000,label='Professional Driver'}, [20]={xp=35000,label='Elite Logistics Operator'} }
Config.CargoTypes = { general={label='General Cargo',risk='low',paymentMultiplier=1.0,damageSensitive=false,timeSensitive=false,requiredLicense=nil,minLevel=1,allowedTrailers={'trailers','trailers2'}}, frozen={label='Frozen Goods',risk='medium',paymentMultiplier=1.4,damageSensitive=true,timeSensitive=true,requiredLicense='refrigerated',minLevel=3,allowedTrailers={'trailers2'}}, fuel={label='Fuel Tanker',risk='high',paymentMultiplier=1.8,damageSensitive=true,timeSensitive=false,requiredLicense='fuel_tanker',minLevel=8,allowedTrailers={'tanker','tanker2'}} }
Config.Licenses = { Enabled=true, RequireLicenseForCargo=true, Licenses={ basic={label='Basic Trucking License',requiredLevel=1,price=0}, refrigerated={label='Refrigerated Cargo License',requiredLevel=3,price=3000}, heavy_cargo={label='Heavy Cargo License',requiredLevel=5,price=5000}, fuel_tanker={label='Fuel Tanker License',requiredLevel=8,price=10000}, hazmat={label='Hazardous Material License',requiredLevel=10,price=15000} } }
Config.Missions = { Enabled=true, DailyResetHour=0, WeeklyResetDay=1, Daily={{id='daily_3_deliveries',label='Complete 3 deliveries',type='complete_deliveries',amount=3,rewards={money=1000,xp=150,reputation=1}}}, Weekly={{id='weekly_25_deliveries',label='Complete 25 deliveries',type='complete_deliveries',amount=25,rewards={money=10000,xp=1000,reputation=5}}} }
Config.Leaderboard = { Enabled=true, RefreshMinutes=10, Categories={'total_earnings','completed_deliveries','reputation','total_distance','perfect_deliveries','weekly_earnings'} }
Config.DiscordLogs = { Enabled=true, Webhook='', BotName='Advanced Trucking Logs', Avatar='', LogJobStart=true, LogJobComplete=true, LogPayments=true, LogSecurity=true, LogErrors=true }
Config.Admin = { UseAcePermissions=true, AcePermission='advancedtrucking.admin', AllowedGroups={'admin','god','superadmin'} }
Config.StaticContracts = {
  { id='contract_frozen_1', label='Frozen Food Delivery', cargoType='frozen', pickup='ls_port', delivery='paleto_market', deliveryCoords=vector3(170.0, 6643.0, 31.0), pickupCoords=vector3(1200.0,-3200.0,5.0), distance=8.4, estimatedTime=12, basePayment=3200, requiredLevel=3, requiredLicense='refrigerated', risk='medium', difficulty='hard', deadlineMinutes=15, trailerModel='trailers2', truckModels={'phantom','hauler'}, multiStop=false, stops={}, convoy=false }
}
