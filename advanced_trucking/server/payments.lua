Payments = {}
function Payments.Calculate(job, contract, vehicleDamage, trailerDamage, cargoDamage)
  local base = contract.basePayment or Config.Payment.Base
  local distanceBonus = math.floor((contract.distance or 0) * Config.Payment.PerKm)
  local riskM = Config.Payment.RiskMultipliers[contract.risk] or 1.0
  local diffM = Config.Payment.DifficultyMultipliers[contract.difficulty] or 1.0
  local gross = math.floor((base + distanceBonus) * riskM * diffM)
  local penalties = math.floor(vehicleDamage * Config.Payment.DamagePenalty.Vehicle + trailerDamage * Config.Payment.DamagePenalty.Trailer + cargoDamage * Config.Payment.DamagePenalty.Cargo)
  local final = math.max(math.floor(gross * Config.Payment.MinimumPaymentPercent), gross - penalties)
  return {base=base,distanceBonus=distanceBonus,gross=gross,penalties=penalties,final=final}
end
