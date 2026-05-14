Security = { cooldowns = {} }
function Security.RateLimit(src, key)
  if not Config.Security.EnableRateLimit then return false end
  local k = ('%s:%s'):format(src,key); local now = GetGameTimer(); local last = Security.cooldowns[k] or 0
  if now - last < Config.Security.EventCooldownMs then return true end Security.cooldowns[k]=now return false
end
function Security.Log(src, reason) print(('[SECURITY] %s (%s): %s'):format(GetPlayerName(src), Framework.GetIdentifier(src), reason)) end
