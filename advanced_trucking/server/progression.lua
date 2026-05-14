Progression = {}
function Progression.GetLevelFromXP(xp) local lvl=1 for k,v in pairs(Config.Levels) do if xp>=v.xp and k>lvl then lvl=k end end return lvl end
