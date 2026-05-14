Utils = {}
function Utils.Locale(k, ...) local msg = (Locales[Config.Locale] and Locales[Config.Locale][k]) or k return string.format(msg, ...) end
function Utils.Debug(...) if Config.Debug then print('^3[advanced_trucking]^7', ...) end end
function Utils.Clamp(v,min,max) if v<min then return min elseif v>max then return max end return v end
function Utils.TableHas(t, val) for _,v in pairs(t or {}) do if v==val then return true end end return false end
