DB = {}
function DB.FetchProfile(identifier, name)
  local row = MySQL.single.await('SELECT * FROM advanced_trucking_profiles WHERE identifier = ?', {identifier})
  if row then return row end
  MySQL.insert.await('INSERT INTO advanced_trucking_profiles (identifier, name, xp, level, reputation) VALUES (?, ?, 0, 1, ?)', {identifier, name, Config.Reputation.Starting})
  return MySQL.single.await('SELECT * FROM advanced_trucking_profiles WHERE identifier = ?', {identifier})
end
function DB.UpdateProfile(identifier, fields)
  MySQL.update.await('UPDATE advanced_trucking_profiles SET xp=?, level=?, reputation=?, completed_deliveries=?, failed_deliveries=?, perfect_deliveries=?, total_earnings=?, weekly_earnings=?, total_distance=?, updated_at=NOW() WHERE identifier=?', {
    fields.xp,fields.level,fields.reputation,fields.completed_deliveries,fields.failed_deliveries,fields.perfect_deliveries,fields.total_earnings,fields.weekly_earnings,fields.total_distance,identifier
  })
end
function DB.InsertHistory(data)
  if not Config.Database.SaveHistory then return end
  MySQL.insert.await('INSERT INTO advanced_trucking_history (identifier, contract_id, cargo_type, pickup_label, delivery_label, distance, payment, xp, reputation_change, vehicle_damage, trailer_damage, cargo_damage, completed) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
    {data.identifier,data.contract_id,data.cargo_type,data.pickup_label,data.delivery_label,data.distance,data.payment,data.xp,data.reputation_change,data.vehicle_damage,data.trailer_damage,data.cargo_damage,data.completed and 1 or 0})
end
