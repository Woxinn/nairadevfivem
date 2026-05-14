Reputation = {}
function Reputation.Apply(profile, delta) profile.reputation = Utils.Clamp((profile.reputation or Config.Reputation.Starting)+delta, Config.Reputation.Min, Config.Reputation.Max) return profile.reputation end
